import 'dart:convert';

import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:aiesec_im/utils/exception.dart';
import 'package:aiesec_im/utils/user.dart';
import 'package:aiesec_im/widgets/debug_dialog.dart';
import 'package:aiesec_im/widgets/error_dialogs.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  // Tag used for debugging purposes
  final String _tag = 'AuthController';

  /* General state management */
  final RxBool sendToEXPA = RxBool(false);
  bool caughtAccessToken = false;
  bool isUserLoggedIn = false;

  /* Error management */
  final RxBool hasErrors = RxBool(false);
  String? errorMessage;

  // Called once the screen is building
  @override
  void onReady() async {
    try {
      await _authenticateUser();
      isUserLoggedIn = true;
      await Get.dialog(DebugDialog(), barrierDismissible: false);
      if (MainController.user!.isMC) {
        await Get.dialog(const McHeadsUpDialog(), barrierDismissible: false);
      }
      Get.offAllNamed('/home');
    } on NoAccountException {
      sendToEXPA.value = true;
    } catch (e, stack) {
      hasErrors.value = true;
      if (e is DioException) {
        errorMessage = 'Could not successfully communicate with EXPA';
      } else {
        Get.log("$e\n$stack");
        errorMessage = 'Something went wrong';
      }
    }
    super.onReady();
  }

  // Loads user data using EXPA endpoint with accessToken provided from the login flow or stored previously
  Future<void> _loadUserData(String accessToken, String refreshToken) async {
    final response = await MainController.dio.get(
      'https://gis-api.aiesec.org/v2/current_person/personal_dump',
      queryParameters: {'access_token': accessToken},
    );
    MainController.user = User(response.data, accessToken: accessToken, refreshToken: refreshToken);
  }

  // Verifies if token exists before on device storage then proceeds to load user data using EXPA
  // Otherwise, it throws a NoAccountException which is handled in the onReady method.
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

  // Method used to update the SharedPreference with the access and refresh tokens passed to it.
  Future<void> _updateSP(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  // Click handlers
  void onRefreshClick() {
    sendToEXPA.value = true;
    hasErrors.value = false;
  }

  // WebView handlers (You can consider this part as the registration flow)
  // onAjaxReadyStateChange called as the requests are exchanged, it "listens" to the one holding the access token
  // then stores it, loads user data, updates SP and handles errors.
  Future<AjaxRequestAction?> onAjaxReadyStateChange(
      InAppWebViewController webController, AjaxRequest ajaxRequest) async {
    if (ajaxRequest.url!.path.contains('/oauth/token') && ajaxRequest.responseText!.isNotEmpty) {
      final Map<String, dynamic> response = jsonDecode(ajaxRequest.responseText!);
      await webController.stopLoading();
      await CookieManager.instance().deleteAllCookies();
      await webController.platform.clearAllCache();
      await WebStorageManager.instance().deleteAllData();
      try {
        if (!caughtAccessToken) {
          caughtAccessToken = true;
          await _loadUserData(response['access_token'], response['refresh_token']);
          await _updateSP(response['access_token'], response['refresh_token']);
          await Get.dialog(DebugDialog(), barrierDismissible: false);
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
