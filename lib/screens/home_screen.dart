import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:aiesec_im/controllers/home_controller.dart';
import 'package:aiesec_im/screens/ep_profile_screen.dart';
import 'package:aiesec_im/screens/eps_screen.dart';
import 'package:aiesec_im/screens/leads_management_screen.dart';
import 'package:aiesec_im/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            controller.routesHistory.removeLast();
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
        backgroundColor: Colors.transparent,
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
                    Get.log("[PopUntil]: histroy: ${controller.routesHistory}");
                    _scaffoldKey.currentState?.closeDrawer();
                    if (controller.routesHistory.contains("/leadsManagement")) {
                      if (controller.routesHistory.last != "/leadsManagement") {
                        Get.nestedKey(0)!.currentState?.popUntil((route) {
                          controller.routesHistory.removeLast();
                          return controller.routesHistory.last == "/leadsManagement";
                        });
                      }
                    } else {
                      Get.nestedKey(0)!.currentState?.pushNamed('/leadsManagement');
                    }
                  },
                )
            ],
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: CustomAppBar(
            firstName: "${controller.user.firstName}",
            leading: DrawerButton(
              onPressed: () {
                controller.routesHistory.add("/drawer");
                _scaffoldKey.currentState?.openDrawer();
              },
              style: const ButtonStyle(
                iconColor: MaterialStatePropertyAll(Colors.white),
              ),
            ),
            trailing: CircleAvatar(
              radius: 15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: SvgPicture.network(
                    "https://cdn-expa.aiesec.org/gis-img/missing_profile_${controller.user.fullName![0].toLowerCase()}.svg"),
              ),
            ),
          ),
        ),
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF387ADF), Color(0xFF50C4ED)],
            ),
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Colors.white,
            ),
            child: Navigator(
              key: Get.nestedKey(0),
              initialRoute: '/',
              onGenerateRoute: (settings) {
                if (settings.name != null) {
                  controller.routesHistory.add(settings.name!);
                }
                switch (settings.name) {
                  case '/':
                    return GetPageRoute(
                      routeName: '/',
                      page: () => const EpsScreen(),
                      binding: BindingsBuilder.put(
                        () => EpsController(),
                      ),
                    );
                  case '/epProfile':
                    return GetPageRoute(
                      routeName: '/epProfile',
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
                      page: () => const LeadsManagementScreen(),
                      transition: Transition.downToUp,
                      binding: BindingsBuilder.put(
                        () => EpsController(),
                      ),
                    );
                  default:
                    return GetPageRoute(
                      routeName: '/',
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
      ),
    );
  }
}
