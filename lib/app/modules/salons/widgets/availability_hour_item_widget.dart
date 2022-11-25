/*
 * File name: availability_hour_item_widget.dart
 * Last modified: 2022.10.16 at 12:23:15
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/availability_hour_model.dart';

class AvailabilityHourItemWidget extends StatelessWidget {
  const AvailabilityHourItemWidget({
    Key key,
    @required MapEntry<String, List<AvailabilityHour>> availabilityHour,
    @required List<String> data,
  })  : _availabilityHour = availabilityHour,
        _data = data,
        super(key: key);

  final MapEntry<String, List<AvailabilityHour>> _availabilityHour;
  final List<String> _data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
                  Text(_availabilityHour.key.tr).paddingSymmetric(vertical: 5),
                ] +
                List.generate(_data.length, (index) {
                  return Text(
                    _data.elementAt(index),
                    style: Get.textTheme.caption,
                  );
                }),
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
        Column(
          children: List.generate(_availabilityHour.value.length, (index) {
            var _hour = _availabilityHour.value.elementAt(index);
            return Container(
              margin: EdgeInsets.symmetric(vertical: 3),
              width: 125,
              child: Text(
                _hour.toDuration(),
                style: Get.textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                color: Get.theme.focusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            );
          }),
          //mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }
}
