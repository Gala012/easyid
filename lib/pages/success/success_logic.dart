import 'package:get/get.dart';

class SuccessLogic extends GetxController {
  final imagePath = ''.obs;
  final width = 0.0.obs;
  final height = 0.0.obs;
  final unit = 'mm'.obs;
  final brightness = 0.0.obs;
  final skinSmoothing = 0.0.obs;
  final skinTone = 0.0.obs;
  final backgroundColor = 'white'.obs;
  
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    imagePath.value = args['imagePath'] ?? '';
    width.value = (args['width'] ?? 0).toDouble();
    height.value = (args['height'] ?? 0).toDouble();
    unit.value = args['unit'] ?? 'mm';
    brightness.value = (args['brightness'] ?? 0).toDouble();
    skinSmoothing.value = (args['skinSmoothing'] ?? 0).toDouble();
    skinTone.value = (args['skinTone'] ?? 0).toDouble();
    backgroundColor.value = args['backgroundColor'] ?? 'white';
  }
  
  void goToHome() {
    Get.offAllNamed('/easy_home');
  }
  
  void goToExport() {
    Get.toNamed('/easy_export', arguments: {
      'imagePath': imagePath.value,
      'width': width.value,
      'height': height.value,
      'unit': unit.value,
      'brightness': brightness.value,
      'skinSmoothing': skinSmoothing.value,
      'skinTone': skinTone.value,
      'backgroundColor': backgroundColor.value,
    });
  }
}
