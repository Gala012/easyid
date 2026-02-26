import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'edit_logic.dart';
import '../../lang/lang.dart';

class EditView extends StatelessWidget {
  const EditView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<EditLogic>();
    
    return Scaffold(
      backgroundColor: const Color(0xFF1E293B),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(context, logic),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: _buildImagePreview(context, logic),
                    ),
                    _buildToolbar(context, logic),
                    _buildFunctionCard(context, logic),
                  ],
                ),
              ),
            ),
            _buildFixedBottomButtons(context, logic),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, EditLogic logic) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
        vertical: ScreenUtil().setHeight(16),
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
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: ScreenUtil().setSp(18),
                color: Colors.white,
              ),
            ),
          ),
          Text(
            Lang.editTitle,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Obx(() {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => logic.toggleCompare(),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: ScreenUtil().setWidth(40),
                  height: ScreenUtil().setWidth(40),
                  decoration: BoxDecoration(
                    color: logic.isComparing.value
                        ? const Color(0xFFFF6B35)
                        : Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
                    border: Border.all(
                      color: logic.isComparing.value
                          ? Colors.transparent
                          : Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.compare,
                    size: ScreenUtil().setSp(20),
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildImagePreview(BuildContext context, EditLogic logic) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
        child: Obx(() {
          final isComparing = logic.isComparing.value;
          final originalPath = logic.originalImagePath.value;
          final imagePath = logic.imagePath.value;
          final displayPath = isComparing && originalPath.isNotEmpty
              ? originalPath
              : imagePath;
          
          return _buildImageContent(context, logic, displayPath);
        }),
      ),
    );
  }
  
  Widget _buildImageContent(BuildContext context, EditLogic logic, String displayPath) {
    final canvasSize = logic.canvasDisplaySize;
    final maxWidth = MediaQuery.of(context).size.width - ScreenUtil().setWidth(40);
    final maxHeight = MediaQuery.of(context).size.height * 0.5 - ScreenUtil().setHeight(40);
    
    final aspectRatio = canvasSize.width / canvasSize.height;
    double displayWidth = canvasSize.width;
    double displayHeight = canvasSize.height;
    
    if (displayWidth > maxWidth) {
      displayWidth = maxWidth;
      displayHeight = displayWidth / aspectRatio;
    }
    if (displayHeight > maxHeight) {
      displayHeight = maxHeight;
      displayWidth = displayHeight * aspectRatio;
    }
    
    return GestureDetector(
      onScaleUpdate: (details) {
        if (logic.currentTab.value == 0) {
          if (details.scale != 1.0) {
            logic.adjustScale(details.scale);
          }
          if (details.focalPointDelta.dx != 0 || details.focalPointDelta.dy != 0) {
            logic.adjustPosition(details.focalPointDelta.dx, details.focalPointDelta.dy);
          }
        }
      },
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
          child: SizedBox(
            width: displayWidth,
            height: displayHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Obx(() {
                  Color bgColor;
                  if (logic.backgroundColor.value == 'custom') {
                    bgColor = logic.customBackgroundColor.value;
                  } else {
                    switch (logic.backgroundColor.value) {
                      case 'white':
                        bgColor = Colors.white;
                        break;
                      case 'blue':
                        bgColor = const Color(0xFF3B82F6);
                        break;
                      case 'red':
                        bgColor = const Color(0xFFEF4444);
                        break;
                      default:
                        bgColor = Colors.white;
                    }
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
                    ),
                    width: double.infinity,
                    height: double.infinity,
                  );
                }),
                Obx(() {
                  final currentDisplayPath = logic.isComparing.value && logic.originalImagePath.value.isNotEmpty
                      ? logic.originalImagePath.value
                      : logic.imagePath.value;
                  
                  return currentDisplayPath.isNotEmpty
                      ? Stack(
                          children: [
                            Transform.rotate(
                              angle: logic.rotation.value * 3.141592653589793 / 180,
                              child: Transform.translate(
                                offset: Offset(logic.guideOffsetX.value, logic.guideOffsetY.value),
                                child: Transform.scale(
                                  scale: logic.scale.value,
                                  child: Image.file(
                                    File(currentDisplayPath),
                                    key: ValueKey('${currentDisplayPath}_${logic.backgroundColor.value}_${logic.processedImagePath.value}'),
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                    width: displayWidth,
                                    height: displayHeight,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.white,
                                        child: Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: ScreenUtil().setSp(48),
                                            color: const Color(0xFFCBD5E1),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            if (logic.isProcessing.value)
                              Container(
                                color: Colors.black.withOpacity(0.5),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                      SizedBox(height: ScreenUtil().setHeight(12)),
                                      Text(
                                        'Processing...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(14),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        )
                      : Container(
                          color: Colors.white,
                          child: Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: ScreenUtil().setSp(48),
                              color: const Color(0xFFCBD5E1),
                            ),
                          ),
                        );
                }),
                Obx(() {
                  if (logic.currentTab.value == 0) {
                    return _buildCompositionGuides(context, logic);
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildToolbar(BuildContext context, EditLogic logic) {
    return Obx(() {
      return Container(
        height: ScreenUtil().setHeight(60),
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(30)),
        ),
          child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(6),
            horizontal: ScreenUtil().setWidth(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(4)),
                  child: _buildTabButton(
                    context,
                    Lang.editComposition,
                    logic.currentTab.value == 0,
                    () => logic.switchTab(0),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(4)),
                  child: _buildTabButton(
                    context,
                    Lang.editBeauty,
                    logic.currentTab.value == 1,
                    () => logic.switchTab(1),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(4)),
                  child: _buildTabButton(
                    context,
                    Lang.editBackground,
                    logic.currentTab.value == 2,
                    () => logic.switchTab(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  
  Widget _buildTabButton(
    BuildContext context,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(30)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: ScreenUtil().setHeight(48),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(12),
          ),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFFF6B35)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(30)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildFunctionCard(BuildContext context, EditLogic logic) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (logic.currentTab.value == 0) _buildCompositionControls(context, logic),
            if (logic.currentTab.value == 1) _buildBeautyControls(context, logic),
            if (logic.currentTab.value == 2) _buildBackgroundControls(context, logic),
          ],
        ),
      );
    });
  }
  
  Widget _buildFixedBottomButtons(BuildContext context, EditLogic logic) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => logic.reset(),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  height: ScreenUtil().setHeight(50),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      Lang.editReset,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(16)),
          Expanded(
            flex: 2,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => logic.saveToAlbum(),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  height: ScreenUtil().setHeight(50),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                    ),
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B35).withOpacity(0.3),
                        blurRadius: ScreenUtil().setWidth(12),
                        offset: Offset(0, ScreenUtil().setWidth(4)),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      Lang.commonSave,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildCompositionControls(BuildContext context, EditLogic logic) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDirectionButton(Icons.arrow_back_ios, () => logic.moveLeft()),
            _buildDirectionButton(Icons.arrow_forward_ios, () => logic.moveRight()),
            _buildDirectionButton(Icons.arrow_upward, () => logic.moveUp()),
            _buildDirectionButton(Icons.arrow_downward, () => logic.moveDown()),
            _buildDirectionButton(Icons.rotate_left, () => logic.rotateLeft()),
            _buildDirectionButton(Icons.rotate_right, () => logic.rotateRight()),
          ],
        ),
      ],
    );
  }
  
  Widget _buildDirectionButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(22)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: ScreenUtil().setWidth(44),
          height: ScreenUtil().setWidth(44),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(ScreenUtil().radius(22)),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: ScreenUtil().setSp(20),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  
  Widget _buildBeautyControls(BuildContext context, EditLogic logic) {
    return Column(
      children: [
        _buildSlider(
          context,
          Lang.editBrightness,
          logic.brightness.value,
          -50,
          50,
          (value) => logic.setBrightness(value.toInt()),
        ),
        SizedBox(height: ScreenUtil().setHeight(16)),
        _buildSlider(
          context,
          Lang.editSkinSmoothing,
          logic.skinSmoothing.value,
          0,
          100,
          (value) => logic.setSkinSmoothing(value.toInt()),
        ),
        SizedBox(height: ScreenUtil().setHeight(16)),
        _buildSlider(
          context,
          Lang.editSkinTone,
          logic.skinTone.value,
          -30,
          30,
          (value) => logic.setSkinTone(value.toInt()),
        ),
      ],
    );
  }
  
  Widget _buildSlider(
    BuildContext context,
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                color: Colors.white,
              ),
            ),
            Text(
              value.toStringAsFixed(0),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: const Color(0xFFFF6B35),
          inactiveColor: Colors.white.withOpacity(0.3),
          onChanged: onChanged,
        ),
      ],
    );
  }
  
  Widget _buildBackgroundControls(BuildContext context, EditLogic logic) {
    return Column(
      children: [
        Wrap(
          spacing: ScreenUtil().setWidth(12),
          runSpacing: ScreenUtil().setHeight(12),
          children: [
            _buildColorButton(Colors.white, () => logic.setBackgroundColor('white')),
            _buildColorButton(const Color(0xFF3B82F6), () => logic.setBackgroundColor('blue')),
            _buildColorButton(const Color(0xFFEF4444), () => logic.setBackgroundColor('red')),
            Obx(() => _buildColorButton(
              logic.customBackgroundColor.value,
              () => _showColorPicker(context, logic),
              isCustom: true,
            )),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(20)),
        _buildSlider(
          context,
          Lang.editBackgroundThreshold,
          logic.backgroundThreshold.value,
          0,
          100,
          (value) => logic.setBackgroundThreshold(value),
        ),
      ],
    );
  }
  
  void _showColorPicker(BuildContext context, EditLogic logic) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Lang.editBackground),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: logic.customBackgroundColor.value,
              onColorChanged: (color) {
                logic.setCustomBackgroundColor(color);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(Lang.commonConfirm),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildColorButton(Color color, VoidCallback onTap, {bool isCustom = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: ScreenUtil().setWidth(60),
          height: ScreenUtil().setWidth(60),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: ScreenUtil().setWidth(8),
                offset: Offset(0, ScreenUtil().setWidth(2)),
              ),
            ],
          ),
          child: isCustom
              ? Icon(
                  Icons.colorize,
                  color: Colors.white,
                  size: ScreenUtil().setSp(24),
                )
              : null,
        ),
      ),
    );
  }
  
  Widget _buildCompositionGuides(BuildContext context, EditLogic logic) {
    return Obx(() {
      if (!logic.showGuides.value || logic.faceRect.value == null) {
        return const SizedBox.shrink();
      }
      
      return CustomPaint(
        painter: CompositionGuidePainter(
          faceRect: logic.faceRect.value!,
          offsetX: logic.guideOffsetX.value,
          offsetY: logic.guideOffsetY.value,
          isCompliant: logic.isCompliant.value,
        ),
        child: Container(),
      );
    });
  }
}

