import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../common_widgets/common_snackbar.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../utils/input_detector.dart';

class GeneratorController extends GetxController {
  final TextEditingController textController = TextEditingController();

  /// Trimmed text that the QR code encodes.
  final RxString content = ''.obs;
  final Rx<QrContentType> type = QrContentType.empty.obs;

  /// One of QrErrorCorrectLevel.L / M / Q / H.
  final RxInt errorLevel = QrErrorCorrectLevel.M.obs;

  /// True when the text cannot fit in any QR code at the chosen level.
  final RxBool tooLong = false.obs;
  final RxBool isSaving = false.obs;

  static const int _exportSize = 1024;

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

  Future<void> saveToGallery() async {
    if (!hasContent || isSaving.value) return;
    isSaving.value = true;
    try {
      if (!await _ensureAccess()) {
        CommonSnackbar.show(AppStrings.permissionDenied, isError: true);
        return;
      }
      final bytes = await _renderPng(content.value, errorLevel.value);
      await Gal.putImageBytes(
        bytes,
        name: 'qr_${DateTime.now().millisecondsSinceEpoch}',
      );
      CommonSnackbar.show(AppStrings.saved);
    } catch (_) {
      CommonSnackbar.show(AppStrings.saveFailed, isError: true);
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> _ensureAccess() async {
    if (await Gal.hasAccess()) return true;
    return Gal.requestAccess();
  }

  /// Draws the QR code on a white background with a quiet zone, so
  /// scanners can read the saved image reliably.
  Future<Uint8List> _renderPng(String data, int level) async {
    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: level,
      color: AppColors.qrInk,
      emptyColor: AppColors.white,
      gapless: true,
    );

    final total = _exportSize.toDouble();
    final margin = total * 0.08;
    final qrSize = total - margin * 2;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTWH(0, 0, total, total));
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, total, total),
      ui.Paint()..color = AppColors.white,
    );
    canvas.translate(margin, margin);
    painter.paint(canvas, ui.Size(qrSize, qrSize));

    final image =
        await recorder.endRecording().toImage(_exportSize, _exportSize);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    if (byteData == null) {
      throw StateError('Could not render the QR code.');
    }
    return byteData.buffer.asUint8List();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
