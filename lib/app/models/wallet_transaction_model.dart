/*
 * File name: wallet_transaction_model.dart
 * Last modified: 2022.10.16 at 12:23:15
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:math';

import 'parents/model.dart';
import 'user_model.dart';

enum TransactionActions { CREDIT, DEBIT }

class WalletTransaction extends Model {
  String id;
  double amount;
  String description;
  TransactionActions action;
  DateTime dateTime;
  User user;

  WalletTransaction({this.id, this.amount, this.description, this.action, this.user});

  WalletTransaction.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    description = stringFromJson(json, 'description');
    amount = doubleFromJson(json, 'amount');
    user = objectFromJson(json, 'user', (value) => User.fromJson(value));
    dateTime = dateFromJson(json, 'created_at', defaultValue: null);
    if (json != null) {
      if (json['action'] == 'credit') {
        action = TransactionActions.CREDIT;
      } else if (json['action'] == 'debit') {
        action = TransactionActions.DEBIT;
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['action'] = this.action;
    data['user'] = this.user;
    return data;
  }

  String getDescription() {
    description = description ?? "";
    return description.substring(description.length - min(description.length, 20), description.length);
  }
}
