/*
 * File name: salons_list_item_theme.dart
 * Last modified: 2022.12.12
 * Author: Ditlou tsa Molongoana
 * App Name: The sixth sense
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
