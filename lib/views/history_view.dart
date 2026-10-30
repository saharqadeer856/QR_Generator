import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common_widgets/common_text.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../controllers/history_controller.dart';
import '../models/qr_item.dart';
import '../routes/app_routes.dart';
import '../utils/size_utils.dart';

/// Screen 3: list of saved QR codes.
class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(AppStrings.historyTitle,
            size: 20, weight: FontWeight.w700),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.items.isEmpty) return const _EmptyHistory();
          return ListView.separated(
            padding: EdgeInsets.all(context.wp(5)),
            itemCount: controller.items.length,
            separatorBuilder: (_, __) => SizedBox(height: context.hp(1.2)),
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return _HistoryTile(
                item: item,
                onTap: () => Get.toNamed(AppRoutes.detail, arguments: item),
                onDelete: () => controller.remove(item),
              );
            },
          );
        }),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final QrItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.wp(4),
            vertical: context.hp(1.4),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: context.wp(12),
                height: context.wp(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.qr_code_2_rounded,
                    color: AppColors.primary),
              ),
              SizedBox(width: context.wp(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(item.text,
                        size: 15, weight: FontWeight.w600, maxLines: 1),
                    SizedBox(height: context.hp(0.5)),
                    CommonText(
                      '${item.typeLabel}  •  ${formatDate(item.createdAt)}',
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.textSecondary),
                tooltip: AppStrings.delete,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "30/10/2026 14:05"
String formatDate(DateTime d) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.wp(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_border_rounded,
                size: context.wp(22), color: AppColors.border),
            SizedBox(height: context.hp(2)),
            const CommonText(AppStrings.historyEmptyTitle,
                size: 18, weight: FontWeight.w600, align: TextAlign.center),
            SizedBox(height: context.hp(1)),
            const CommonText(AppStrings.historyEmptyMessage,
                size: 14,
                color: AppColors.textSecondary,
                align: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
