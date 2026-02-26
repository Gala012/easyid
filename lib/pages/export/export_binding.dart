import 'package:get/get.dart';
import 'export_logic.dart';

class ExportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExportLogic());
  }
}
