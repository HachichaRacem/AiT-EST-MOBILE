import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:aiesec_im/utils/user.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Current user throughout the application lifecycle.
  final User user = MainController.user!;

  // State Management variables
  List<String> routesHistory = [];
  final RxBool hasConfirmedExit = RxBool(false);

  // Constants needed
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final tableColumns = ['Name', 'EP ID', 'Phone number'];

  @override
  void onInit() {
    hasConfirmedExit.listen((value) {
      if (value) {
        Future.delayed(
            const Duration(seconds: 5), () => hasConfirmedExit.value = false);
      }
    });
    super.onInit();
  }
}
