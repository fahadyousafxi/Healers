/*
 * File name: package_card_widget.dart
 * Last modified: 2022.10.16 at 12:23:13
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/subscription_package_model.dart';

class PackageCardWidget extends StatelessWidget {
  const PackageCardWidget({
    Key key,
    this.subscriptionPackage,
    this.onTap,
  }) : super(key: key);

  final SubscriptionPackage subscriptionPackage;
  final ValueChanged<SubscriptionPackage> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(subscriptionPackage);
      },
      child: Container(
        width: double.maxFinite,
        decoration: Ui.getBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscriptionPackage.name,
                      style: Get.textTheme.headline6,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        Ui.getPrice(
                          subscriptionPackage.getPrice,
                          style: Get.textTheme.headline2.merge(TextStyle(fontSize: 28, color: Get.theme.colorScheme.secondary)),
                        ),
                        if (subscriptionPackage.getOldPrice > 0)
                          Ui.getPrice(
                            subscriptionPackage.getOldPrice,
                            style: Get.textTheme.headline1.merge(TextStyle(color: Get.theme.focusColor, decoration: TextDecoration.lineThrough)),
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Ui.applyHtml(
                      subscriptionPackage.description,
                      style: Get.textTheme.caption,
                    )
                  ],
                )),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Wrap(
                spacing: 5,
                children: [
                  Text(
                    "Choose Package".tr,
                    style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 18,
                    color: Get.theme.colorScheme.secondary,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
