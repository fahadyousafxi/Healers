import 'option_model.dart';
import 'parents/model.dart';

class OptionGroup extends Model {
  String id;
  String name;
  bool allowMultiple;
  List<Option> options;

  OptionGroup({this.id, this.name, this.options});

  OptionGroup.fromJson(Map<String, dynamic> json, {eServiceId}) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    allowMultiple = boolFromJson(json, 'allow_multiple');
    options = listFromJson(json, 'options', (v) => Option.fromJson(v));
    if (eServiceId != null) {
      options.removeWhere((element) => element.eServiceId != eServiceId);
    }
  }

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["allow_multiple"] = allowMultiple;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is OptionGroup &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          allowMultiple == other.allowMultiple &&
          options == other.options;

  @override
  int get hashCode => super.hashCode ^ id.hashCode ^ name.hashCode ^ allowMultiple.hashCode ^ options.hashCode;
}
