import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:aiesec_im/controllers/home_controller.dart';
import 'package:aiesec_im/controllers/statistics_controller.dart';
import 'package:aiesec_im/screens/about_screen.dart';
import 'package:aiesec_im/screens/ep_profile_screen.dart';
import 'package:aiesec_im/screens/eps_screen.dart';
import 'package:aiesec_im/screens/leads_management_screen.dart';
import 'package:aiesec_im/screens/statistics_screen.dart';
import 'package:aiesec_im/utils/nav_observer.dart';
import 'package:aiesec_im/widgets/custom_appbar.dart';
import 'package:aiesec_im/widgets/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends GetView<HomeController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (Get.nestedKey(0)?.currentState != null) {
          if (_scaffoldKey.currentState!.isDrawerOpen) {
            _scaffoldKey.currentState!.closeDrawer();
          } else {
            if (Get.nestedKey(0)!.currentState!.canPop()) {
              Get.back(id: 0);
            } else {
              if (!controller.hasConfirmedExit.value) {
                Toastification().show(
                  closeButtonShowType: CloseButtonShowType.none,
                  autoCloseDuration: const Duration(seconds: 5),
                  context: context,
                  title: Text("Exit confirmation", style: GoogleFonts.inter()),
                  closeOnClick: true,
                  type: ToastificationType.info,
                  style: ToastificationStyle.flat,
                  description: const Text("Press once again to exit the application"),
                );
                controller.hasConfirmedExit.value = true;
              } else {
                SystemNavigator.pop();
              }
            }
          }
        } else {
          Get.log("[HOME SCREEN]: Get.nestedKey(0).currentState is null");
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFEFF5FD),
        drawer: NavDrawer(_scaffoldKey),
        body: Column(
          children: [
            CustomAppBar(
              scaffoldKey: _scaffoldKey,
            ),
            Expanded(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x1018280D))
                  ],
                  color: Colors.white,
                ),
                child: Navigator(
                  observers: [MyObserver()],
                  key: Get.nestedKey(0),
                  initialRoute: '/statistics',
                  onGenerateRoute: (settings) {
                    switch (settings.name) {
                      case '/':
                        return GetPageRoute(
                          routeName: '/',
                          settings: const RouteSettings(name: '/'),
                          page: () => const EpsScreen(),
                          binding: BindingsBuilder.put(
                            () => EpsController(),
                          ),
                          transition: Transition.downToUp,
                        );
                      case '/statistics':
                        return GetPageRoute(
                          routeName: '/statistics',
                          settings: const RouteSettings(name: '/statistics'),
                          page: () => const StatisticsScreen(),
                          binding: BindingsBuilder.put(
                            () => StatisticsController(),
                          ),
                        );
                      case '/epProfile':
                        return GetPageRoute(
                          routeName: '/epProfile',
                          settings: const RouteSettings(name: '/epProfile'),
                          page: () => EpProfileScreen(
                            epData: controller.appBarSelectedEP!,
                          ),
                          transition: Transition.downToUp,
                        );
                      case '/leadsManagement':
                        return GetPageRoute(
                          routeName: '/leadsManagement',
                          settings: const RouteSettings(name: '/leadsManagement'),
                          page: () => const LeadsManagementScreen(),
                          transition: Transition.downToUp,
                          binding: BindingsBuilder.put(
                            () => EpsController(),
                          ),
                        );
                      case '/about':
                        return GetPageRoute(
                          routeName: '/about',
                          settings: const RouteSettings(name: '/about'),
                          page: () => const AboutScreen(),
                          transition: Transition.downToUp,
                        );
                      default:
                        return GetPageRoute(
                          routeName: '/statistics',
                          settings: const RouteSettings(name: '/statistics'),
                          page: () => const StatisticsScreen(),
                          binding: BindingsBuilder.put(
                            () => StatisticsController(),
                          ),
                        );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
