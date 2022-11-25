/*
 * File name: salon_level_badge_widget.dart
 * Last modified: 2022.10.16 at 12:23:14
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/salon_model.dart';

class SalonLevelBadgeWidget extends StatelessWidget {
  const SalonLevelBadgeWidget({
    Key key,
    @required Salon salon,
  })  : _salon = salon,
        super(key: key);

  final Salon _salon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: 12, top: 10),
      child: Text(_salon.salonLevel?.name ?? '',
          maxLines: 1,
          style: Get.textTheme.bodyText2.merge(
            TextStyle(color: Get.theme.primaryColor, height: 1.4, fontSize: 10),
          ),
          softWrap: false,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.secondary.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }
}
