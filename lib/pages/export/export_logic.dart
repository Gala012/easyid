import 'dart:io';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image_picker/image_picker.dart';
import '../../utils/logger.dart';
import '../../utils/image_processor.dart';
import '../../db_easy_id_photo/db_easy_id_photo_entity.dart';
import '../../db_easy_id_photo/db_easy_id_photo_helper.dart';
import '../../lang/lang.dart';

class ExportLogic extends GetxController {
  final imagePath = ''.obs;
  final originalImagePath = ''.obs;
  final width = 0.0.obs;
  final height = 0.0.obs;
  final unit = 'mm'.obs;
  final format = 'jpg'.obs;
  final resolution = 'hd'.obs;
  final brightness = 0.0.obs;
  final skinSmoothing = 0.0.obs;
  final skinTone = 0.0.obs;
  final backgroundColor = 'white'.obs;
  final isProcessing = false.obs;
  final ImagePicker _picker = ImagePicker();
  
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    originalImagePath.value = args['imagePath'] ?? '';
    imagePath.value = originalImagePath.value;
    width.value = (args['width'] ?? 30).toDouble();
    height.value = (args['height'] ?? 24).toDouble();
    unit.value = args['unit'] ?? 'mm';
    brightness.value = (args['brightness'] ?? 0).toDouble();
    skinSmoothing.value = (args['skinSmoothing'] ?? 0).toDouble();
    skinTone.value = (args['skinTone'] ?? 0).toDouble();
    backgroundColor.value = args['backgroundColor'] ?? 'white';
  }
  
  void setFormat(String value) {
    format.value = value;
    _processImage();
  }
  
  void setResolution(String value) {
    resolution.value = value;
    _processImage();
  }
  
  Future<void> _processImage() async {
    final sourcePath = originalImagePath.value.isNotEmpty ? originalImagePath.value : imagePath.value;
    if (sourcePath.isEmpty) return;
    
    isProcessing.value = true;
    try {
      final processedPath = await ImageProcessor.processImage(
        imagePath: sourcePath,
        brightness: brightness.value,
        skinSmoothing: skinSmoothing.value,
        skinTone: skinTone.value,
        backgroundColor: backgroundColor.value,
        customColorValue: null,
        width: width.value,
        height: height.value,
        unit: unit.value,
        format: format.value,
        resolution: resolution.value,
      );
      
      if (processedPath.isNotEmpty) {
        imagePath.value = processedPath;
      }
    } catch (e) {
      Logger.e('Error processing image', e);
      Get.snackbar(
        Lang.commonFailed,
        Lang.errorSaveFailed,
        snackPosition: SnackPosition.BOTTOM,
      );
      if (imagePath.value.isEmpty && originalImagePath.value.isNotEmpty) {
        imagePath.value = originalImagePath.value;
      }
    } finally {
      isProcessing.value = false;
    }
  }
  
  Future<void> saveToAlbum() async {
    if (isProcessing.value) return;
    
    isProcessing.value = true;
    try {
      final savedPath = await ImageProcessor.saveToGallery(imagePath.value);
      final thumbnailPath = await ImageProcessor.createThumbnail(savedPath);
      
      final photo = PhotoHistoryEntity(
        imagePath: savedPath,
        thumbnailPath: thumbnailPath,
        width: width.value,
        height: height.value,
        unit: unit.value,
        format: format.value,
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
        'width': width.value,
        'height': height.value,
        'unit': unit.value,
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
    } finally {
      isProcessing.value = false;
    }
  }
  
  Future<void> share() async {
    final sourcePath = originalImagePath.value.isNotEmpty ? originalImagePath.value : imagePath.value;
    if (isProcessing.value || sourcePath.isEmpty) return;
    
    try {
      final file = File(sourcePath);
      if (!await file.exists()) {
        Get.snackbar(
          Lang.commonFailed,
          Lang.errorSaveFailed,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      await Share.shareXFiles(
        [XFile(sourcePath)],
        text: Lang.exportTitle,
      );
    } catch (e) {
      Logger.e('Error sharing photo', e);
      Get.snackbar(
        Lang.commonFailed,
        'Share failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  Future<void> exportToPdf() async {
    final sourcePath = originalImagePath.value.isNotEmpty ? originalImagePath.value : imagePath.value;
    if (isProcessing.value || sourcePath.isEmpty) return;
    
    isProcessing.value = true;
    try {
      final imageFile = File(sourcePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found');
      }
      
      final imageBytes = await imageFile.readAsBytes();
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(imageBytes),
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );
      
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
      
      Get.snackbar(
        Lang.commonSuccess,
        Lang.successExported,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Logger.e('Error exporting to PDF', e);
      Get.snackbar(
        Lang.commonFailed,
        Lang.errorSaveFailed,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProcessing.value = false;
    }
  }
  
  Future<void> selectImageFromAlbum() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );
      
      if (image != null) {
        originalImagePath.value = image.path;
        imagePath.value = image.path;
      }
    } catch (e) {
      Logger.e('Error selecting image from album', e);
      Get.snackbar(
        Lang.commonFailed,
        'Failed to select image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
