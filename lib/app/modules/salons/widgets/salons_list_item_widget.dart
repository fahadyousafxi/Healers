/*
 * File name: salons_list_item_widget.dart
 * Last modified: 2022.10.16 at 12:23:13
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/salon_model.dart';
import '../../../routes/app_routes.dart';
import '../themes/salons_list_item_theme.dart';
import 'salon_main_thumb_widget.dart';

class SalonsListItemWidget extends StatelessWidget {
  const SalonsListItemWidget({
    Key key,
    @required Salon salon,
  })  : _salon = salon,
        super(key: key);

  final Salon _salon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.SALON, arguments: {'salon': _salon, 'heroTag': 'salons_list_item'});
      },
      child: Container(
        width: double.infinity,
        decoration: containerBoxDecoration(),
        child: Column(
          children: [
            SalonMainThumbWidget(salon: _salon),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    _salon.name ?? '',
                    maxLines: 2,
                    style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.hintColor)),
                  ),
                  Text(
                    _salon.description ?? '',
                    maxLines: 3,
                    style: Get.textTheme.bodyText1,
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 5,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Wrap(
                        children: Ui.getStarsList(_salon.rate),
                      ),
                    ],
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
