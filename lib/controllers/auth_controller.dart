import 'dart:convert';

import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:aiesec_im/utils/exception.dart';
import 'package:aiesec_im/utils/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final String _tag = 'AuthController';

  /* General state management */
  final RxBool sendToEXPA = RxBool(false);
  bool caughtAccessToken = false;

  /* Error management */
  final RxBool hasErrors = RxBool(false);
  String? errorMessage;

  @override
  void onReady() async {
    try {
      await _authenticateUser();
      Get.offAllNamed('/home');
    } on NoAccountException {
      sendToEXPA.value = true;
    } catch (e) {
      hasErrors.value = true;
      if (e is DioException) {
        errorMessage = 'Could not successfully communicate with EXPA';
      } else {
        errorMessage = 'Something went wrong';
      }
    }
    super.onReady();
  }

  Future<void> _loadUserData(String accessToken, String refreshToken) async {
    final response = await MainController.dio.get(
      'https://gis-api.aiesec.org/v2/current_person/personal_dump',
      queryParameters: {'access_token': accessToken},
    );
    MainController.user = User(response.data,
        accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> _authenticateUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('access_token')) {
      final accessToken = prefs.getString('access_token');
      final refreshToken = prefs.getString('refresh_token');
      if (accessToken != null) {
        await _loadUserData(accessToken, refreshToken!);
      }
    } else {
      throw NoAccountException();
    }
  }

  Future<void> _updateSP(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', accessToken);
    prefs.setString('refresh_token', refreshToken);
  }

  void onRefreshClick() {
    sendToEXPA.value = true;
    hasErrors.value = false;
  }

  Future<AjaxRequestAction?> onAjaxReadyStateChange(
      InAppWebViewController webController, AjaxRequest ajaxRequest) async {
    if (ajaxRequest.url!.path.contains('/oauth/token') &&
        ajaxRequest.responseText!.isNotEmpty) {
      final Map<String, dynamic> response =
          jsonDecode(ajaxRequest.responseText!);
      await webController.stopLoading();
      await CookieManager.instance().deleteAllCookies();
      await webController.platform.clearAllCache();
      await WebStorageManager.instance().deleteAllData();
      try {
        if (!caughtAccessToken) {
          caughtAccessToken = true;
          await _loadUserData(
              response['access_token'], response['refresh_token']);
          await _updateSP(response['access_token'], response['refresh_token']);
          Get.offAllNamed('/home');
        }
      } on DioException catch (_) {
        caughtAccessToken = false;
        hasErrors.value = true;
        errorMessage = 'Could not successfully communicate with EXPA';
      } catch (e) {
        Get.log('[$_tag]: $e');
      }
    }
    return AjaxRequestAction.PROCEED;
  }
}
