/*
 * File name: wallets_binding.dart
 * Last modified: 2022.12.12
 * Author: Ditlou tsa Molongoana
 * App Name: The sixth sense
 * Copyright (c) 2022
 */

import 'package:get/get.dart';

import '../controllers/wallet_form_controller.dart';
import '../controllers/wallets_controller.dart';

class WalletsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletsController>(
      () => WalletsController(),
    );
    Get.lazyPut<WalletFormController>(
      () => WalletFormController(),
    );
  }
}
