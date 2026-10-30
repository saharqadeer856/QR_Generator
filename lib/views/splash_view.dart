import 'package:flutter/material.dart';

import '../common_widgets/common_text.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../utils/size_utils.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final logo = context.wp(38);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.splashLogo,
              width: logo,
              height: logo,
              filterQuality: FilterQuality.high,
            ),
            SizedBox(height: context.hp(3)),
            const CommonText(AppStrings.appName,
                size: 28, weight: FontWeight.w700),
            SizedBox(height: context.hp(1)),
            const CommonText(AppStrings.tagline,
                size: 15, color: AppColors.textSecondary),
            SizedBox(height: context.hp(4)),
            SizedBox(
              width: context.sp(24),
              height: context.sp(24),
              child: const CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
