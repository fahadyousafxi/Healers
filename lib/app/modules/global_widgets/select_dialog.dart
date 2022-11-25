/*
 * File name: select_dialog.dart
 * Last modified: 2022.10.16 at 12:23:14
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectDialogItem<V> {
  const SelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class SelectDialog<V> extends StatefulWidget {
  SelectDialog({Key key, this.items, this.initialSelectedValue, this.title, this.submitText, this.cancelText}) : super(key: key);

  final List<SelectDialogItem<V>> items;
  final V initialSelectedValue;
  final String title;
  final String submitText;
  final String cancelText;

  @override
  State<StatefulWidget> createState() => _SelectDialogState<V>();
}

class _SelectDialogState<V> extends State<SelectDialog<V>> {
  var _selectedValue;

  void initState() {
    super.initState();
    if (widget.initialSelectedValue != null) {
      _selectedValue = widget.initialSelectedValue;
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValue = itemValue;
      } else {
        _selectedValue = null;
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? ""),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
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

  Widget _buildItem(SelectDialogItem<V> item) {
    final checked = _selectedValue == item.value;
    return CheckboxListTile(
      value: checked,
      activeColor: Get.theme.colorScheme.secondary,
      title: Text(item.label, style: Theme.of(context).textTheme.bodyText2),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}
