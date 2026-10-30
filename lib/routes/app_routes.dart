import 'package:get/get.dart';

import '../controllers/splash_controller.dart';
import '../models/qr_item.dart';
import '../views/detail_view.dart';
import '../views/generator_view.dart';
import '../views/history_view.dart';
import '../views/settings_view.dart';
import '../views/splash_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String generator = '/generator';
  static const String history = '/history';
  static const String detail = '/detail';
  static const String settings = '/settings';
}

class AppPages {
  AppPages._();

  // Shared controllers (generator, history, settings) are registered in
  // main.dart, so no route needs a binding except splash.
  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() => Get.put(SplashController())),
    ),
    GetPage(name: AppRoutes.generator, page: () => const GeneratorView()),
    GetPage(name: AppRoutes.history, page: () => const HistoryView()),
    GetPage(
      name: AppRoutes.detail,
      page: () => DetailView(item: Get.arguments as QrItem),
    ),
    GetPage(name: AppRoutes.settings, page: () => const SettingsView()),
  ];
}
