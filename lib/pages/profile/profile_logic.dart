import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../db_easy_id_photo/db_easy_id_photo_entity.dart';
import '../../db_easy_id_photo/db_easy_id_photo_helper.dart';
import '../../utils/logger.dart';
import '../../lang/lang.dart';
import '../home/home_logic.dart';

class ProfileLogic extends GetxController {
  final photos = <PhotoHistoryEntity>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadPhotos();
  }
  
  Future<void> _loadPhotos() async {
    try {
      final allPhotos = await DbHelper.getAllPhotos();
      photos.value = allPhotos;
    } catch (e) {
      Logger.e('Error loading photos', e);
    }
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
  
  Future<void> showAbout() async {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: ScreenUtil().setWidth(64),
                height: ScreenUtil().setWidth(64),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                  ),
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(32)),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: ScreenUtil().setSp(32),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(16)),
              Text(
                Lang.appName,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(8)),
              Text(
                Lang.profileAppDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(24)),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(12),
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                    ),
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                  ),
                  child: Center(
                    child: Text(
                      Lang.commonConfirm,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> showVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;
      final buildNumber = packageInfo.buildNumber;
      
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: ScreenUtil().setSp(48),
                  color: const Color(0xFF3B82F6),
                ),
                SizedBox(height: ScreenUtil().setHeight(16)),
                Text(
                  Lang.profileVersion,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(8)),
                Text(
                  '$version ($buildNumber)',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(24)),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(12),
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                      ),
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                    ),
                    child: Center(
                      child: Text(
                        Lang.commonConfirm,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      Logger.e('Error getting version info', e);
      Get.snackbar(
        Lang.commonFailed,
        'Failed to get version information',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void showHelp() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.help_outline,
                size: ScreenUtil().setSp(48),
                color: const Color(0xFF3B82F6),
              ),
              SizedBox(height: ScreenUtil().setHeight(16)),
              Text(
                Lang.profileHelp,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(18),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(16)),
              Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                ),
                child: Text(
                  Lang.profileHelpContent,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: const Color(0xFF64748B),
                    height: 1.6,
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(24)),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(12),
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                    ),
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                  ),
                  child: Center(
                    child: Text(
                      Lang.commonConfirm,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
