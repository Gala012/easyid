import 'package:get/get.dart';
import 'camera_logic.dart';

class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CameraLogic());
  }
}
