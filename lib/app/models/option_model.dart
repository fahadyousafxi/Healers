import 'media_model.dart';
import 'parents/model.dart';

class Option extends Model {
  String id;
  String optionGroupId;
  String eServiceId;
  String name;
  double price;
  Media image;
  String description;

  Option({this.id, this.optionGroupId, this.eServiceId, this.name, this.price, this.image, this.description});

  Option.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    optionGroupId = stringFromJson(json, 'option_group_id', defaultValue: '0');
    eServiceId = stringFromJson(json, 'e_service_id', defaultValue: '0');
    name = transStringFromJson(json, 'name');
    price = doubleFromJson(json, 'price');
    description = transStringFromJson(json, 'description');
    image = mediaFromJson(json, 'image');
  }

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    if (id != null) map["id"] = id;
    if (name != null) map["name"] = name;
    if (price != null) map["price"] = price;
    if (description != null) map["description"] = description;
    if (optionGroupId != null) map["option_group_id"] = optionGroupId;
    if (eServiceId != null) map["e_service_id"] = eServiceId;
    if (this.image != null) {
      map['image'] = this.image.toJson();
    }
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Option &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          optionGroupId == other.optionGroupId &&
          eServiceId == other.eServiceId &&
          name == other.name &&
          price == other.price &&
          image == other.image &&
          description == other.description;

  @override
  int get hashCode => super.hashCode ^ id.hashCode ^ optionGroupId.hashCode ^ eServiceId.hashCode ^ name.hashCode ^ price.hashCode ^ image.hashCode ^ description.hashCode;
}
