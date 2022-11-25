import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../services/settings_service.dart';
import '../../../services/translation_service.dart';
import 'theme_mode_controller.dart';

class LanguageController extends GetxController {
  GetStorage _box;

  LanguageController() {
    _box = new GetStorage();
  }

  void updateLocale(value) async {
    await Get.find<TranslationService>().loadTranslation(locale: value);
    if (value.contains('_')) {
      // en_US
      Get.updateLocale(Locale(value.split('_').elementAt(0), value.split('_').elementAt(1)));
    } else {
      // en
      Get.updateLocale(Locale(value));
    }
    await _box.write('language', value);
    if (Get.isDarkMode) {
      Get.find<ThemeModeController>().changeThemeMode(ThemeMode.light);
    }
    Get.rootController.setTheme(Get.find<SettingsService>().getLightTheme());
  }
}
