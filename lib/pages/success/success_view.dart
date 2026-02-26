import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'success_logic.dart';
import '../../lang/lang.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<SuccessLogic>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: ScreenUtil().setWidth(120),
                height: ScreenUtil().setWidth(120),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: ScreenUtil().setSp(80),
                  color: const Color(0xFF10B981),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(32)),
              Text(
                Lang.commonSuccess,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(24),
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(12)),
              Text(
                Lang.successSaved,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: const Color(0xFF64748B),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ScreenUtil().setHeight(48)),
              _buildButton(
                context,
                Lang.homeTitle,
                const Color(0xFF1E293B),
                () => logic.goToHome(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildButton(
    BuildContext context,
    String text,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(50),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
