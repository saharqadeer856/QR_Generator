import 'package:qr_flutter/qr_flutter.dart';

import '../constants/app_strings.dart';

/// Error correction options shown as chips: (level value, label).
const List<(int, String)> qrErrorLevels = [
  (QrErrorCorrectLevel.L, AppStrings.levelLow),
  (QrErrorCorrectLevel.M, AppStrings.levelMedium),
  (QrErrorCorrectLevel.Q, AppStrings.levelQuartile),
  (QrErrorCorrectLevel.H, AppStrings.levelHigh),
];
