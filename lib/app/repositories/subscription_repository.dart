/*
 * File name: subscription_repository.dart
 * Last modified: 2022.12.12
 * Author: Ditlou tsa Molongoana
 * App Name: The sixth sense
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../models/salon_subscription_model.dart';
import '../models/subscription_package_model.dart';
import '../providers/laravel_provider.dart';

class SubscriptionRepository {
  LaravelApiClient _laravelApiClient;

  SubscriptionRepository() {
    _laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<SubscriptionPackage>> getSubscriptionPackages() {
    return _laravelApiClient.getSubscriptionPackages();
  }

  Future<SalonSubscription> cashSalonSubscription(salonSubscription) {
    return _laravelApiClient.cashSalonSubscription(salonSubscription);
  }

  Future<SalonSubscription> walletSalonSubscription(salonSubscription, wallet) {
    return _laravelApiClient.walletSalonSubscription(salonSubscription, wallet);
  }

  Future<List<SalonSubscription>> getSalonSubscriptions() {
    return _laravelApiClient.getSalonSubscriptions();
  }
}
