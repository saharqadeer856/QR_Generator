import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../common_widgets/common_snackbar.dart';
import '../constants/app_strings.dart';
import '../controllers/history_controller.dart';
import '../models/qr_item.dart';
import '../services/qr_export_service.dart';
import '../services/storage_service.dart';
import '../utils/input_detector.dart';

class GeneratorController extends GetxController {
  final TextEditingController textController = TextEditingController();

  /// Trimmed text that the QR code encodes.
  final RxString content = ''.obs;
  final Rx<QrContentType> type = QrContentType.empty.obs;

  /// One of QrErrorCorrectLevel.L / M / Q / H. Starts at the saved default.
  final RxInt errorLevel = RxInt(Get.find<StorageService>().defaultErrorLevel);

  /// True when the text cannot fit in any QR code at the chosen level.
  final RxBool tooLong = false.obs;
  final RxBool isSaving = false.obs;

  bool get hasContent => content.value.isNotEmpty && !tooLong.value;

  void onTextChanged(String value) {
    content.value = value.trim();
    type.value = InputDetector.detect(content.value);
    _checkLength();
  }

  void setErrorLevel(int level) {
    errorLevel.value = level;
    _checkLength();
  }

  void clear() {
    textController.clear();
    onTextChanged('');
  }

  void _checkLength() {
    if (content.value.isEmpty) {
      tooLong.value = false;
      return;
    }
    tooLong.value = !QrValidator.validate(
      data: content.value,
      version: QrVersions.auto,
      errorCorrectionLevel: errorLevel.value,
    ).isValid;
  }

  /// Saves to the gallery and records the code in Saved codes.
  Future<void> saveToGallery() async {
    if (!hasContent || isSaving.value) return;
    isSaving.value = true;
    final item = QrItem(
      text: content.value,
      errorLevel: errorLevel.value,
      createdAt: DateTime.now(),
    );
    try {
      await QrExportService.saveToGallery(
        data: item.text,
        errorLevel: item.errorLevel,
      );
      await Get.find<HistoryController>().add(item);
      CommonSnackbar.show(AppStrings.saved);
    } on QrPermissionDenied {
      CommonSnackbar.show(AppStrings.permissionDenied, isError: true);
    } catch (_) {
      CommonSnackbar.show(AppStrings.saveFailed, isError: true);
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
