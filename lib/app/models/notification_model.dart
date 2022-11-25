import 'package:get/get.dart';

import 'parents/model.dart';

class Notification extends Model {
  String id;
  String type;
  Map<String, dynamic> data;
  bool read;
  DateTime createdAt;

  Notification();

  Notification.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    type = stringFromJson(json, 'type');
    data = mapFromJson(json, 'data', defaultValue: {});
    read = boolFromJson(json, 'read_at');
    createdAt = dateFromJson(json, 'created_at', defaultValue: DateTime.now().toLocal());
  }

  Map markReadMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["read_at"] = !read;
    return map;
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  String getMessage() {
    if (type == 'App\\Notifications\\NewMessage' && data['from'] != null) {
      return data['from'] + ' ' + type.tr;
    } else if (data['booking_id'] != null) {
      return '#' + data['booking_id'].toString() + ' ' + type.tr;
    } else {
      return type.tr;
    }
  }
}
