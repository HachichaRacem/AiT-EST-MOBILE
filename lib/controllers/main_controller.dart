import 'package:aiesec_im/controllers/auth_controller.dart';
import 'package:aiesec_im/utils/exception.dart';
import 'package:aiesec_im/utils/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainController extends GetxController {
  static final Dio dio = Dio(
    BaseOptions(
      followRedirects: true,
      connectTimeout: const Duration(seconds: 55),
      sendTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(minutes: 1),
    ),
  );
  static User? user;

  Future<void> _refreshToken(DioException error, ErrorInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    if (refreshToken != null) {
      final refreshReq = await dio.post(
        'https://auth.aiesec.org/oauth/token',
        queryParameters: {'grant_type': 'refresh_token', 'refresh_token': refreshToken},
        options: Options(
          headers: {
            'Authorization':
                'Basic NTVkNTkxMTczNmJjYjdmZDI5Njk3ODhkMzdlZTJlNDRjMmE0M2FhYWRjMDg5ODkwM2RjNzNjNzFlN2UyMmNmZTpjODAwMWJmZjgwMDdlZmYxOTUxMTIzNTExNzU1ZWZkNTM4MjlhNTZlOTlmMjNiM2VhY2I0MTQzNTc0MTRlNWE1'
          },
        ),
      );
      final requestQueryParams = error.requestOptions.queryParameters;
      final requestData = error.requestOptions.data;
      final requestMethod = error.requestOptions.method;
      final requestHeaders = error.requestOptions.headers;
      final requestUrl = error.requestOptions.path;
      requestQueryParams['access_token'] = refreshReq.data['access_token'];
      if (requestHeaders.containsKey('Authorization')) {
        requestHeaders['Authorization'] = refreshReq.data['access_token'];
      }
      final result = await dio.request(
        requestUrl,
        queryParameters: requestQueryParams,
        data: requestData,
        options: Options(method: requestMethod, headers: requestHeaders),
      );
      await prefs.setString('access_token', refreshReq.data['access_token']);
      await prefs.setString('refresh_token', refreshReq.data['refresh_token']);
      handler.resolve(result);
    } else {
      throw NoRefreshTokenException();
    }
  }

  @override
  void onInit() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.type == DioExceptionType.connectionTimeout) {
            Get.showSnackbar(
              GetSnackBar(
                messageText: Text("Connection took too long",
                    textAlign: TextAlign.center, style: GoogleFonts.lato(color: Colors.white)),
                duration: const Duration(seconds: 3),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                borderRadius: 16,
              ),
            );
            handler.next(error);
          } else if (error.type == DioExceptionType.receiveTimeout) {
            Get.showSnackbar(
              GetSnackBar(
                messageText: Text("Server took too long to respond",
                    textAlign: TextAlign.center, style: GoogleFonts.lato(color: Colors.white)),
                duration: const Duration(seconds: 3),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                borderRadius: 16,
              ),
            );
            handler.next(error);
          } else if (error.type == DioExceptionType.sendTimeout) {
            Get.showSnackbar(
              GetSnackBar(
                messageText: Text("took too long to send request",
                    textAlign: TextAlign.center, style: GoogleFonts.lato(color: Colors.white)),
                duration: const Duration(seconds: 3),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                borderRadius: 16,
              ),
            );
            handler.next(error);
          } else if (error.type == DioExceptionType.connectionError) {
            Get.showSnackbar(
              GetSnackBar(
                messageText: Text("Encountered connectivity issues",
                    textAlign: TextAlign.center, style: GoogleFonts.lato(color: Colors.white)),
                duration: const Duration(seconds: 3),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                borderRadius: 16,
              ),
            );
            handler.next(error);
          } else if (error.response != null) {
            if (error.response?.statusCode == 401 &&
                error.response?.statusMessage == 'Unauthorized') {
              if (error.requestOptions.uri.authority == 'auth.aiesec.org') {
                handler.reject(error);
              } else {
                try {
                  await _refreshToken(error, handler);
                } catch (e) {
                  Get.showSnackbar(
                    const GetSnackBar(
                      message: 'Session expired.',
                      duration: Duration(seconds: 3),
                      isDismissible: true,
                    ),
                  );
                  if (Get.currentRoute == '/auth') {
                    Get.find<AuthController>().sendToEXPA.value = true;
                  } else {
                    Get.offAllNamed('/auth');
                  }
                }
              }
            }
          } else {
            Get.showSnackbar(
              GetSnackBar(
                messageText: Text("Encountered connectivity issues",
                    textAlign: TextAlign.center, style: GoogleFonts.lato(color: Colors.white)),
                duration: const Duration(seconds: 3),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                borderRadius: 16,
              ),
            );
          }
        },
      ),
    );
    super.onInit();
  }
}
