/*
 * File name: statistics_carousel_widget.dart
 * Last modified: 2022.10.16 at 12:23:13
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/statistic.dart';
import '../../../providers/laravel_provider.dart';
import 'statistic_carousel_item_widget.dart';
import 'statistics_carousel_loader_widget.dart';

class StatisticsCarouselWidget extends StatelessWidget {
  final List<Statistic> statisticsList;

  StatisticsCarouselWidget({Key key, this.statisticsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<LaravelApiClient>().isLoading(task: 'getHomeStatistics')) {
        return StatisticsCarouselLoaderWidget();
      } else {
        return Container(
            child: ListView.builder(
          itemCount: statisticsList.length,
          itemBuilder: (context, index) {
            double _marginLeft = 0;
            (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
            return StatisticCarouselItemWidget(
              marginLeft: _marginLeft,
              statistic: statisticsList.elementAt(index),
            );
          },
          scrollDirection: Axis.horizontal,
        ));
      }
    });
  }
}
