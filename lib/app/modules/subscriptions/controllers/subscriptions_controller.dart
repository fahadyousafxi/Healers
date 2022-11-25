/*
 * File name: subscriptions_controller.dart
 * Last modified: 2022.10.16 at 12:23:12
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/salon_subscription_model.dart';
import '../../../repositories/subscription_repository.dart';

class SubscriptionsController extends GetxController {
  final salonSubscriptions = <SalonSubscription>[].obs;
  SubscriptionRepository _subscriptionRepository;

  SubscriptionsController() {
    _subscriptionRepository = new SubscriptionRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshSubscriptions();
    super.onInit();
  }

  Future refreshSubscriptions({bool showMessage}) async {
    await getSubscriptions();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of subscriptions refreshed successfully".tr));
    }
  }

  Future getSubscriptions() async {
    try {
      salonSubscriptions.clear();
      salonSubscriptions.assignAll(await _subscriptionRepository.getSalonSubscriptions());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
