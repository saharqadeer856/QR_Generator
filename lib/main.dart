import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'constants/app_colors.dart';
import 'constants/app_strings.dart';
import 'controllers/generator_controller.dart';
import 'controllers/history_controller.dart';
import 'controllers/settings_controller.dart';
import 'routes/app_routes.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Storage must be ready before any controller reads from it.
  final storage = await StorageService().init();
  Get.put<StorageService>(storage, permanent: true);

  // Show the real error on screen (instead of a blank grey screen) if any
  // widget fails to build, in debug AND release builds.
  ErrorWidget.builder = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: AppColors.background,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Screen error:\n\n${details.exceptionAsString()}',
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  };

  runApp(const QrGeneratorApp());
}

class QrGeneratorApp extends StatelessWidget {
  const QrGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      // Screens that share state are created once, before any route opens.
      initialBinding: BindingsBuilder(() {
        Get.put<HistoryController>(HistoryController(), permanent: true);
        Get.put<SettingsController>(SettingsController(), permanent: true);
        Get.put<GeneratorController>(GeneratorController(), permanent: true);
      }),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
