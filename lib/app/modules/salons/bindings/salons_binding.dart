/*
 * File name: salons_binding.dart
 * Last modified: 2022.10.16 at 12:23:15
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../../search/controllers/search_controller.dart';
import '../controllers/salon_form_controller.dart';
import '../controllers/salons_controller.dart';

class SalonsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalonsController>(
      () => SalonsController(),
    );
    Get.lazyPut<SalonFormController>(
      () => SalonFormController(),
    );
    Get.lazyPut<SearchController>(
      () => SearchController(),
    );
  }
}
