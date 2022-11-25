/*
 * File name: booking_model.dart
 * Last modified: 2022.02.27 at 23:37:17
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'address_model.dart';
import 'booking_status_model.dart';
import 'coupon_model.dart';
import 'e_service_model.dart';
import 'option_model.dart';
import 'parents/model.dart';
import 'payment_model.dart';
import 'salon_model.dart';
import 'tax_model.dart';
import 'user_model.dart';

class Booking extends Model {
  String id;
  String hint;
  bool cancel;
  bool atSalon;
  double duration;
  int quantity;
  BookingStatus status;
  User user;
  User employee;
  List<EService> eServices;
  Salon salon;
  List<Option> options;
  List<Tax> taxes;
  Address address;
  Coupon coupon;
  DateTime bookingAt;
  DateTime startAt;
  DateTime endsAt;
  Payment payment;
  double total;
  double subTotal;
  double taxesValue;

  Booking(
      {this.id,
      this.hint,
      this.cancel,
      this.atSalon,
      this.duration,
      this.quantity,
      this.status,
      this.user,
      this.employee,
      this.eServices,
      this.salon,
      this.options,
      this.taxes,
      this.address,
      this.coupon,
      this.bookingAt,
      this.startAt,
      this.endsAt,
      this.payment,
      this.total,
      this.subTotal,
      this.taxesValue});

  Booking.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    hint = stringFromJson(json, 'hint');
    cancel = boolFromJson(json, 'cancel');
    atSalon = boolFromJson(json, 'at_salon');
    duration = doubleFromJson(json, 'duration');
    quantity = intFromJson(json, 'quantity');
    status = objectFromJson(json, 'booking_status', (v) => BookingStatus.fromJson(v));
    user = objectFromJson(json, 'user', (v) => User.fromJson(v));
    employee = objectFromJson(json, 'employee', (v) => User.fromJson(v));
    eServices = listFromJson(json, 'e_services', (v) => EService.fromJson(v));
    salon = objectFromJson(json, 'salon', (v) => Salon.fromJson(v));
    address = objectFromJson(json, 'address', (v) => Address.fromJson(v));
    coupon = objectFromJson(json, 'coupon', (v) => Coupon.fromJson(v));
    payment = objectFromJson(json, 'payment', (v) => Payment.fromJson(v));
    options = listFromJson(json, 'options', (v) => Option.fromJson(v));
    taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    bookingAt = dateFromJson(json, 'booking_at', defaultValue: null);
    startAt = dateFromJson(json, 'start_at', defaultValue: null);
    endsAt = dateFromJson(json, 'ends_at', defaultValue: null);
    total = doubleFromJson(json, 'total', defaultValue: null);
    subTotal = doubleFromJson(json, 'subTotal', defaultValue: null);
    taxesValue = doubleFromJson(json, 'taxesValue', defaultValue: null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.id != null) {
      data['id'] = this.id;
    }
    if (this.hint != null) {
      data['hint'] = this.hint;
    }
    if (this.duration != null) {
      data['duration'] = this.duration;
    }
    if (this.quantity != null) {
      data['quantity'] = this.quantity;
    }
    if (this.cancel != null) {
      data['cancel'] = this.cancel;
    }
    if (this.status != null) {
      data['booking_status_id'] = this.status.id;
    }
    if (this.coupon != null && this.coupon.id != null) {
      data['code'] = this.coupon.code;
    }
    if (this.taxes != null) {
      data['taxes'] = this.taxes.map((e) => e.toJson()).toList();
    }
    if (this.options != null && this.options.isNotEmpty) {
      data['options'] = this.options.map((e) => e.id).toList();
    }
    if (this.user != null) {
      data['user_id'] = this.user.id;
    }
    if (this.employee != null) {
      data['employee_id'] = this.employee.id;
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.eServices != null) {
      data['e_services'] = this.eServices.map((e) => e.id).toList();
    }
    if (this.salon != null) {
      data['salon_id'] = this.salon.id;
    }
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    if (this.bookingAt != null) {
      data['booking_at'] = bookingAt.toUtc().toString();
    }
    if (this.startAt != null) {
      data['start_at'] = startAt.toUtc().toString();
    }
    if (this.endsAt != null) {
      data['ends_at'] = endsAt.toUtc().toString();
    }
    return data;
  }

  double getTotal() {
    if (this.total != null) return this.total;
    double total = getSubtotal();
    total += getTaxesValue();
    total -= getCouponValue();
    return total;
  }

  double getTaxesValue() {
    if (this.taxesValue != null) return this.taxesValue;
    double total = getSubtotal();
    double taxValue = 0.0;
    taxes?.forEach((element) {
      if (element.type == 'percent') {
        taxValue += (total * element.value / 100);
      } else {
        taxValue += element.value;
      }
    });
    return taxValue;
  }

  double getCouponValue() {
    return coupon?.value ?? 0;
  }

  double getSubtotal() {
    if (this.subTotal != null) return this.subTotal;
    double total = 0.0;
    eServices?.forEach((element) {
      total += element.getPrice * (quantity >= 1 ? quantity : 1);
    });
    options?.forEach((element) {
      total += element.price * (quantity >= 1 ? quantity : 1);
    });
    return total;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Booking &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          hint == other.hint &&
          cancel == other.cancel &&
          duration == other.duration &&
          quantity == other.quantity &&
          status == other.status &&
          user == other.user &&
          eServices == other.eServices &&
          salon == other.salon &&
          options == other.options &&
          taxes == other.taxes &&
          address == other.address &&
          coupon == other.coupon &&
          bookingAt == other.bookingAt &&
          startAt == other.startAt &&
          endsAt == other.endsAt &&
          payment == other.payment;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      hint.hashCode ^
      cancel.hashCode ^
      duration.hashCode ^
      quantity.hashCode ^
      status.hashCode ^
      user.hashCode ^
      eServices.hashCode ^
      salon.hashCode ^
      options.hashCode ^
      taxes.hashCode ^
      address.hashCode ^
      coupon.hashCode ^
      bookingAt.hashCode ^
      startAt.hashCode ^
      endsAt.hashCode ^
      payment.hashCode;
}
