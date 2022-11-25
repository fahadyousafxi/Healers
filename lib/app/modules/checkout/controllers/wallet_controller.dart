/*
 * File name: wallet_controller.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/salon_subscription_model.dart';
import '../../../models/wallet_model.dart';
import '../../../repositories/subscription_repository.dart';

class WalletController extends GetxController {
  final salonSubscription = new SalonSubscription().obs;
  final wallet = new Wallet().obs;

  SubscriptionRepository _subscriptionRepository;

  WalletController() {
    _subscriptionRepository = new SubscriptionRepository();
  }

  @override
  void onInit() {
    salonSubscription.value = Get.arguments['salonSubscription'] as SalonSubscription;
    wallet.value = Get.arguments['wallet'] as Wallet;
    paySubscription();
    super.onInit();
  }

  Future paySubscription() async {
    try {
      salonSubscription.value = await _subscriptionRepository.walletSalonSubscription(salonSubscription.value, wallet.value);
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
