import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/size_utils.dart';
import 'common_text.dart';

/// Shared filled button. Shows a spinner while [loading].
class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final height = context.hp(7).clamp(52.0, 64.0).toDouble();

    return SizedBox(
      width: double.infinity,
      height: height,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.border,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.wp(3.5)),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: context.sp(20), color: AppColors.white),
                    SizedBox(width: context.wp(2)),
                  ],
                  Flexible(
                    child: CommonText(
                      label,
                      size: 16,
                      weight: FontWeight.w600,
                      color: AppColors.white,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
