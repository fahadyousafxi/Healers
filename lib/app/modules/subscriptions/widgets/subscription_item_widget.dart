/*
 * File name: subscription_item_widget.dart
 * Last modified: 2022.10.16 at 12:23:13
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/salon_subscription_model.dart';

class SubscriptionItemWidget extends StatelessWidget {
  final SalonSubscription subscription;

  SubscriptionItemWidget({Key key, this.subscription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: Ui.getBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            this.subscription.salon.name,
            style: Get.textTheme.bodyText2,
          ),
          Divider(
            height: 30,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(text: "Starts At".tr, style: Get.textTheme.bodyText1, children: <TextSpan>[
                      TextSpan(
                        text: DateFormat('  d, MMMM y  HH:mm', Get.locale.toString()).format(subscription.startsAt),
                        style: Get.textTheme.caption,
                      ),
                    ]),
                  ),
                  RichText(
                    text: TextSpan(text: "Expires At".tr, style: Get.textTheme.bodyText1, children: <TextSpan>[
                      TextSpan(
                        text: DateFormat('  d, MMMM y  HH:mm', Get.locale.toString()).format(subscription.expiresAt),
                        style: Get.textTheme.caption,
                      ),
                    ]),
                  ),
                ],
              ),
              if (subscription.active)
                Container(
                  child: Text("Enabled".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyText2.merge(
                        TextStyle(color: Colors.green),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
              if (!subscription.active)
                Container(
                  child: Text("Disabled".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyText2.merge(
                        TextStyle(color: Colors.grey),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Payment Method".tr,
                  style: Get.textTheme.bodyText1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  subscription.payment?.paymentMethod?.getName(),
                  style: Get.textTheme.bodyText2,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  subscription.subscriptionPackage.name,
                  style: Get.textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (subscription.payment != null)
                Ui.getPrice(
                  subscription.payment.amount,
                  style: Get.textTheme.headline6,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
