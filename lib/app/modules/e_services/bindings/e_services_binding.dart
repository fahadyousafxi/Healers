import 'package:get/get.dart';

import '../../search/controllers/search_controller.dart';
import '../controllers/e_service_controller.dart';
import '../controllers/e_service_form_controller.dart';
import '../controllers/e_services_controller.dart';
import '../controllers/options_form_controller.dart';

class EServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EServicesController>(
      () => EServicesController(),
    );
    Get.lazyPut<EServiceController>(
      () => EServiceController(),
    );
    Get.lazyPut<EServiceFormController>(
      () => EServiceFormController(),
    );
    Get.lazyPut<OptionsFormController>(
      () => OptionsFormController(),
    );
    Get.lazyPut<SearchController>(
      () => SearchController(),
    );
  }
}
