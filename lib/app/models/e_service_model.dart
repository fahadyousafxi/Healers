/*
 * File name: e_service_model.dart
 * Last modified: 2022.03.12 at 01:21:41
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import '../../common/uuid.dart';
import 'category_model.dart';
import 'media_model.dart';
import 'option_group_model.dart';
import 'parents/model.dart';
import 'salon_model.dart';

class EService extends Model {
  String id;
  String name;
  String description;
  List<Media> images;
  double price;
  double discountPrice;
  String duration;
  bool featured;
  bool enableBooking;
  bool enableAtSalon;
  bool enableAtCustomerAddress;
  bool isFavorite;
  List<Category> categories;
  List<Category> subCategories;
  List<OptionGroup> optionGroups;
  Salon salon;

  EService(
      {this.id,
      this.name,
      this.description,
      this.images,
      this.price,
      this.discountPrice,
      this.duration,
      this.featured,
      this.enableBooking,
      this.enableAtSalon,
      this.enableAtCustomerAddress,
      this.isFavorite,
      this.categories,
      this.subCategories,
      this.optionGroups,
      this.salon});

  EService.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description');
    images = mediaListFromJson(json, 'images');
    price = doubleFromJson(json, 'price');
    discountPrice = doubleFromJson(json, 'discount_price');
    duration = durationFromJson(json, 'duration');
    featured = boolFromJson(json, 'featured');
    enableBooking = boolFromJson(json, 'enable_booking');
    enableAtSalon = boolFromJson(json, 'enable_at_salon');
    enableAtCustomerAddress = boolFromJson(json, 'enable_at_customer_address');
    isFavorite = boolFromJson(json, 'is_favorite');
    categories = listFromJson<Category>(json, 'categories', (value) => Category.fromJson(value));
    subCategories = listFromJson<Category>(json, 'sub_categories', (value) => Category.fromJson(value));
    optionGroups = listFromJson<OptionGroup>(json, 'option_groups', (value) => OptionGroup.fromJson(value, eServiceId: id));
    salon = objectFromJson(json, 'salon', (value) => Salon.fromJson(value));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    if (this.description != null) data['description'] = this.description;
    if (this.price != null) data['price'] = this.price;
    if (discountPrice != null) data['discount_price'] = this.discountPrice;
    if (duration != null) data['duration'] = this.duration;
    if (featured != null) data['featured'] = this.featured;
    data['enable_booking'] = this.enableBooking ?? false;
    data['enable_at_salon'] = this.enableAtSalon ?? false;
    data['enable_at_customer_address'] = this.enableAtCustomerAddress ?? false;
    if (isFavorite != null) data['is_favorite'] = this.isFavorite;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v?.id).toList();
    }
    if (this.images != null) {
      data['image'] = this.images.where((element) => Uuid.isUuid(element.id)).map((v) => v.id).toList();
    }
    if (this.subCategories != null) {
      data['sub_categories'] = this.subCategories.map((v) => v.toJson()).toList();
    }
    if (this.optionGroups != null) {
      data['option_groups'] = this.optionGroups.map((v) => v.toJson()).toList();
    }
    if (this.salon != null && this.salon.hasData) {
      data['salon_id'] = this.salon.id;
    }
    return data;
  }

  String get firstImageUrl => this.images?.first?.url ?? '';

  String get firstImageThumb => this.images?.first?.thumb ?? '';

  String get firstImageIcon => this.images?.first?.icon ?? '';

  @override
  bool get hasData {
    return id != null && name != null && description != null;
  }

  /*
  * Get the real price of the service
  * when the discount not set, then it return the price
  * otherwise it return the discount price instead
  * */
  double get getPrice {
    return (discountPrice ?? 0) > 0 ? discountPrice : price;
  }

  /*
  * Get discount price
  * */
  double get getOldPrice {
    return (discountPrice ?? 0) > 0 ? price : 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is EService &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          isFavorite == other.isFavorite &&
          enableBooking == other.enableBooking &&
          categories == other.categories &&
          subCategories == other.subCategories &&
          salon == other.salon;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      salon.hashCode ^
      categories.hashCode ^
      subCategories.hashCode ^
      isFavorite.hashCode ^
      enableBooking.hashCode;
}
