/*
 * File name: cash_controller.dart
 * Last modified: 2022.10.16 at 12:23:12
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/salon_subscription_model.dart';
import '../../../repositories/subscription_repository.dart';

class CashController extends GetxController {
  final salonSubscription = new SalonSubscription().obs;

  SubscriptionRepository _subscriptionRepository;

  CashController() {
    _subscriptionRepository = new SubscriptionRepository();
  }

  @override
  void onInit() {
    salonSubscription.value = Get.arguments['salonSubscription'] as SalonSubscription;
    paySubscription();
    super.onInit();
  }

  Future paySubscription() async {
    try {
      salonSubscription.value = await _subscriptionRepository.cashSalonSubscription(salonSubscription.value);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isLoading() {
    if (salonSubscription.value != null && !salonSubscription.value.hasData) {
      return true;
    }
    return false;
  }

  bool isDone() {
    if (salonSubscription.value != null && salonSubscription.value.hasData) {
      return true;
    }
    return false;
  }

  bool isFailed() {
    if (salonSubscription.value == null) {
      return true;
    }
    return false;
  }
}
