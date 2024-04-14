import 'package:aiesec_im/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScren extends GetView<AuthController> {
  const AuthScren({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      backgroundColor: const Color(0xFF037ef3),
      body: SafeArea(
        child: Obx(
          () {
            if (controller.hasErrors.value) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${controller.errorMessage}',
                        style: GoogleFonts.inter(color: Colors.white)),
                    IconButton(
                      onPressed: controller.onRefreshClick,
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              );
            } else {
              return IndexedStack(
                index: controller.sendToEXPA.value ? 0 : 1,
                children: [
                  InAppWebView(
                    initialSettings: InAppWebViewSettings(transparentBackground: true),
                    initialUrlRequest: URLRequest(
                      url: WebUri('https://expa.aiesec.org'),
                    ),
                    onLoadStart: (webController, url) {
                      if (url?.path == '/') {
                        controller.sendToEXPA.value = false;
                      } else if (url?.path == '/auth') {
                        controller.sendToEXPA.value = false;
                      }
                    },
                    onAjaxReadyStateChange: controller.onAjaxReadyStateChange,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/loading.gif',
                      height: 110,
                      width: 110,
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