class CompositionGuidePainter extends CustomPainter {
  final Rect faceRect;
  final double offsetX;
  final double offsetY;
  final bool isCompliant;
  
  CompositionGuidePainter({
    required this.faceRect,
    required this.offsetX,
    required this.offsetY,
    required this.isCompliant,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isCompliant ? Colors.green : Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final canvasCenterX = size.width / 2;
    final canvasCenterY = size.height / 2 - size.height * 0.2;
    
    final faceCenterX = faceRect.center.dx;
    final faceCenterY = faceRect.center.dy;
    
    final baseOffsetX = canvasCenterX - faceCenterX;
    final baseOffsetY = canvasCenterY - faceCenterY;
    
    final adjustedFaceRect = faceRect.translate(baseOffsetX + offsetX, baseOffsetY + offsetY);
    final adjustedCenterX = canvasCenterX + offsetX;
    
    final topLine = adjustedFaceRect.top;
    final bottomLine = adjustedFaceRect.bottom;
    
    canvas.drawLine(
      Offset(0, topLine),
      Offset(size.width, topLine),
      paint,
    );
    
    canvas.drawLine(
      Offset(0, bottomLine),
      Offset(size.width, bottomLine),
      paint,
    );
    
    canvas.drawLine(
      Offset(adjustedCenterX, 0),
      Offset(adjustedCenterX, size.height),
      paint,
    );
    
    final facePaint = Paint()
      ..color = isCompliant ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawRect(adjustedFaceRect, facePaint);
  }
  
  @override
  bool shouldRepaint(CompositionGuidePainter oldDelegate) {
    return oldDelegate.faceRect != faceRect 
        || oldDelegate.offsetX != offsetX 
        || oldDelegate.offsetY != offsetY
        || oldDelegate.isCompliant != isCompliant;
  }
}
