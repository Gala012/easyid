import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../utils/logger.dart';

class SizeLogic extends GetxController {
  final selectedSize = (-1).obs;
  final unit = 'mm'.obs;
  final lockRatio = false.obs;
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  
  final presetSizesByCategory = {
    'ID Documents': [
      {'name': 'ID Card', 'width': '30', 'height': '24', 'unit': 'mm', 'category': 'ID Documents'},
      {'name': 'Driver License', 'width': '35', 'height': '45', 'unit': 'mm', 'category': 'ID Documents'},
    ],
    'Travel Documents': [
      {'name': 'Passport', 'width': '45', 'height': '35', 'unit': 'mm', 'category': 'Travel Documents'},
      {'name': 'Visa', 'width': '50', 'height': '50', 'unit': 'mm', 'category': 'Travel Documents'},
    ],
    'US Standard': [
      {'name': '2×2 inch', 'width': '2', 'height': '2', 'unit': 'inch', 'category': 'US Standard'},
      {'name': '1×1 inch', 'width': '1', 'height': '1', 'unit': 'inch', 'category': 'US Standard'},
    ],
  };
  
  List<Map<String, String>> get presetSizes {
    return presetSizesByCategory.values.expand((list) => list).toList();
  }
  
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    if (args['presetSize'] != null) {
      final preset = args['presetSize'] as Map<String, String>;
      widthController.text = preset['width'] ?? '';
      heightController.text = preset['height'] ?? '';
      unit.value = preset['unit'] ?? 'mm';
    }
  }
  
  @override
  void onClose() {
    widthController.dispose();
    heightController.dispose();
    super.onClose();
  }
  
  void selectSize(int index) {
    selectedSize.value = index;
    final size = presetSizes[index];
    widthController.text = size['width']!;
    heightController.text = size['height']!;
    unit.value = size['unit']!;
  }
  
  void setUnit(String value) {
    unit.value = value;
  }
  
  void setLockRatio(bool value) {
    lockRatio.value = value;
  }
  
  void next() {
    final width = double.tryParse(widthController.text) ?? 0;
    final height = double.tryParse(heightController.text) ?? 0;
    
    if (width <= 0 || height <= 0) {
      Logger.w('Invalid size input');
      return;
    }
    
    final args = Get.arguments ?? {};
    Get.toNamed('/easy_edit', arguments: {
      ...args,
      'width': width,
      'height': height,
      'unit': unit.value,
    });
  }
}
