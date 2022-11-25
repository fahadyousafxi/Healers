/*
 * File name: wallets_controller.dart
 * Last modified: 2022.10.16 at 12:23:12
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/wallet_model.dart';
import '../../../models/wallet_transaction_model.dart';
import '../../../repositories/payment_repository.dart';

class WalletsController extends GetxController {
  final wallets = <Wallet>[].obs;
  final walletTransactions = <WalletTransaction>[].obs;
  final selectedWallet = new Wallet().obs;
  PaymentRepository _paymentRepository;

  WalletsController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() async {
    await refreshWallets();
    super.onInit();
  }

  Future refreshWallets({bool showMessage}) async {
    await getWallets();
    initSelectedWallet();
    await getWalletTransactions();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of wallets refreshed successfully".tr));
    }
  }

  Future getWallets() async {
    try {
      wallets.assignAll(await _paymentRepository.getWallets());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getWalletTransactions() async {
    try {
      walletTransactions.assignAll(await _paymentRepository.getWalletTransactions(selectedWallet.value));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void initSelectedWallet() {
    if (!selectedWallet.value.hasData && wallets.isNotEmpty) {
      selectedWallet.value = wallets.elementAt(0);
    }
  }
}
