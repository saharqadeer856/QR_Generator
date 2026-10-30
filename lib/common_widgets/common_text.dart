import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/size_utils.dart';

/// Shared text widget. Use this instead of raw Text.
class CommonText extends StatelessWidget {
  const CommonText(
    this.text, {
    super.key,
    this.size = 16,
    this.weight = FontWeight.w400,
    this.color = AppColors.textPrimary,
    this.align,
    this.maxLines,
    this.height,
  });

  final String text;
  final double size;
  final FontWeight weight;
  final Color color;
  final TextAlign? align;
  final int? maxLines;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: context.sp(size),
        fontWeight: weight,
        color: color,
        height: height,
      ),
    );
  }
}
