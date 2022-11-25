/*
 * File name: salons_list_widget.dart
 * Last modified: 2022.10.16 at 12:23:17
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/salons_controller.dart';
import 'salons_empty_list_widget.dart';
import 'salons_list_item_widget.dart';

class SalonsListWidget extends GetView<SalonsController> {
  SalonsListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<LaravelApiClient>().isLoading(tasks: ['getSalons', 'getAcceptedSalons', 'getFeaturedSalons', 'getPendingSalons'])) {
        return CircularLoadingWidget(height: 300);
      } else {
        if (controller.salons.isEmpty && controller.selected.value == SalonFilter.ALL) {
          return SalonsEmptyListWidget();
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.salons.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.salons.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: controller.isLoading.value ? 1 : 0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              });
            } else {
              var _salon = controller.salons.elementAt(index);
              return SalonsListItemWidget(salon: _salon);
            }
          }),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 20);
          },
        );
      }
    });
  }
}
