/*
 * File name: add_wallet_card_widget.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddWalletCardWidget extends StatelessWidget {
  const AddWalletCardWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            width: 260,
            height: 170,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                  Get.theme.focusColor.withOpacity(0.6),
                  Get.theme.focusColor.withOpacity(0.3),
                  Get.theme.focusColor.withOpacity(0.1),
                ])),
            child: Icon(
              Icons.add,
              size: 72,
              color: Get.theme.primaryColor,
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
        )
      ],
    );
  }
}
