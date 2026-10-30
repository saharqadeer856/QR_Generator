import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';

class CommonSnackbar {
  CommonSnackbar._();

  static void show(String message, {bool isError = false}) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        style: const TextStyle(color: AppColors.white, fontSize: 14),
      ),
      backgroundColor: isError ? AppColors.error : AppColors.primaryDark,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }
}
