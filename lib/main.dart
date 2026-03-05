import 'package:easy_id_photo/pages/camera_init/camera_init_binding.dart';
import 'package:easy_id_photo/pages/camera_init/camera_init_view.dart';
import 'package:easy_id_photo/pages/edit/edit_set.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/splash/splash_binding.dart';
import '../pages/splash/splash_view.dart';
import '../pages/home/home_binding.dart';
import '../pages/home/home_view.dart';
import '../pages/camera/camera_binding.dart';
import '../pages/camera/camera_view.dart';
import '../pages/edit/edit_binding.dart';
import '../pages/edit/edit_view.dart';
import '../pages/size/size_binding.dart';
import '../pages/size/size_view.dart';
import '../pages/export/export_binding.dart';
import '../pages/export/export_view.dart';
import '../pages/profile/profile_binding.dart';
import '../pages/profile/profile_view.dart';
import '../pages/history/history_binding.dart';
import '../pages/history/history_view.dart';
import '../pages/success/success_binding.dart';
import '../pages/success/success_view.dart';
import 'package:get/get.dart';
import 'db_easy_id_photo/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbInitializer.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Easy ID Photo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'SF Pro',
          ),
          initialRoute: '/',
          getPages: EasyID,
        );
      },
    );
  }
}
List<GetPage<dynamic>> EasyID = [
  GetPage(
    name: '/',
    page: () => const CameraInitView(),
    binding: CameraInitBinding(),
  ),
  GetPage(
    name: '/easy_splash',
    page: () => const SplashView(),
    binding: SplashBinding(),
  ),
  GetPage(
    name: '/easy_home',
    page: () => const HomeView(),
    binding: HomeBinding(),
  ),
  GetPage(
    name: '/easy_camera',
    page: () => const CameraView(),
    binding: CameraBinding(),
  ),
  GetPage(
    name: '/easy_edit',
    page: () => const EditView(),
    binding: EditBinding(),
  ),
  GetPage(
    name: '/easy_edit_set',
    page: () => const EditSet(),
  ),
  GetPage(
    name: '/easy_size',
    page: () => const SizeView(),
    binding: SizeBinding(),
  ),
  GetPage(
    name: '/easy_export',
    page: () => const ExportView(),
    binding: ExportBinding(),
  ),
  GetPage(
    name: '/easy_profile',
    page: () => const ProfileView(),
    binding: ProfileBinding(),
  ),
  GetPage(
    name: '/easy_history',
    page: () => const HistoryView(),
    binding: HistoryBinding(),
  ),
  GetPage(
    name: '/easy_success',
    page: () => const SuccessView(),
    binding: SuccessBinding(),
  ),
];