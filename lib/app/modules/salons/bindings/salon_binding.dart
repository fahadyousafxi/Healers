/*
 * File name: salon_binding.dart
 * Last modified: 2022.10.16 at 12:23:14
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../controllers/salon_addresses_form_controller.dart';
import '../controllers/salon_availability_form_controller.dart';
import '../controllers/salon_controller.dart';
import '../controllers/salon_e_services_controller.dart';
import '../controllers/salon_form_controller.dart';

class SalonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalonController>(
      () => SalonController(),
    );
    Get.lazyPut<SalonFormController>(
      () => SalonFormController(),
    );
    Get.lazyPut<SalonAddressesFormController>(
      () => SalonAddressesFormController(),
    );
    Get.lazyPut<SalonAvailabilityFormController>(
      () => SalonAvailabilityFormController(),
    );
    Get.lazyPut<SalonEServicesController>(
      () => SalonEServicesController(),
    );
  }
}
