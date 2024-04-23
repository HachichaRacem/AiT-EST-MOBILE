import 'package:aiesec_im/controllers/auth_controller.dart';
import 'package:aiesec_im/utils/exception.dart';
import 'package:aiesec_im/utils/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainController extends GetxController {
  // Dio instance (for handling network communication)
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.1.11:3000", //Change accordingly
      followRedirects: true,
      connectTimeout: const Duration(seconds: 45),
      sendTimeout: const Duration(seconds: 40),
      receiveTimeout: const Duration(seconds: 50),
    ),
  );

  // Main instance of the User
  static User? user;

  // Used to refresh the user token when needed and resends the failed request.
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

  // Adds an interceptor to the Dio instance
  // which handles errors, mainly to handle any failed requests due to expired access token
  // but also handles other errors
  @override
  void onInit() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          Get.log("$error");
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
            return;
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
            return;
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
            return;
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
            return;
          } else if (error.response != null) {
            if (error.response?.statusCode == 401 &&
                error.response?.statusMessage == 'Unauthorized') {
              if (error.requestOptions.uri.authority == 'auth.aiesec.org') {
                handler.reject(error);
                return;
              } else {
                try {
                  await _refreshToken(error, handler);
                  return;
                } catch (e) {
                  Get.showSnackbar(
                    GetSnackBar(
                      messageText: Text("Session expired",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(color: Colors.white)),
                      duration: const Duration(seconds: 3),
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      borderRadius: 16,
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
          handler.next(error);
        },
      ),
    );
    super.onInit();
  }
}
