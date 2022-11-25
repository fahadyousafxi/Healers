/*
 * File name: salons_list_item_theme.dart
 * Last modified: 2022.10.16 at 12:23:12
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/cupertino.dart';

import '../widgets/salons_list_item_widget.dart';

extension SalonsListItemTheme on SalonsListItemWidget {
  BoxDecoration containerBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(0)),
      boxShadow: [
        //BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
      ],
    );
  }
}
