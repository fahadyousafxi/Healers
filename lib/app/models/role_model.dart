/*
 * File name: role_model.dart
 * Last modified: 2022.10.16 at 12:23:13
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'parents/model.dart';

class Role extends Model {
  String id;
  String name;
  bool isdDefault;

  Role({this.id, this.name, this.isdDefault});

  Role.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    isdDefault = boolFromJson(json, 'default');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['default'] = this.isdDefault;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other && other is Role && runtimeType == other.runtimeType && id == other.id && name == other.name && isdDefault == other.isdDefault;

  @override
  int get hashCode => super.hashCode ^ id.hashCode ^ name.hashCode ^ isdDefault.hashCode;
}
