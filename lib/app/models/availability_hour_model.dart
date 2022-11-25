/*
 * File name: availability_hour_model.dart
 * Last modified: 2022.10.16 at 12:23:16
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'dart:core';

import 'parents/model.dart';
import 'salon_model.dart';

class AvailabilityHour extends Model {
  String id;
  String day;
  String startAt;
  String endAt;
  String data;
  Salon salon;

  AvailabilityHour({this.id, this.day, this.startAt, this.endAt, this.data, this.salon});

  AvailabilityHour.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    day = transStringFromJson(json, 'day');
    startAt = stringFromJson(json, 'start_at');
    endAt = stringFromJson(json, 'end_at');
    data = transStringFromJson(json, 'data');
    salon = objectFromJson(json, 'salon', (value) => Salon.fromJson(value));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (day != null) data['day'] = this.day;
    if (startAt != null) data['start_at'] = this.startAt;
    if (endAt != null) data['end_at'] = this.endAt;
    if (data != null) data['data'] = this.data;
    if (this.salon != null) data['salon_id'] = this.salon.id;
    return data;
  }

  String toDuration() {
    return '$startAt - $endAt';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is AvailabilityHour &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          day == other.day &&
          startAt == other.startAt &&
          endAt == other.endAt &&
          data == other.data &&
          salon == other.salon;

  @override
  int get hashCode => super.hashCode ^ id.hashCode ^ day.hashCode ^ startAt.hashCode ^ endAt.hashCode ^ data.hashCode ^ salon.hashCode;
}
