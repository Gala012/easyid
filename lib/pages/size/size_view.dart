import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'size_logic.dart';
import '../../lang/lang.dart';

class SizeView extends StatelessWidget {
  const SizeView({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<SizeLogic>();
    
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
                    _buildPresetSizes(context, logic),
                    SizedBox(height: ScreenUtil().setHeight(32)),
                    _buildCustomSize(context, logic),
                  ],
                ),
              ),
            ),
            _buildBottomButton(context, logic),
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
            Lang.sizeTitle,
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
  
  Widget _buildPresetSizes(BuildContext context, SizeLogic logic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Lang.sizePreset,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          ...logic.presetSizesByCategory.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(12)),
                  child: Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: ScreenUtil().setWidth(12),
                    mainAxisSpacing: ScreenUtil().setHeight(12),
                    childAspectRatio: 1.5,
                  ),
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    final size = entry.value[index];
                    final globalIndex = logic.presetSizes.indexOf(size);
                    return Obx(() {
                      final isSelected = logic.selectedSize.value == globalIndex;
                      return GestureDetector(
                        onTap: () => logic.selectSize(globalIndex),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFFF6B35)
                                  : const Color(0xFFE2E8F0),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: ScreenUtil().setWidth(8),
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
                              SizedBox(height: ScreenUtil().setHeight(8)),
                              Text(
                                '${size['width']}×${size['height']} ${size['unit']}',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
                SizedBox(height: ScreenUtil().setHeight(24)),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
  
  Widget _buildCustomSize(BuildContext context, SizeLogic logic) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Lang.sizeCustom,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
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
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        context,
                        Lang.sizeWidth,
                        logic.widthController,
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(16)),
                    Expanded(
                      child: _buildInputField(
                        context,
                        Lang.sizeHeight,
                        logic.heightController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(16)),
                Row(
                  children: [
                    Text(
                      Lang.sizeUnit,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(14),
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(16)),
                    Obx(() {
                      return Row(
                        children: [
                          _buildUnitButton(
                            context,
                            Lang.sizeMm,
                            logic.unit.value == 'mm',
                            () => logic.setUnit('mm'),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(12)),
                          _buildUnitButton(
                            context,
                            Lang.sizeInch,
                            logic.unit.value == 'inch',
                            () => logic.setUnit('inch'),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(16)),
                Obx(() {
                  return Row(
                    children: [
                      Checkbox(
                        value: logic.lockRatio.value,
                        onChanged: (value) => logic.setLockRatio(value ?? false),
                        activeColor: const Color(0xFFFF6B35),
                      ),
                      Text(
                        Lang.sizeLockRatio,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInputField(
    BuildContext context,
    String label,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(12),
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(8)),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
              borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(12),
              vertical: ScreenUtil().setHeight(12),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildUnitButton(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
          vertical: ScreenUtil().setHeight(8),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF6B35)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF6B35)
                : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(14),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
      ),
    );
  }
  
  Widget _buildBottomButton(BuildContext context, SizeLogic logic) {
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
      child: GestureDetector(
        onTap: () => logic.next(),
        child: Container(
          width: double.infinity,
          height: ScreenUtil().setHeight(50),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
            ),
            borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
          ),
          child: Center(
            child: Text(
              Lang.commonNext,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
