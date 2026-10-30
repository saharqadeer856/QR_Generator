import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common_widgets/common_snackbar.dart';
import '../common_widgets/common_text.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../controllers/history_controller.dart';
import '../controllers/settings_controller.dart';
import '../utils/qr_levels.dart';
import '../utils/size_utils.dart';

/// Screen 5: default error correction, saved codes, and about.
class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(AppStrings.settingsTitle,
            size: 20, weight: FontWeight.w700),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(context.wp(5)),
          children: [
            _Section(
              title: AppStrings.defaultLevelSection,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CommonText(AppStrings.defaultLevelHint,
                      size: 13, color: AppColors.textSecondary),
                  SizedBox(height: context.hp(1.5)),
                  Obx(() => Wrap(
                        spacing: context.wp(2),
                        runSpacing: context.wp(2),
                        children: [
                          for (final (level, label) in qrErrorLevels)
                            ChoiceChip(
                              label: Text(label),
                              selected:
                                  controller.defaultErrorLevel.value == level,
                              onSelected: (_) =>
                                  controller.setDefaultErrorLevel(level),
                              selectedColor: AppColors.primary,
                              backgroundColor: AppColors.surface,
                              side: const BorderSide(color: AppColors.border),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: controller.defaultErrorLevel.value ==
                                        level
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(height: context.hp(2.5)),
            _Section(
              title: AppStrings.savedCodesSection,
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => CommonText(
                          AppStrings.savedCount(
                              Get.find<HistoryController>().items.length),
                          size: 15,
                        )),
                  ),
                  TextButton(
                    onPressed: () => _confirmClear(context),
                    child: const CommonText(AppStrings.clearSaved,
                        size: 14,
                        weight: FontWeight.w600,
                        color: AppColors.error),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.hp(2.5)),
            const _Section(
              title: AppStrings.aboutSection,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(AppStrings.appName,
                      size: 16, weight: FontWeight.w700),
                  SizedBox(height: 4),
                  CommonText(AppStrings.appVersion,
                      size: 13, color: AppColors.textSecondary),
                  SizedBox(height: 10),
                  CommonText(AppStrings.aboutMessage,
                      size: 14, color: AppColors.textSecondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text(AppStrings.clearConfirmTitle),
        content: const Text(AppStrings.clearConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await controller.clearHistory();
              CommonSnackbar.show(AppStrings.cleared);
            },
            child: const Text(AppStrings.clearAll,
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.wp(4)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(title, size: 15, weight: FontWeight.w700),
          SizedBox(height: context.hp(1.5)),
          child,
        ],
      ),
    );
  }
}
