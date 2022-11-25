/*
 * File name: option_item_widget.dart
 * Last modified: 2022.02.27 at 23:37:17
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/option_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/e_service_controller.dart';

class OptionItemWidget extends GetWidget<EServiceController> {
  OptionItemWidget({
    @required Option option,
  }) : _option = option;

  final Option _option;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.offAndToNamed(Routes.OPTIONS_FORM, arguments: {'eService': new EService(id: _option.eServiceId), 'option': _option});
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 3),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: Ui.getBoxDecoration(radius: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                height: 54,
                width: 54,
                fit: BoxFit.cover,
                imageUrl: _option.image.url,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  height: 54,
                  width: 54,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_option.name, style: Get.textTheme.bodyText2).paddingOnly(bottom: 5),
                        Ui.applyHtml(_option.description, style: Get.textTheme.caption),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Ui.getPrice(
                    _option.price,
                    style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.hintColor)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
