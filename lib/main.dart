import 'package:aiesec_im/controllers/auth_controller.dart';
import 'package:aiesec_im/controllers/home_controller.dart';
import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:aiesec_im/screens/auth_screen.dart';
import 'package:aiesec_im/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/color_scheme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return const Color(0xFFFBA834);
              }
              return Theme.of(context).colorScheme.surface;
            },
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      initialBinding: BindingsBuilder.put(() => MainController()),
      getPages: [
        GetPage(
            name: '/auth',
            page: () => const AuthScren(),
            binding: BindingsBuilder.put(() => AuthController())),
        GetPage(
            name: '/home',
            page: () => HomeScreen(),
            binding: BindingsBuilder.put(() => HomeController())),
      ],
      initialRoute: '/auth',
      debugShowCheckedModeBanner: false,
    );
  }
}
