import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'home_logic.dart';
import '../../lang/lang.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<HomeLogic>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, logic),
              SizedBox(height: ScreenUtil().setHeight(32)),
              _buildActionButtons(context, logic),
              SizedBox(height: ScreenUtil().setHeight(40)),
              _buildTipsSection(context),
              SizedBox(height: ScreenUtil().setHeight(40)),
              _buildCommonSizes(context, logic),
              SizedBox(height: ScreenUtil().setHeight(40)),
              _buildHistorySection(context, logic),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, HomeLogic logic) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
        vertical: ScreenUtil().setHeight(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Lang.homeTitle,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(4)),
              Text(
                Lang.appSlogan,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.toNamed('/easy_profile');
              },
              borderRadius: BorderRadius.circular(ScreenUtil().radius(22)),
              child: Container(
                width: ScreenUtil().setWidth(44),
                height: ScreenUtil().setWidth(44),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(22)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: ScreenUtil().setWidth(12),
                      offset: Offset(0, ScreenUtil().setWidth(2)),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_outline,
                  size: ScreenUtil().setSp(24),
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons(BuildContext context, HomeLogic logic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => logic.selectFromAlbum(),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  height: ScreenUtil().setHeight(140),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: ScreenUtil().setWidth(12),
                        offset: Offset(0, ScreenUtil().setWidth(3)),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(56),
                        height: ScreenUtil().setWidth(56),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(ScreenUtil().radius(28)),
                        ),
                        child: Icon(
                          Icons.photo_library_outlined,
                          size: ScreenUtil().setSp(28),
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(12)),
                      Text(
                        Lang.homeSelectFromAlbum,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(16)),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => logic.takePhoto(),
                borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  height: ScreenUtil().setHeight(140),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFF6B35),
                        Color(0xFFFF8C42),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B35).withOpacity(0.35),
                        blurRadius: ScreenUtil().setWidth(16),
                        offset: Offset(0, ScreenUtil().setWidth(4)),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(56),
                        height: ScreenUtil().setWidth(56),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(ScreenUtil().radius(28)),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: ScreenUtil().setSp(28),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(12)),
                      Text(
                        Lang.homeTakePhoto,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTipsSection(BuildContext context) {
    final logic = Get.find<HomeLogic>();
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: ScreenUtil().setWidth(12),
              offset: Offset(0, ScreenUtil().setWidth(3)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline,
                    size: ScreenUtil().setSp(20),
                    color: const Color(0xFFFF6B35),
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(12)),
                Expanded(
                  child: Text(
                    Lang.homeTipsTitle,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(16)),
            Obx(() {
              final tips = [
                Lang.homeTip1,
                Lang.homeTip2,
                Lang.homeTip3,
                Lang.homeTip4,
              ];
              
              final displayTips = logic.isTipsExpanded.value 
                  ? tips 
                  : tips.take(1).toList();
              
              return Column(
                children: [
                  ...displayTips.map((tip) => Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(12)),
                    child: _buildTipItem(tip),
                  )),
                  if (tips.length > 2)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => logic.toggleTips(),
                        borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(8),
                            horizontal: ScreenUtil().setWidth(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                logic.isTipsExpanded.value 
                                    ? Lang.homeTipsCollapse 
                                    : Lang.homeTipsExpand,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(14),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFF6B35),
                                ),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(4)),
                              AnimatedRotation(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOut,
                                turns: logic.isTipsExpanded.value ? 0.5 : 0,
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: ScreenUtil().setSp(20),
                                  color: const Color(0xFFFF6B35),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(6)),
          width: ScreenUtil().setWidth(6),
          height: ScreenUtil().setWidth(6),
          decoration: BoxDecoration(
            color: const Color(0xFF64748B),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: ScreenUtil().setWidth(12)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(13),
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildCommonSizes(BuildContext context, HomeLogic logic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Lang.homeCommonSizes,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(20),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          SizedBox(
            height: ScreenUtil().setHeight(100),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: logic.commonSizes.length,
              itemBuilder: (context, index) {
                final size = logic.commonSizes[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => logic.selectSize(size),
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      width: ScreenUtil().setWidth(120),
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(12)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: ScreenUtil().setWidth(10),
                            offset: Offset(0, ScreenUtil().setWidth(2)),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            size['name'] as String,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(16),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(4)),
                          Text(
                            '${size['width']}×${size['height']}',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHistorySection(BuildContext context, HomeLogic logic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Lang.homeMyHistory,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed('/easy_history'),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          Obx(() {
            if (logic.recentPhotos.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: ScreenUtil().setSp(48),
                      color: const Color(0xFFCBD5E1),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(12)),
                    Text(
                      Lang.profileNoHistory,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(14),
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox(
              height: ScreenUtil().setHeight(100),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: logic.recentPhotos.length,
                itemBuilder: (context, index) {
                  final photo = logic.recentPhotos[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => logic.openPhoto(photo),
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        width: ScreenUtil().setWidth(100),
                        margin: EdgeInsets.only(right: ScreenUtil().setWidth(12)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: ScreenUtil().setWidth(10),
                              offset: Offset(0, ScreenUtil().setWidth(2)),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                          child: (photo.thumbnailPath.isNotEmpty && File(photo.thumbnailPath).existsSync())
                              ? Image.file(
                                  File(photo.thumbnailPath),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFFF1F5F9),
                                      child: Icon(
                                        Icons.broken_image,
                                        size: ScreenUtil().setSp(32),
                                        color: const Color(0xFFCBD5E1),
                                      ),
                                    );
                                  },
                                )
                              : (photo.imagePath.isNotEmpty && File(photo.imagePath).existsSync())
                                  ? Image.file(
                                      File(photo.imagePath),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: const Color(0xFFF1F5F9),
                                          child: Icon(
                                            Icons.broken_image,
                                            size: ScreenUtil().setSp(32),
                                            color: const Color(0xFFCBD5E1),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: const Color(0xFFF1F5F9),
                                      child: Icon(
                                        Icons.image_outlined,
                                        size: ScreenUtil().setSp(32),
                                        color: const Color(0xFFCBD5E1),
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
