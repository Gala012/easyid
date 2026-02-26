import 'package:camera/camera.dart';
import 'package:get/get.dart';
import '../../utils/logger.dart';

class CameraLogic extends GetxController {
  CameraController? _controller;
  final isInitialized = false.obs;
  final isLoading = true.obs;
  final isProcessing = false.obs;
  List<CameraDescription> cameras = [];
  final currentCameraIndex = 0.obs;
  
  @override
  void onInit() async {
    super.onInit();
    await _initializeCamera();
  }
  
  @override
  void onClose() {
    _controller?.dispose();
    super.onClose();
  }
  
  Future<void> _initializeCamera() async {
    try {
      isLoading.value = true;
      
      cameras = await availableCameras();
      
      if (cameras.isEmpty) {
        Logger.e('No cameras available');
        Get.snackbar(
          'Error',
          'No camera found',
          snackPosition: SnackPosition.BOTTOM,
        );
        Future.delayed(const Duration(seconds: 1), () => Get.back());
        return;
      }
      
      await _setupCamera(currentCameraIndex.value);
    } catch (e) {
      Logger.e('Error initializing camera', e);
      Get.snackbar(
        'Error',
        'Failed to initialize camera: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      Future.delayed(const Duration(seconds: 1), () => Get.back());
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> _setupCamera(int cameraIndex) async {
    if (cameras.isEmpty) return;
    
    await _controller?.dispose();
    
    _controller = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    
    try {
      await _controller!.initialize();
      isInitialized.value = true;
      Logger.i('Camera initialized');
    } catch (e) {
      Logger.e('Error setting up camera', e);
      isInitialized.value = false;
      Get.snackbar(
        'Error',
        'Failed to initialize camera: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  Future<void> switchCamera() async {
    if (cameras.length < 2) {
      Get.snackbar(
        'Info',
        'Only one camera available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    currentCameraIndex.value = (currentCameraIndex.value + 1) % cameras.length;
    isInitialized.value = false;
    await _setupCamera(currentCameraIndex.value);
  }
  
  Future<void> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      Get.snackbar(
        'Error',
        'Camera is not ready',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    if (isProcessing.value) return;
    
    try {
      isProcessing.value = true;
      
      final XFile photo = await _controller!.takePicture();
      
      if (photo.path.isNotEmpty) {
        Get.toNamed(
          '/easy_size',
          arguments: {'imagePath': photo.path},
        );
      }
    } catch (e) {
      Logger.e('Error taking picture', e);
      Get.snackbar(
        'Error',
        'Failed to take picture: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProcessing.value = false;
    }
  }
  
  CameraController? get controller => _controller;
}

