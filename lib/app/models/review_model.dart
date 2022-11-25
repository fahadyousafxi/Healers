/*
 * File name: review_model.dart
 * Last modified: 2022.02.03 at 18:58:11
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */
import 'booking_model.dart';
import 'parents/model.dart';

class Review extends Model {
  String id;
  double rate;
  String review;
  DateTime createdAt;
  Booking booking;

  Review({this.id, this.rate, this.review, this.createdAt});

  Review.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    rate = doubleFromJson(json, 'rate');
    review = stringFromJson(json, 'review');
    createdAt = dateFromJson(json, 'created_at', defaultValue: DateTime.now().toLocal());
    booking = objectFromJson(json, 'booking', (v) => Booking.fromJson(v));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['rate'] = this.rate;
    data['review'] = this.review;
    if (booking != null) {
      data['booking_id'] = booking.id;
    }
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Review &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          rate == other.rate &&
          review == other.review &&
          createdAt == other.createdAt &&
          booking == other.booking;

  @override
  int get hashCode => super.hashCode ^ id.hashCode ^ rate.hashCode ^ review.hashCode ^ createdAt.hashCode ^ booking.hashCode;
}
