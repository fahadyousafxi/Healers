/*
 * File name: subscription_binding.dart
 * Last modified: 2022.12.12
 * Author: Ditlou tsa Molongoana
 * App Name: The sixth sense
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
