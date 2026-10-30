import 'package:get/get.dart';

import '../controllers/generator_controller.dart';
import '../controllers/history_controller.dart';
import '../services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  late final RxInt defaultErrorLevel = RxInt(_storage.defaultErrorLevel);

  /// Saves the default and applies it to the generator straight away.
  Future<void> setDefaultErrorLevel(int level) async {
    defaultErrorLevel.value = level;
    await _storage.setDefaultErrorLevel(level);
    if (Get.isRegistered<GeneratorController>()) {
      Get.find<GeneratorController>().setErrorLevel(level);
    }
  }

  Future<void> clearHistory() => Get.find<HistoryController>().clearAll();
}
