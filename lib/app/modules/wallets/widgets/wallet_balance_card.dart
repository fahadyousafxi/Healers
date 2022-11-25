/*
 * File name: wallet_balance_card.dart
 * Last modified: 2022.10.16 at 12:23:15
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/wallet_model.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    Key key,
    this.wallet,
    this.onEdit,
    this.onTap,
  }) : super(key: key);

  final Wallet wallet;
  final ValueChanged<Wallet> onEdit;
  final ValueChanged<Wallet> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(wallet);
      },
      child: Stack(
        children: <Widget>[
          Container(
              width: 260,
              height: 170,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                    Get.theme.colorScheme.secondary.withOpacity(1),
                    Get.theme.colorScheme.secondary.withOpacity(0.6),
                    Get.theme.colorScheme.secondary.withOpacity(0.1),
                  ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Ui.getPrice(
                    wallet.balance,
                    style: Get.textTheme.headline2.merge(TextStyle(color: Get.theme.primaryColor, fontSize: 28)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    wallet.name ?? '',
                    style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    wallet.getId(),
                    style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  )
                ],
              )),
          Positioned(
            right: -80,
            bottom: -60,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(150),
              ),
            ),
          ),
          Positioned(
            left: -60,
            top: -80,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(150),
              ),
            ),
          ),
          Positioned(
              right: 32,
              bottom: 22,
              child: IconButton(
                  onPressed: () {
                    onEdit(wallet);
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Get.theme.primaryColor,
                    size: 28,
                  ))),
        ],
      ),
    );
  }
}
