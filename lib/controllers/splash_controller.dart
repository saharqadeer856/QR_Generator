import 'dart:async';

import 'package:get/get.dart';

import '../routes/app_routes.dart';

class SplashController extends GetxController {
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();
    _timer = Timer(const Duration(milliseconds: 1400), () {
      Get.offAllNamed(AppRoutes.generator);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
