import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../lang/lang.dart';
import 'splash_logic.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashLogic>();
    return Scaffold(
      backgroundColor: const Color(0xFF1E293B),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1E293B),
              const Color(0xFF0F172A),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ScreenUtil().setWidth(120),
              height: ScreenUtil().setWidth(120),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ScreenUtil().radius(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: ScreenUtil().setWidth(20),
                    offset: Offset(0, ScreenUtil().setWidth(10)),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt,
                size: ScreenUtil().setSp(60),
                color: const Color(0xFF3B82F6),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(32)),
            Text(
              Lang.appName,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(12)),
            Text(
              Lang.appSlogan,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                color: Colors.white.withOpacity(0.7),
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(60)),
            SizedBox(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFFFF6B35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
