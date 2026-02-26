import 'package:get/get.dart';

import 'camera_init_logic.dart';

class CameraInitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      CameraInitLogic(),
      permanent: true,
    );
  }
}
