import 'package:get/get.dart';
import 'success_logic.dart';

class SuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SuccessLogic());
  }
}
