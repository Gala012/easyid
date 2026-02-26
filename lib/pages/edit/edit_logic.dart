import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/logger.dart';
import '../../utils/image_processor.dart';
import '../../db_easy_id_photo/db_easy_id_photo_entity.dart';
import '../../db_easy_id_photo/db_easy_id_photo_helper.dart';
import '../../lang/lang.dart';

class EditLogic extends GetxController {
  final imagePath = ''.obs;
  final currentTab = 0.obs;
  final brightness = 0.0.obs;
  final skinSmoothing = 0.0.obs;
  final skinTone = 0.0.obs;
  final backgroundColor = 'white'.obs;
  final customBackgroundColor = const Color(0xFFFFFFFF).obs;
  final backgroundThreshold = 50.0.obs;
  final isComparing = false.obs;
  final showGuides = false.obs;
  final faceRect = Rx<Rect?>(null);
  final guideOffsetX = 0.0.obs;
  final guideOffsetY = 0.0.obs;
  final isCompliant = false.obs;
  final processedImagePath = ''.obs;
  final originalImagePath = ''.obs;
  final maskPreviewPath = ''.obs;
  final scale = 1.0.obs;
  final rotation = 0.0.obs;
  final isProcessing = false.obs;
  
  final width = 0.0.obs;
  final height = 0.0.obs;
  final unit = 'mm'.obs;
  final resolution = 'hd'.obs;
  
  Timer? _processTimer;
  
