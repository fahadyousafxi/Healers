/*
 * File name: payment_details_widget.dart
 * Last modified: 2022.10.16 at 12:23:37
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/salon_subscription_model.dart';
import '../../bookings/widgets/booking_row_widget.dart';

class PaymentDetailsWidget extends StatelessWidget {
  const PaymentDetailsWidget({
    Key key,
    @required SalonSubscription salonSubscription,
  })  : _salonSubscription = salonSubscription,
        super(key: key);

  final SalonSubscription _salonSubscription;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // decoration: Ui.getBoxDecoration(),
      child: Wrap(
        runSpacing: 10,
        alignment: WrapAlignment.start,
        children: <Widget>[
          Text(
            "Subscription Package".tr,
            style: Get.textTheme.bodyText2,
            maxLines: 3,
            // textAlign: TextAlign.end,
          ),
          Divider(height: 8, thickness: 1),
          BookingRowWidget(
            description: _salonSubscription.subscriptionPackage.name,
            valueStyle: Get.textTheme.bodyText2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Ui.getPrice(_salonSubscription.subscriptionPackage.getPrice, style: Get.textTheme.subtitle2),
            ),
          ),
        ],
      ),
    );
  }
}
