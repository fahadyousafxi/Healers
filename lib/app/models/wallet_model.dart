/*
 * File name: wallet_model.dart
 * Last modified: 2022.10.16 at 12:23:15
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:math';

import '../../common/uuid.dart';
import 'parents/model.dart';

class Wallet extends Model {
  String id;
  String name;
  double balance;

  Wallet({this.id, this.name, this.balance});

  Wallet.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = stringFromJson(json, 'name');
    balance = doubleFromJson(json, 'balance');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) {
      data['id'] = this.id;
    }
    if (name != null) {
      data['name'] = this.name;
    }
    if (balance != null) {
      data['balance'] = this.balance;
    }
    return data;
  }

  String getName() {
    name = name ?? "";
    return name.substring(name.length - min(name.length, 16), name.length);
  }

  String getId() {
    if (Uuid.isUuid(id)) {
      return id.substring(0, 3) + ' . . . ' + id.substring(id.length - 5, id.length);
    } else {
      return id;
    }
  }
}
