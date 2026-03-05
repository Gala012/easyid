import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'camera_init_logic.dart';

class CameraInitView extends GetView<CameraInitLogic> {
  const CameraInitView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.xbryk.value
              ? const CircularProgressIndicator(color: Colors.orange)
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.xeabpmvd();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
