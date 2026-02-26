import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../db_easy_id_photo/db_easy_id_photo_entity.dart';
import '../../db_easy_id_photo/db_easy_id_photo_helper.dart';
import '../../utils/logger.dart';

class HomeLogic extends GetxController {
  final recentPhotos = <PhotoHistoryEntity>[].obs;
  final isTipsExpanded = false.obs;
  final commonSizes = [
    {'name': 'ID Card', 'width': '30', 'height': '24', 'unit': 'mm'},
    {'name': 'Passport', 'width': '45', 'height': '35', 'unit': 'mm'},
    {'name': 'Driver License', 'width': '35', 'height': '45', 'unit': 'mm'},
    {'name': '2×2 inch', 'width': '2', 'height': '2', 'unit': 'inch'},
  ];
  
  final ImagePicker _picker = ImagePicker();
  
  void toggleTips() {
    isTipsExpanded.value = !isTipsExpanded.value;
  }
  
  @override
  void onInit() {
    super.onInit();
    _loadRecentPhotos();
  }
  
  Future<void> _loadRecentPhotos() async {
    try {
      final photos = await DbHelper.getAllPhotos();
      recentPhotos.value = photos.where((photo) {
        return photo.imagePath.isNotEmpty && File(photo.imagePath).existsSync();
      }).take(5).toList();
    } catch (e) {
      Logger.e('Error loading recent photos', e);
      recentPhotos.value = [];
    }
  }
  
  void refreshRecentPhotos() {
    _loadRecentPhotos();
  }
  
  Future<void> selectFromAlbum() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );
      
      if (image != null) {
        Get.toNamed('/easy_size', arguments: {'imagePath': image.path});
      }
    } catch (e) {
      Logger.e('Error selecting from album', e);
    }
  }
  
  Future<void> takePhoto() async {
    Get.toNamed('/easy_camera');
  }
  
  Future<void> selectSize(Map<String, String> size) async {
    Logger.i('Size selected: ${size['name']}');
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );
      
      if (image != null) {
        final width = double.tryParse(size['width'] ?? '0') ?? 0.0;
        final height = double.tryParse(size['height'] ?? '0') ?? 0.0;
        final unit = size['unit'] ?? 'mm';
        
        Get.toNamed('/easy_edit', arguments: {
          'imagePath': image.path,
          'width': width,
          'height': height,
          'unit': unit,
        });
      }
    } catch (e) {
      Logger.e('Error selecting image for size', e);
    }
  }
  
  void openPhoto(PhotoHistoryEntity photo) {
    Get.toNamed('/easy_export', arguments: {
      'imagePath': photo.imagePath,
      'width': photo.width,
      'height': photo.height,
      'unit': photo.unit,
      'brightness': photo.brightness.toDouble(),
      'skinSmoothing': photo.skinSmoothing.toDouble(),
      'skinTone': photo.skinTone.toDouble(),
      'backgroundColor': photo.backgroundColor,
    });
  }
}
