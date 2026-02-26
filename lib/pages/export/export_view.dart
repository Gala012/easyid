import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'export_logic.dart';
import '../../lang/lang.dart';

class ExportView extends StatelessWidget {
  const ExportView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<ExportLogic>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildPreview(context, logic),
                    SizedBox(height: ScreenUtil().setHeight(24)),
                    _buildFormatOptions(context, logic),
                    SizedBox(height: ScreenUtil().setHeight(24)),
                    _buildResolutionOptions(context, logic),
                    SizedBox(height: ScreenUtil().setHeight(24)),
                    _buildPdfExportButton(context, logic),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(context, logic),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
        vertical: ScreenUtil().setHeight(16),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: ScreenUtil().setWidth(8),
                    offset: Offset(0, ScreenUtil().setWidth(2)),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: ScreenUtil().setSp(18),
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(16)),
          Text(
            Lang.exportTitle,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(20),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPreview(BuildContext context, ExportLogic logic) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: ScreenUtil().setWidth(10),
            offset: Offset(0, ScreenUtil().setWidth(4)),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => logic.selectImageFromAlbum(),
            child: Container(
              width: ScreenUtil().setWidth(200),
              height: ScreenUtil().setWidth(250),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
              ),
              child: Obx(() {
                if (logic.isProcessing.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                    ),
                  );
                }
                
                final displayPath = logic.originalImagePath.value.isNotEmpty 
                    ? logic.originalImagePath.value 
                    : logic.imagePath.value;
                
                return displayPath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                        child: Image.file(
                          File(displayPath),
                          fit: BoxFit.contain,
                          width: ScreenUtil().setWidth(200),
                          height: ScreenUtil().setWidth(250),
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFF1F5F9),
                              child: Icon(
                                Icons.broken_image,
                                size: ScreenUtil().setSp(48),
                                color: const Color(0xFFCBD5E1),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: ScreenUtil().setSp(48),
                              color: const Color(0xFFCBD5E1),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(8)),
                            Text(
                              'Tap to select image',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(12),
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      );
              }),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          Obx(() {
            return Text(
              '${logic.width.value.toStringAsFixed(0)}×${logic.height.value.toStringAsFixed(0)} ${logic.unit.value}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                color: const Color(0xFF64748B),
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildFormatOptions(BuildContext context, ExportLogic logic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Lang.exportFormat,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(12)),
          Obx(() {
            return Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    context,
                    Lang.exportJpg,
                    logic.format.value == 'jpg',
                    () => logic.setFormat('jpg'),
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(12)),
                Expanded(
                  child: _buildOptionButton(
                    context,
                    Lang.exportPng,
                    logic.format.value == 'png',
                    () => logic.setFormat('png'),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildResolutionOptions(BuildContext context, ExportLogic logic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Lang.exportResolution,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(12)),
          Obx(() {
            return Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    context,
                    Lang.exportHd,
                    logic.resolution.value == 'hd',
                    () => logic.setResolution('hd'),
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(12)),
                Expanded(
                  child: _buildOptionButton(
                    context,
                    Lang.exportSd,
                    logic.resolution.value == 'sd',
                    () => logic.setResolution('sd'),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildOptionButton(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(16)),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF6B35).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF6B35)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(14),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected
                  ? const Color(0xFFFF6B35)
                  : const Color(0xFF1E293B),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPdfExportButton(BuildContext context, ExportLogic logic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: GestureDetector(
        onTap: () => logic.exportToPdf(),
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.picture_as_pdf,
                size: ScreenUtil().setSp(24),
                color: const Color(0xFFEF4444),
              ),
              SizedBox(width: ScreenUtil().setWidth(12)),
              Expanded(
                child: Text(
                  Lang.exportPdf,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: ScreenUtil().setSp(16),
                color: const Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildBottomButtons(BuildContext context, ExportLogic logic) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: ScreenUtil().setWidth(10),
            offset: Offset(0, ScreenUtil().setWidth(-2)),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => logic.share(),
              child: Container(
                height: ScreenUtil().setHeight(50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
                child: Center(
                  child: Text(
                    Lang.exportShare,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(12)),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => logic.saveToAlbum(),
              child: Container(
                height: ScreenUtil().setHeight(50),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                  ),
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                ),
                child: Center(
                  child: Text(
                    Lang.exportSaveToAlbum,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
}
