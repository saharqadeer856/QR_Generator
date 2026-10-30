import 'package:get/get.dart';

import '../models/qr_item.dart';
import '../services/storage_service.dart';

/// Saved QR codes, newest first. Permanent, so every screen shares it.
class HistoryController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final RxList<QrItem> items = <QrItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    items.assignAll(_storage.loadHistory());
  }

  /// Adds a code to the top. A code with the same text is moved, not duplicated.
  Future<void> add(QrItem item) async {
    items.removeWhere((e) => e.text == item.text);
    items.insert(0, item);
    if (items.length > StorageService.maxHistory) {
      items.removeRange(StorageService.maxHistory, items.length);
    }
    await _persist();
  }

  Future<void> remove(QrItem item) async {
    items.remove(item);
    await _persist();
  }

  Future<void> clearAll() async {
    items.clear();
    await _storage.clearHistory();
  }

  Future<void> _persist() => _storage.saveHistory(items.toList());
}
