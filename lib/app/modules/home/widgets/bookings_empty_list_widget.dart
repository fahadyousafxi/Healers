/*
 * File name: bookings_empty_list_widget.dart
 * Last modified: 2022.10.16 at 12:14:05
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingsEmptyListWidget extends StatelessWidget {
  const BookingsEmptyListWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(height: 60),
        Stack(
          children: <Widget>[
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                    Colors.grey.withOpacity(0.6),
                    Colors.grey.withOpacity(0.2),
                  ])),
              child: Icon(
                Icons.assignment_outlined,
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 70,
              ),
            ),
            Positioned(
              right: -30,
              bottom: -50,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            ),
            Positioned(
              left: -20,
              top: -50,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 40),
        Opacity(
          opacity: 0.3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "You don't have any booking inside this status".tr,
              textAlign: TextAlign.center,
              style: Get.textTheme.headline4,
            ),
          ),
        ),
      ],
    );
  }
}
