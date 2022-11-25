/*
 * File name: subscription_binding.dart
 * Last modified: 2022.10.16 at 12:23:17
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../controllers/packages_controller.dart';
import '../controllers/subscriptions_controller.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PackagesController>(
      () => PackagesController(),
    );
    Get.lazyPut<SubscriptionsController>(
      () => SubscriptionsController(),
    );
  }
}
