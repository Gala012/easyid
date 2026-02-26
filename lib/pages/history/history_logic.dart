import 'dart:io';
import 'package:get/get.dart';
import '../../db_easy_id_photo/db_easy_id_photo_entity.dart';
import '../../db_easy_id_photo/db_easy_id_photo_helper.dart';
import '../../utils/logger.dart';
import '../home/home_logic.dart';

class HistoryLogic extends GetxController {
  final photos = <PhotoHistoryEntity>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadPhotos();
  }
  
  Future<void> _loadPhotos() async {
    try {
      final allPhotos = await DbHelper.getAllPhotos();
      photos.value = allPhotos.where((photo) {
        return photo.imagePath.isNotEmpty && File(photo.imagePath).existsSync();
      }).toList();
    } catch (e) {
      Logger.e('Error loading photos', e);
      photos.value = [];
    }
  }
  
  void refreshPhotos() {
    _loadPhotos();
  }
  
  void exportPhoto(PhotoHistoryEntity photo) {
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
  
  Future<void> deletePhoto(PhotoHistoryEntity photo) async {
    try {
      if (photo.id != null) {
        await DbHelper.deletePhoto(photo.id!);
        _loadPhotos();
        
        if (Get.isRegistered<HomeLogic>()) {
          Get.find<HomeLogic>().refreshRecentPhotos();
        }
      }
    } catch (e) {
      Logger.e('Error deleting photo', e);
    }
  }
  
  void editPhoto(PhotoHistoryEntity photo) {
    if (photo.id != null) {
      Get.toNamed('/esay_edit', arguments: {'photoId': photo.id});
    }
  }
}
