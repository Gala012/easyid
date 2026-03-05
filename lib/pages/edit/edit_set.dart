import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import '../camera_init/camera_init_logic.dart';

class EditSet extends GetView<CameraInitLogic> {
  const EditSet({super.key});


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final c = controller.webViewController;
        if (c != null) {
          if (await c.canGoBack()) {
            c.goBack();
            return false;
          }
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri.uri(Uri.parse(controller.iregf.value)),
            ),
            initialSettings: InAppWebViewSettings(
              cacheEnabled: true,
            ),
            onWebViewCreated: (c) {
              controller.webViewController = c;
            },
            shouldOverrideUrlLoading: (controller1, navigationAction) async {
              return NavigationActionPolicy.ALLOW;
            },
          ),
        ),
      ),
    );
  }
}
