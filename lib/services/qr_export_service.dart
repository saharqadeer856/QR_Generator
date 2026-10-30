import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:gal/gal.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../constants/app_colors.dart';

class QrPermissionDenied implements Exception {
  const QrPermissionDenied();
}

/// Renders QR codes to PNG and saves them to the device gallery.
class QrExportService {
  QrExportService._();

  static const int _exportSize = 1024;

  static Future<void> saveToGallery({
    required String data,
    required int errorLevel,
  }) async {
    if (!await Gal.hasAccess()) {
      final granted = await Gal.requestAccess();
      if (!granted) throw const QrPermissionDenied();
    }
    final bytes = await renderPng(data: data, errorLevel: errorLevel);
    await Gal.putImageBytes(
      bytes,
      name: 'qr_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  /// Draws the QR code on white with a quiet zone so it scans reliably.
  static Future<Uint8List> renderPng({
    required String data,
    required int errorLevel,
  }) async {
    final painter = QrPainter(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: errorLevel,
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
}
