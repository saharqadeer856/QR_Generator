import 'package:get/get.dart';

import '../controllers/splash_controller.dart';
import '../views/generator_view.dart';
import '../views/splash_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String generator = '/generator';
}

class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() => Get.put(SplashController())),
    ),
    // GeneratorController is registered in GetMaterialApp.initialBinding.
    GetPage(
      name: AppRoutes.generator,
      page: () => const GeneratorView(),
    ),
  ];
}