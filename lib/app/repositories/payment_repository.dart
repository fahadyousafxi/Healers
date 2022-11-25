/*
 * File name: payment_repository.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/salon_subscription_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../providers/laravel_provider.dart';

class PaymentRepository {
  LaravelApiClient _laravelApiClient;

  PaymentRepository() {
    _laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<PaymentMethod>> getMethods() {
    return _laravelApiClient.getPaymentMethods();
  }

  Future<List<Wallet>> getWallets() {
    return _laravelApiClient.getWallets();
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) {
    return _laravelApiClient.getWalletTransactions(wallet);
  }

  Future<Wallet> createWallet(Wallet wallet) {
    return _laravelApiClient.createWallet(wallet);
  }

  Future<Wallet> updateWallet(Wallet wallet) {
    return _laravelApiClient.updateWallet(wallet);
  }

  Future<bool> deleteWallet(Wallet wallet) {
    return _laravelApiClient.deleteWallet(wallet);
  }

  Future<Payment> update(Payment payment) {
    return _laravelApiClient.updatePayment(payment);
  }

  String getPayPalUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getPayPalUrl(salonSubscription);
  }

  String getRazorPayUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getRazorPayUrl(salonSubscription);
  }

  String getStripeUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getStripeUrl(salonSubscription);
  }

  String getPayStackUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getPayStackUrl(salonSubscription);
  }

  String getPayMongoUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getPayMongoUrl(salonSubscription);
  }

  String getFlutterWaveUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getFlutterWaveUrl(salonSubscription);
  }

  String getStripeFPXUrl(SalonSubscription salonSubscription) {
    return _laravelApiClient.getStripeFPXUrl(salonSubscription);
  }
}
