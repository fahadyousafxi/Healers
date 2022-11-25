/*
 * File name: booking_title_bar_loader.dart
 * Last modified: 2022.02.28 at 12:59:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingTitleBarLoaderWidget extends StatelessWidget {
  const BookingTitleBarLoaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.grey[200].withOpacity(0.1),
      child: Row(
        children: [
          Flexible(
              child: Column(
            children: List.generate(3, (index) {
              return Container(
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(vertical: 5),
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
              );
            }),
          )),
          SizedBox(width: 20),
          Container(
            width: 80,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ],
      ),
    );
  }
}
