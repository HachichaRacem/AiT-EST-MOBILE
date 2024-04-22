import 'package:aiesec_im/controllers/home_controller.dart';
import 'package:aiesec_im/utils/nav_observer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NavDrawer extends GetView<HomeController> {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  const NavDrawer(this._scaffoldKey, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFEFF5FD),
      surfaceTintColor: const Color(0xFFEFF5FD),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
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
          ),
          _DrawerTile(_scaffoldKey,
              leadingIcon: Icons.pie_chart_rounded, title: "Statistics", destination: "/"),
          _DrawerTile(_scaffoldKey, leadingIcon: Icons.settings, title: "CRM", destination: "/crm"),
          if (controller.user.position == "LCVP" || controller.user.position == "TL")
            _DrawerTile(_scaffoldKey,
                leadingIcon: Icons.person, title: "Leads", destination: "/leadsManagement"),
          _DrawerTile(_scaffoldKey,
              leadingIcon: Icons.info_rounded, title: "About", destination: "/about"),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final IconData leadingIcon;
  final String title;
  final String destination;
  const _DrawerTile(
    this._scaffoldKey, {
    required this.leadingIcon,
    required this.title,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 8, right: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        tileColor: Colors.white,
        title: Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF101828),
          ),
        ),
        leading: Icon(
          leadingIcon,
          color: const Color(0xFFFBA834),
        ),
        onTap: () {
          if (MyObserver.history.contains(destination)) {
            Get.until((route) => MyObserver.history.last == destination, id: 0);
          } else {
            Get.toNamed(destination, id: 0);
          }
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }
}
