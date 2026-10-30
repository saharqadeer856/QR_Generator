import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../common_widgets/common_button.dart';
import '../common_widgets/common_text.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../controllers/generator_controller.dart';
import '../utils/input_detector.dart';
import '../utils/size_utils.dart';

class GeneratorView extends GetView<GeneratorController> {
  const GeneratorView({super.key});

  static const _levels = <(int, String)>[
    (QrErrorCorrectLevel.L, AppStrings.levelLow),
    (QrErrorCorrectLevel.M, AppStrings.levelMedium),
    (QrErrorCorrectLevel.Q, AppStrings.levelQuartile),
    (QrErrorCorrectLevel.H, AppStrings.levelHigh),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(AppStrings.appName,
            size: 20, weight: FontWeight.w700),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.wp(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputCard(context),
              SizedBox(height: context.hp(2.5)),
              _buildQrCard(context),
              SizedBox(height: context.hp(2.5)),
              _buildLevelSelector(context),
              SizedBox(height: context.hp(3)),
              Obx(() => CommonButton(
                    label: AppStrings.saveToGallery,
                    icon: Icons.download_rounded,
                    loading: controller.isSaving.value,
                    onPressed:
                        controller.hasContent ? controller.saveToGallery : null,
                  )),
              SizedBox(height: context.hp(2)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.wp(4)),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CommonText(AppStrings.inputLabel,
                  size: 15, weight: FontWeight.w600),
              const Spacer(),
              Obx(() => _TypeChip(type: controller.type.value)),
            ],
          ),
          SizedBox(height: context.hp(1)),
          TextField(
            controller: controller.textController,
            onChanged: controller.onTextChanged,
            minLines: 2,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              fontSize: context.sp(16),
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: AppStrings.inputHint,
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              border: InputBorder.none,
              suffixIcon: Obx(() => controller.content.value.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(Icons.close_rounded),
                      tooltip: AppStrings.clear,
                      onPressed: controller.clear,
                    )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCard(BuildContext context) {
    final side = context.wp(70);
    return Container(
      padding: EdgeInsets.all(context.wp(5)),
      decoration: _cardDecoration(),
      child: Obx(() {
        final text = controller.content.value;
        if (text.isEmpty) return _EmptyPreview(size: side);
        if (controller.tooLong.value) return _ErrorPreview(size: side);
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(context.wp(3)),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(context.wp(4)),
              ),
              child: QrImageView(
                data: text,
                version: QrVersions.auto,
                errorCorrectionLevel: controller.errorLevel.value,
                size: side,
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.qrInk,
              ),
            ),
            SizedBox(height: context.hp(1.5)),
            const CommonText(
              AppStrings.scanHint,
              size: 13,
              color: AppColors.textSecondary,
              align: TextAlign.center,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLevelSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonText(AppStrings.errorLevelLabel,
            size: 15, weight: FontWeight.w600),
        SizedBox(height: context.hp(1)),
        Obx(() => Wrap(
              spacing: context.wp(2),
              runSpacing: context.wp(2),
              children: [
                for (final (level, label) in _levels)
                  ChoiceChip(
                    label: Text(label),
                    selected: controller.errorLevel.value == level,
                    onSelected: (_) => controller.setErrorLevel(level),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.border),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: controller.errorLevel.value == level
                          ? AppColors.white
                          : AppColors.textPrimary,
                    ),
                  ),
              ],
            )),
      ],
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      );
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});

  final QrContentType type;

  @override
  Widget build(BuildContext context) {
    if (type == QrContentType.empty) return const SizedBox.shrink();

    final (icon, label) = switch (type) {
      QrContentType.link => (Icons.link_rounded, AppStrings.typeLink),
      QrContentType.number => (Icons.pin_rounded, AppStrings.typeNumber),
      _ => (Icons.notes_rounded, AppStrings.typeText),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.wp(3),
        vertical: context.hp(0.6),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          CommonText(label,
              size: 13, weight: FontWeight.w600, color: AppColors.primaryDark),
        ],
      ),
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.qr_code_2_rounded,
                size: size * 0.4, color: AppColors.border),
            SizedBox(height: context.hp(2)),
            const CommonText(AppStrings.emptyTitle,
                size: 16, weight: FontWeight.w600, align: TextAlign.center),
            SizedBox(height: context.hp(0.8)),
            const CommonText(AppStrings.emptyMessage,
                size: 14,
                color: AppColors.textSecondary,
                align: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ErrorPreview extends StatelessWidget {
  const _ErrorPreview({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: size * 0.3, color: AppColors.error),
            SizedBox(height: context.hp(2)),
            const CommonText(AppStrings.tooLongTitle,
                size: 16, weight: FontWeight.w600, align: TextAlign.center),
            SizedBox(height: context.hp(0.8)),
            const CommonText(AppStrings.tooLongMessage,
                size: 14,
                color: AppColors.textSecondary,
                align: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
