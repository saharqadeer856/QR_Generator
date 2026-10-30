import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'constants/app_colors.dart';
import 'constants/app_strings.dart';
import 'controllers/generator_controller.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
      // Controllers that every screen needs are created once, up front,
      // so no screen can open before its controller exists.
      initialBinding: BindingsBuilder(() {
        Get.put<GeneratorController>(GeneratorController(), permanent: true);
      }),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}