/*
 * File name: subscriptions_view.dart
 * Last modified: 2022.10.16 at 12:23:12
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../controllers/subscriptions_controller.dart';
import '../widgets/subscription_item_widget.dart';
import '../widgets/subscriptions_list_loader_widget.dart';

class SubscriptionsView extends GetView<SubscriptionsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Get.theme.hintColor),
        title: Text(
          "Subscriptions".tr,
          style: Get.textTheme.headline6.merge(TextStyle(letterSpacing: 1.3, color: Get.theme.hintColor)),
        ),
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          controller.refreshSubscriptions(
            showMessage: true,
          );
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          primary: true,
          shrinkWrap: false,
          children: <Widget>[
            Text("Subscriptions History".tr, style: Get.textTheme.headline5),
            Obx(() {
              if (controller.salonSubscriptions.isEmpty) return SubscriptionsListLoaderWidget(count: 4);
              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 15),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: controller.salonSubscriptions.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  return SubscriptionItemWidget(subscription: controller.salonSubscriptions.elementAt(index));
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
