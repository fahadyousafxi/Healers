/*
 * File name: wallets_view.dart
 * Last modified: 2022.12.12
 * Author: Ditlou tsa Molongoana
 * App Name: The sixth sense
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/wallet_transaction_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../controllers/wallets_controller.dart';
import '../widgets/add_wallet_card_widget.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/wallet_transaction_item.dart';
import '../widgets/wallet_transactions_loading_list_widget.dart';
import '../widgets/wallets_loading_list_widget.dart';

class WalletsView extends GetView<WalletsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Wallets".tr,
            style: Get.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
        ),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add, size: 32, color: Get.theme.primaryColor),
          onPressed: () => {Get.offAndToNamed(Routes.WALLET_FORM)},
          backgroundColor: Get.theme.colorScheme.secondary,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: RefreshIndicator(
            onRefresh: () async {
              Get.find<LaravelApiClient>().forceRefresh();
              await controller.refreshWallets(showMessage: true);
              Get.find<LaravelApiClient>().unForceRefresh();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 190,
                    child: Obx(() {
                      if (controller.wallets.isEmpty) {
                        return WalletsLoadingListWidget();
                      }
                      return ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.wallets.length + 1,
                          itemBuilder: (_, index) {
                            if (index == controller.wallets.length) {
                              return GestureDetector(
                                  onTap: () {
                                    Get.offAndToNamed(Routes.WALLET_FORM);
                                  },
                                  child: AddWalletCardWidget());
                            }
                            return WalletBalanceCard(
                              wallet: controller.wallets.elementAt(index),
                              onTap: (wallet) async {
                                controller.walletTransactions.clear();
                                controller.selectedWallet.value = wallet;
                                await controller.getWalletTransactions();
                              },
                              onEdit: (wallet) async {
                                await Get.offAndToNamed(Routes.WALLET_FORM, arguments: {'wallet': wallet});
                              },
                            );
                          });
                    }),
                  ),
                  Text("Wallet Transactions".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 10, right: 22, left: 22),
                  Obx(() {
                    if (controller.walletTransactions.isEmpty) {
                      return WalletTransactionsLoadingListWidget();
                    }
                    return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.walletTransactions.length,
                        itemBuilder: (_, index) {
                          WalletTransaction _transaction = controller.walletTransactions.elementAt(index);
                          return WalletTransactionItem(transaction: _transaction);
                        });
                  }),
                ],
              ),
            )));
  }
}
