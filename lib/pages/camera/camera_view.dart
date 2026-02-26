import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'camera_logic.dart';
import '../../lang/lang.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<CameraLogic>();
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          if (logic.isLoading.value || !logic.isInitialized.value || logic.controller == null) {
            return _buildLoading(context);
          }
          
          return _buildCameraPreview(context, logic);
        }),
      ),
    );
  }
  
  Widget _buildLoading(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: const Color(0xFFFF6B35),
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          Text(
            Lang.commonLoading,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(14),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCameraPreview(BuildContext context, CameraLogic logic) {
    final controller = logic.controller;
    if (controller == null || !controller.value.isInitialized) {
      return _buildLoading(context);
    }
    
    return Stack(
      children: [
        Positioned.fill(
          child: CameraPreview(controller),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: GuideLinesPainter(),
          ),
        ),
        _buildTopBar(context, logic),
        _buildBottomBar(context, logic),
      ],
    );
  }
  
  Widget _buildTopBar(BuildContext context, CameraLogic logic) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
          vertical: ScreenUtil().setHeight(16),
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: ScreenUtil().setWidth(40),
                height: ScreenUtil().setWidth(40),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: ScreenUtil().setSp(24),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => logic.switchCamera(),
              child: Container(
                width: ScreenUtil().setWidth(40),
                height: ScreenUtil().setWidth(40),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.flip_camera_ios,
                  color: Colors.white,
                  size: ScreenUtil().setSp(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBottomBar(BuildContext context, CameraLogic logic) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
          vertical: ScreenUtil().setHeight(32),
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: ScreenUtil().setWidth(50),
              height: ScreenUtil().setWidth(50),
            ),
            Obx(() => GestureDetector(
              onTap: logic.isProcessing.value ? null : () => logic.takePicture(),
              child: Container(
                width: ScreenUtil().setWidth(80),
                height: ScreenUtil().setWidth(80),
                decoration: BoxDecoration(
                  color: logic.isProcessing.value
                      ? Colors.grey
                      : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                ),
                child: logic.isProcessing.value
                    ? Center(
                        child: SizedBox(
                          width: ScreenUtil().setWidth(30),
                          height: ScreenUtil().setWidth(30),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : null,
              ),
            )),
            Container(
              width: ScreenUtil().setWidth(50),
              height: ScreenUtil().setWidth(50),
            ),
          ],
        ),
      ),
    );
  }
}

class GuideLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    final gridSpacing = size.width / 3;
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(gridSpacing * i, 0),
        Offset(gridSpacing * i, size.height),
        gridPaint,
      );
    }
    
    final gridSpacingY = size.height / 3;
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(0, gridSpacingY * i),
        Offset(size.width, gridSpacingY * i),
        gridPaint,
      );
    }
    
    final centerX = size.width / 2;
    final centerLinePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      centerLinePaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant GuideLinesPainter oldDelegate) => false;
}
