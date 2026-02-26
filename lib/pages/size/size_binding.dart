import 'package:get/get.dart';
import 'size_logic.dart';

class SizeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SizeLogic());
  }
}
