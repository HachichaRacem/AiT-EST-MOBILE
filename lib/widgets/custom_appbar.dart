import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:aiesec_im/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_icon/gradient_icon.dart';

class CustomAppBar extends GetView<HomeController> {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.fromLTRB(8, 40, 8, 13),
        height: controller.appBarType.value == 0 ? 75 : 100,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 26,
              width: 26,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => scaffoldKey.currentState!.openDrawer(),
                icon: const GradientIcon(
                  size: 26,
                  offset: Offset.zero,
                  icon: Icons.menu,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF387ADF),
                      Color(0xFF50C4ED),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Obx(
                  () => FadeTransition(
                    opacity: controller.appBarFadeAnim,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.appBarType.value == 0
                              ? "Welcome, ${controller.user.firstName}"
                              : "Time to manage your EPs !",
                          style: GoogleFonts.lato(
                              color: const Color(0xFF101828),
                              fontSize: controller.appBarType.value == 0 ? 20 : 16,
                              fontWeight: FontWeight.w700),
                        ),
                        if (controller.appBarType.value == 0)
                          Text(
                            "Visualize your statistics below!",
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFA6A6A6),
                            ),
                          ),
                        if (controller.appBarType.value != 0)
                          const Padding(padding: EdgeInsets.only(top: 8.0), child: _SearchBar())
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CircleAvatar(
              radius: 15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: SvgPicture.network(
                    "https://cdn-expa.aiesec.org/gis-img/missing_profile_${controller.user.fullName![0].toLowerCase()}.svg"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends GetView<EpsController> {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final linearGradient =
        const LinearGradient(colors: [Color(0xFF387ADF), Color(0xFF50C4ED)]).createShader(
      const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
    );
    final defaultStyle = GoogleFonts.lato(
      fontSize: 13,
      foreground: Paint()..shader = linearGradient,
      decoration: TextDecoration.none,
      decorationThickness: 0,
    );
    return SizedBox(
      height: 32,
      width: 200,
      child: TextField(
        onChanged: controller.onSearchBarTextChange,
        controller: controller.appBarSearchCtrl,
        enableIMEPersonalizedLearning: false,
        textAlignVertical: TextAlignVertical.center,
        autocorrect: false,
        enableSuggestions: false,
        style: defaultStyle,
        cursorHeight: 18.0,
        decoration: InputDecoration(
          suffixIcon: const GradientIcon(
            size: 20,
            offset: Offset(23, 5.5),
            icon: Icons.search,
            gradient: LinearGradient(
              colors: [
                Color(0xFF387ADF),
                Color(0xFF50C4ED),
              ],
            ),
          ),
          hintText: "Search",
          filled: true,
          fillColor: const Color(0xFFEFF5FD),
          contentPadding: const EdgeInsets.only(left: 8),
          hintStyle: defaultStyle,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}
