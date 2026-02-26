import 'package:get/get.dart';
import '../../db_easy_id_photo/data.dart';
import '../../utils/logger.dart';

class SplashLogic extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initApp();
  }
  
  Future<void> _initApp() async {
    try {
      await DbInitializer.init();
      await Future.delayed(const Duration(seconds: 2));
      Get.offNamed('/easy_home');
    } catch (e) {
      Logger.e('Error initializing app', e);
      Get.offNamed('/easy_home');
    }
  }
}
