import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../common_widgets/common_button.dart';
import '../common_widgets/common_snackbar.dart';
import '../common_widgets/common_text.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../controllers/history_controller.dart';
import '../models/qr_item.dart';
import '../services/qr_export_service.dart';
import '../utils/size_utils.dart';
import 'history_view.dart' show formatDate;

/// Screen 4: one QR code full size, with save, copy and delete.
class DetailView extends StatefulWidget {
  const DetailView({super.key, required this.item});

  final QrItem item;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  bool _saving = false;

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await QrExportService.saveToGallery(
        data: widget.item.text,
        errorLevel: widget.item.errorLevel,
      );
      await Get.find<HistoryController>().add(widget.item);
      CommonSnackbar.show(AppStrings.saved);
    } on QrPermissionDenied {
      CommonSnackbar.show(AppStrings.permissionDenied, isError: true);
    } catch (_) {
      CommonSnackbar.show(AppStrings.saveFailed, isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.item.text));
    CommonSnackbar.show(AppStrings.copied);
  }

  Future<void> _delete() async {
    await Get.find<HistoryController>().remove(widget.item);
    CommonSnackbar.show(AppStrings.deleted);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final side = context.wp(72);

    return Scaffold(
      appBar: AppBar(
        title: const CommonText(AppStrings.detailTitle,
            size: 20, weight: FontWeight.w700),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: AppStrings.delete,
            onPressed: _delete,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.wp(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(context.wp(5)),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(context.wp(3)),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(context.wp(4)),
                      ),
                      child: QrImageView(
                        data: item.text,
                        version: QrVersions.auto,
                        errorCorrectionLevel: item.errorLevel,
                        size: side,
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.qrInk,
                      ),
                    ),
                    SizedBox(height: context.hp(2)),
                    CommonText(item.typeLabel,
                        size: 13,
                        weight: FontWeight.w600,
                        color: AppColors.primaryDark),
                    SizedBox(height: context.hp(0.8)),
                    CommonText(item.text,
                        size: 16,
                        align: TextAlign.center,
                        maxLines: 3),
                    SizedBox(height: context.hp(0.8)),
                    CommonText(formatDate(item.createdAt),
                        size: 12, color: AppColors.textSecondary),
                  ],
                ),
              ),
              SizedBox(height: context.hp(3)),
              CommonButton(
                label: AppStrings.saveToGallery,
                icon: Icons.download_rounded,
                loading: _saving,
                onPressed: _save,
              ),
              SizedBox(height: context.hp(1.5)),
              OutlinedButton.icon(
                onPressed: _copy,
                icon: const Icon(Icons.copy_rounded),
                label: const Text(AppStrings.copyText),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryDark,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: Size(double.infinity, context.hp(6.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.wp(3.5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
