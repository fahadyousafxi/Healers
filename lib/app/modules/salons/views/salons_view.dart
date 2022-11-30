/*
 * File name: salons_view.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/main_drawer_widget.dart';
import '../controllers/salons_controller.dart';
import '../widgets/salons_list_widget.dart';

class SalonsView extends GetView<SalonsController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add, size: 32, color: Get.theme.primaryColor),
        onPressed: () => {Get.offAndToNamed(Routes.SALON_ADDRESSES_FORM)},
        backgroundColor: Get.theme.colorScheme.secondary,
      ),
      drawer: MainDrawerWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        title: Text(
          "My work places".tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Get.theme.hintColor),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          controller.refreshSalons(showMessage: true);
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: Column(
          children: [
            Container(
              height: 72,
              child: ListView(
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(SalonFilter.values.length, (index) {
                    var _filter = SalonFilter.values.elementAt(index);
                    return Obx(() {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(start: 20),
                        child: RawChip(
                          elevation: 0,
                          label: Text(_filter.toString().tr),
                          labelStyle: controller.isSelected(_filter)
                              ? Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))
                              : Get.textTheme.bodyText2,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                          backgroundColor: Get.theme.focusColor.withOpacity(0.1),
                          selectedColor: Get.theme.colorScheme.secondary,
                          selected: controller.isSelected(_filter),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          showCheckmark: true,
                          checkmarkColor: Get.theme.primaryColor,
                          onSelected: (bool value) {
                            controller.toggleSelected(_filter);
                            controller.loadSalonsOfFilter(filter: controller.selected.value);
                          },
                        ),
                      );
                    });
                  })),
            ),
            Expanded(
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  SalonsListWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
