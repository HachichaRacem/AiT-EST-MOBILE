import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:get/get.dart';

class StatisticsController extends GetxController {
  final RxInt currentState = RxInt(0); // 0 - loading, 1 - error, 2 - success
  final RxMap dataMap = RxMap({});

  @override
  void onReady() async {
    try {
      currentState.value = 0;
      await _loadData();
      currentState.value = 2;
    } catch (e) {
      currentState.value = 1;
    }
    super.onReady();
  }

  Future<void> _loadData() async {
    final response = await MainController.dio.get("/lc_stats/Thyna");
    dataMap.value = response.data;
  }
}
