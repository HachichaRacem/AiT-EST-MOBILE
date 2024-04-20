import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:aiesec_im/controllers/home_controller.dart';
import 'package:aiesec_im/screens/ep_profile_screen.dart';
import 'package:aiesec_im/screens/eps_screen.dart';
import 'package:aiesec_im/screens/leads_management_screen.dart';
import 'package:aiesec_im/utils/nav_observer.dart';
import 'package:aiesec_im/widgets/custom_appbar.dart';
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
          if (Get.nestedKey(0)!.currentState!.canPop()) {
            Get.nestedKey(0)!.currentState!.pop();
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
        } else {
          Get.log("[HOME SCREEN]: Get.nestedKey(0).currentState is null");
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFEFF5FD),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${controller.user.fullName}",
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "${controller.user.position} - ${controller.user.department}",
                        style: GoogleFonts.inter(fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),
              if (controller.user.position == "LCVP" || controller.user.position == "TL")
                ListTile(
                  title: const Text("Leads Management"),
                  onTap: () {
                    if (MyObserver.history.contains('/leadsManagement')) {
                      Get.until((route) => MyObserver.history.last == '/leadsManagement', id: 0);
                    } else {
                      Get.toNamed('/leadsManagement', id: 0);
                    }
                    _scaffoldKey.currentState?.closeDrawer();
                  },
                )
            ],
          ),
        ),
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
                  initialRoute: '/',
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
                        );
                      case '/epProfile':
                        return GetPageRoute(
                          routeName: '/epProfile',
                          settings: const RouteSettings(name: '/epProfile'),
                          page: () {
                            final Map<String, dynamic> arguments =
                                settings.arguments as Map<String, dynamic>;
                            return EpsProfilesScreen(
                              data: arguments['data'],
                              openedEpIndex: arguments['index'],
                            );
                          },
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
                      default:
                        return GetPageRoute(
                          routeName: '/',
                          settings: const RouteSettings(name: '/'),
                          page: () => const EpsScreen(),
                          binding: BindingsBuilder.put(
                            () => EpsController(),
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
