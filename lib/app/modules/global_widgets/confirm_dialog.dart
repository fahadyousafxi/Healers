/*
 * File name: confirm_dialog.dart
 * Last modified: 2022.10.16 at 12:23:17
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog<V> extends StatefulWidget {
  ConfirmDialog({Key key, this.content, this.title, this.submitText, this.cancelText}) : super(key: key);

  final String title;
  final String content;
  final String submitText;
  final String cancelText;

  @override
  State<StatefulWidget> createState() => _ConfirmDialogState<V>();
}

class _ConfirmDialogState<V> extends State<ConfirmDialog<V>> {
  void _onCancelTap() {
    Navigator.pop(context, false);
  }

  void _onSubmitTap() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? "Confirm".tr),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: Padding(
        padding: EdgeInsetsDirectional.only(start: 24.0, end: 20.0, top: 12.0, bottom: 12.0),
        child: Text(widget.content ?? "Are you sure?".tr, style: Get.textTheme.bodyText2),
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 0,
          child: Text(widget.cancelText ?? ""),
          onPressed: _onCancelTap,
        ),
        MaterialButton(
          elevation: 0,
          child: Text(widget.submitText ?? ""),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }
}
