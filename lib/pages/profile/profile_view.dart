import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'profile_logic.dart';
import '../../lang/lang.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<ProfileLogic>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      if (logic.photos.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: _buildEmptyState(context),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(20),
                              vertical: ScreenUtil().setHeight(16),
                            ),
                            child: Text(
                              Lang.profileHistory,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(18),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          _buildPhotoList(context, logic),
                        ],
                      );
                    }),
                    SizedBox(height: ScreenUtil().setHeight(24)),
                    _buildSettingsSection(context, logic),
                    SizedBox(height: ScreenUtil().setHeight(24)),
                  ],
                ),
              ),
            ),
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
            Lang.profileTitle,
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
  
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_outlined,
            size: ScreenUtil().setSp(64),
            color: const Color(0xFFCBD5E1),
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          Text(
            Lang.profileNoHistory,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPhotoList(BuildContext context, ProfileLogic logic) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: ScreenUtil().setWidth(12),
        mainAxisSpacing: ScreenUtil().setHeight(12),
        childAspectRatio: 0.75,
      ),
      itemCount: logic.photos.length,
      itemBuilder: (context, index) {
        final photo = logic.photos[index];
        return _buildPhotoItem(context, photo, logic);
      },
    );
  }
  
  Widget _buildPhotoItem(
    BuildContext context,
    dynamic photo,
    ProfileLogic logic,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: ScreenUtil().setWidth(8),
            offset: Offset(0, ScreenUtil().setWidth(2)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ScreenUtil().radius(12)),
                topRight: Radius.circular(ScreenUtil().radius(12)),
              ),
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
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${photo.width.toStringAsFixed(0)}×${photo.height.toStringAsFixed(0)} ${photo.unit}',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ScreenUtil().setHeight(8)),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => logic.exportPhoto(photo),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(6),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(ScreenUtil().radius(6)),
                          ),
                          child: Center(
                            child: Text(
                              Lang.exportTitle,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(12),
                                color: const Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(8)),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => logic.deletePhoto(photo),
                        borderRadius: BorderRadius.circular(ScreenUtil().radius(6)),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          padding: EdgeInsets.all(ScreenUtil().setWidth(6)),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(ScreenUtil().radius(6)),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            size: ScreenUtil().setSp(16),
                            color: const Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsSection(BuildContext context, ProfileLogic logic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Lang.profileSettings,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(12)),
          _buildSettingItem(
            context,
            icon: Icons.info_outline,
            title: Lang.profileAbout,
            onTap: () => logic.showAbout(),
          ),
          _buildSettingItem(
            context,
            icon: Icons.help_outline,
            title: Lang.profileHelp,
            onTap: () => logic.showHelp(),
          ),
          _buildSettingItem(
            context,
            icon: Icons.verified_outlined,
            title: Lang.profileVersion,
            onTap: () => logic.showVersion(),
            showDivider: false,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(16),
                vertical: ScreenUtil().setHeight(16),
              ),
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
              child: Row(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(40),
                    height: ScreenUtil().setWidth(40),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
                    ),
                    child: Icon(
                      icon,
                      size: ScreenUtil().setSp(20),
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(16)),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: ScreenUtil().setSp(20),
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider) SizedBox(height: ScreenUtil().setHeight(12)),
      ],
    );
  }
}
