/*
 * File name: wallet_form_controller.dart
 * Last modified: 2022.10.16 at 12:23:13
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/wallet_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';

class WalletFormController extends GetxController {
  final wallet = Wallet().obs;
  GlobalKey<FormState> walletForm;
  PaymentRepository _paymentRepository;

  WalletFormController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    _initWallet(arguments: arguments);
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  void _initWallet({Map<String, dynamic> arguments}) {
    if (arguments != null) {
      wallet.value = (arguments['wallet'] as Wallet) ?? Wallet();
    } else {
      wallet.value = new Wallet();
    }
  }

  /*
  * Check if the form for create new wallet or edit
  * */
  bool isCreateForm() {
    return !wallet.value.hasData;
  }

  void createWalletForm() async {
    Get.focusScope.unfocus();
    if (walletForm.currentState.validate()) {
      try {
        walletForm.currentState.save();
        Get.log(wallet.value.toString());
        await _paymentRepository.createWallet(wallet.value);
        await Get.offAndToNamed(Routes.WALLETS);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void updateWalletForm() async {
    Get.focusScope.unfocus();
    if (walletForm.currentState.validate()) {
      try {
        walletForm.currentState.save();
        await _paymentRepository.updateWallet(wallet.value);
        Get.offAndToNamed(Routes.WALLETS);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void deleteWallet(Wallet wallet) async {
    try {
      await _paymentRepository.deleteWallet(wallet);
      Get.offAndToNamed(Routes.WALLETS);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