  Size get canvasDisplaySize {
    if (width.value <= 0 || height.value <= 0) {
      return const Size(300, 400);
    }
    
    final dpi = resolution.value == 'hd' ? 300 : 150;
    final mmToInch = 0.0393701;
    
    double widthInches;
    double heightInches;
    if (unit.value == 'mm') {
      widthInches = width.value * mmToInch;
      heightInches = height.value * mmToInch;
    } else {
      widthInches = width.value;
      heightInches = height.value;
    }
    
    final widthPx = widthInches * dpi;
    final heightPx = heightInches * dpi;
    
    return Size(widthPx, heightPx);
  }
  
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
      if (args != null && args['imagePath'] != null) {
      imagePath.value = args['imagePath'];
      originalImagePath.value = args['imagePath'];
      
      if (args['width'] != null && args['height'] != null && args['unit'] != null) {
        width.value = args['width'] is double ? args['width'] : (args['width'] as num).toDouble();
        height.value = args['height'] is double ? args['height'] : (args['height'] as num).toDouble();
        unit.value = args['unit'] ?? 'mm';
        resolution.value = args['resolution'] ?? 'hd';
      } else {
        Get.back();
        Get.toNamed('/easy_size', arguments: {'imagePath': args['imagePath']});
        return;
      }
      
      _detectFace();
      _processImage();
    } else if (args != null && args['photoId'] != null) {
      _loadPhotoFromHistory(args['photoId']);
    } else {
      Get.back();
      return;
    }
  }
  
  Future<void> _detectFace() async {
    showGuides.value = false;
    faceRect.value = null;
  }
  
  void _checkCompliance(Rect faceRect) {
    final imageFile = File(imagePath.value);
    if (!imageFile.existsSync()) {
      isCompliant.value = false;
      return;
    }
    
    final imageWidth = 1000.0;
    final imageHeight = 1000.0;
    
    final faceCenterX = faceRect.center.dx;
    final faceTop = faceRect.top;
    final faceBottom = faceRect.bottom;
    
    final centerThreshold = imageWidth * 0.1;
    final topThreshold = imageHeight * 0.2;
    final bottomThreshold = imageHeight * 0.3;
    
    final isCenterCompliant = (faceCenterX - imageWidth / 2).abs() < centerThreshold;
    final isTopCompliant = faceTop > topThreshold && faceTop < imageHeight * 0.4;
    final isBottomCompliant = faceBottom > imageHeight * 0.6 && faceBottom < imageHeight - bottomThreshold;
    
    isCompliant.value = isCenterCompliant && isTopCompliant && isBottomCompliant;
  }
  
  Future<void> _loadPhotoFromHistory(int? photoId) async {
    try {
      if (photoId == null) return;
      
      final photo = await DbHelper.getPhotoById(photoId);
      if (photo != null) {
        imagePath.value = photo.imagePath;
        originalImagePath.value = photo.imagePath;
        brightness.value = photo.brightness.toDouble();
        skinSmoothing.value = photo.skinSmoothing.toDouble();
        skinTone.value = photo.skinTone.toDouble();
        backgroundColor.value = photo.backgroundColor;
        width.value = photo.width;
        height.value = photo.height;
        unit.value = photo.unit;
        resolution.value = photo.resolution.isNotEmpty ? photo.resolution : 'hd';
        
        _detectFace();
        _processImage();
      }
    } catch (e) {
      Logger.e('Error loading photo from history', e);
    }
  }
  
  void switchTab(int index) {
    currentTab.value = index;
  }
  
  void setBrightness(int value) {
    brightness.value = value.toDouble();
    _debounceProcessImage();
  }
  
  void setSkinSmoothing(int value) {
    skinSmoothing.value = value.toDouble();
    _debounceProcessImage();
  }
  
  void setSkinTone(int value) {
    skinTone.value = value.toDouble();
    _debounceProcessImage();
  }
  
  void setBackgroundThreshold(double value) {
    backgroundThreshold.value = value;
    _debounceProcessImage();
  }
  
  void _debounceProcessImage() {
    _processTimer?.cancel();
    _processTimer = Timer(const Duration(milliseconds: 300), () {
      _processImage();
    });
  }
  
  Future<void> _processImage() async {
    try {
      if (originalImagePath.value.isEmpty) {
        Logger.w('Original image path is empty, skipping processing');
        return;
      }
      
      final originalFile = File(originalImagePath.value);
      if (!originalFile.existsSync()) {
        Logger.e('Original image file does not exist: ${originalImagePath.value}');
        return;
      }
      
      isProcessing.value = true;
      Logger.i('🔄 Starting image processing with background: ${backgroundColor.value}');
      
      maskPreviewPath.value = '';
      
      final processedPath = await ImageProcessor.processImage(
        imagePath: originalImagePath.value,
        brightness: brightness.value,
        skinSmoothing: skinSmoothing.value,
        skinTone: skinTone.value,
        backgroundColor: backgroundColor.value,
        customColorValue: backgroundColor.value == 'custom' ? customBackgroundColor.value.value : null,
        backgroundThreshold: backgroundThreshold.value,
        width: null,
        height: null,
        unit: null,
        format: 'jpg',
        resolution: null,
      );
      
      if (processedPath.isNotEmpty) {
        final processedFile = File(processedPath);
        if (processedFile.existsSync()) {
          processedImagePath.value = processedPath;
          imagePath.value = processedPath;
          Logger.i('✅ Image processed successfully: $processedPath');
          Logger.i('📁 File size: ${(processedFile.lengthSync() / 1024).toStringAsFixed(2)} KB');
        } else {
          Logger.e('Processed image file does not exist: $processedPath');
          if (imagePath.value.isEmpty && originalImagePath.value.isNotEmpty) {
            imagePath.value = originalImagePath.value;
          }
        }
      } else {
        Logger.e('Processed image path is empty');
        if (imagePath.value.isEmpty && originalImagePath.value.isNotEmpty) {
          imagePath.value = originalImagePath.value;
        }
      }
    } catch (e, stackTrace) {
      Logger.e('❌ Error processing image', e);
      Logger.e('Stack trace', stackTrace);
      if (imagePath.value.isEmpty && originalImagePath.value.isNotEmpty) {
        imagePath.value = originalImagePath.value;
      }
    } finally {
      isProcessing.value = false;
    }
  }
  
  void setBackgroundColor(String color) {
    backgroundColor.value = color;
    Logger.i('Background color changed to: $color');
    _debounceProcessImage();
  }
  
  void setCustomBackgroundColor(Color color) {
    customBackgroundColor.value = color;
    backgroundColor.value = 'custom';
    Logger.i('Custom background color changed to: ${color.value.toRadixString(16)}');
    _debounceProcessImage();
  }
  
  void moveLeft() {
    guideOffsetX.value = (guideOffsetX.value - 10).clamp(-200.0, 200.0);
    _updateCompliance();
  }
  
  void moveRight() {
    guideOffsetX.value = (guideOffsetX.value + 10).clamp(-200.0, 200.0);
    _updateCompliance();
  }
  
  void moveUp() {
    guideOffsetY.value = (guideOffsetY.value - 10).clamp(-200.0, 200.0);
    _updateCompliance();
  }
  
  void moveDown() {
    guideOffsetY.value = (guideOffsetY.value + 10).clamp(-200.0, 200.0);
    _updateCompliance();
  }
  
  void rotateLeft() {
    _adjustRotation(-5);
  }
  
  void rotateRight() {
    _adjustRotation(5);
  }
  
  void _adjustPosition(double dx, double dy) {
    guideOffsetX.value = (guideOffsetX.value + dx).clamp(-200.0, 200.0);
    guideOffsetY.value = (guideOffsetY.value + dy).clamp(-200.0, 200.0);
    _updateCompliance();
  }
  
  void _updateCompliance() {
    if (faceRect.value == null) return;
    final rect = faceRect.value!;
    final adjustedRect = Rect.fromLTWH(
      rect.left + guideOffsetX.value,
      rect.top + guideOffsetY.value,
      rect.width,
      rect.height,
    );
    _checkCompliance(adjustedRect);
  }
  
  void _adjustRotation(double angle) {
    final newRotation = rotation.value + angle;
    rotation.value = newRotation.clamp(-15.0, 15.0);
    Logger.i('Rotation: ${rotation.value} degrees');
  }
  
  void adjustPosition(double dx, double dy) {
    _adjustPosition(dx, dy);
  }
  
  void adjustScale(double scaleFactor) {
    scale.value = (scale.value * scaleFactor).clamp(0.5, 2.0);
    Logger.i('Scale: ${scale.value}');
  }
  
  void toggleCompare() {
    isComparing.value = !isComparing.value;
  }
  
  void reset() {
    brightness.value = 0.0;
    skinSmoothing.value = 0.0;
    skinTone.value = 0.0;
    backgroundColor.value = 'white';
    customBackgroundColor.value = const Color(0xFFFFFFFF);
    backgroundThreshold.value = 50.0;
    scale.value = 1.0;
    rotation.value = 0.0;
    guideOffsetX.value = 0.0;
    guideOffsetY.value = 0.0;
    imagePath.value = originalImagePath.value;
    processedImagePath.value = '';
    _detectFace();
    _processImage();
  }
  
  Future<void> saveToAlbum() async {
    if (imagePath.value.isEmpty) {
      Get.snackbar(
        Lang.commonFailed,
        'No image to save',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      final savedPath = await ImageProcessor.saveToGallery(imagePath.value);
      final thumbnailPath = await ImageProcessor.createThumbnail(savedPath);
      
      final photo = PhotoHistoryEntity(
        imagePath: savedPath,
        thumbnailPath: thumbnailPath,
        width: width.value,
        height: height.value,
        unit: unit.value,
        format: 'jpg',
        resolution: resolution.value,
        brightness: brightness.value.toInt(),
        skinSmoothing: skinSmoothing.value.toInt(),
        skinTone: skinTone.value.toInt(),
        backgroundColor: backgroundColor.value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await DbHelper.insertPhoto(photo);
      
      Get.toNamed('/easy_success', arguments: {
        'imagePath': savedPath,
        'width': 0.0,
        'height': 0.0,
        'unit': 'mm',
        'brightness': brightness.value,
        'skinSmoothing': skinSmoothing.value,
        'skinTone': skinTone.value,
        'backgroundColor': backgroundColor.value,
      });
    } catch (e) {
      Logger.e('Error saving photo to album', e);
      Get.snackbar(
        Lang.commonFailed,
        Lang.errorSaveFailed,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  @override
  void onClose() {
    _processTimer?.cancel();
    super.onClose();
  }
}
