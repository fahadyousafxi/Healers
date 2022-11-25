/*
 * File name: wallets_binding.dart
 * Last modified: 2022.10.16 at 12:23:14
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
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
