import 'package:json_annotation/json_annotation.dart';

part 'link_menu_option.g.dart';

@JsonSerializable()
class LinkMenuOption {
  String name;
  String? extra;
  String? display;
  bool enabled = true;
  bool active = false;

  LinkMenuOption({required this.name});
  
  factory LinkMenuOption.fromJson(Map<String, dynamic> json) => _$LinkMenuOptionFromJson(json);
  Map<String, dynamic> toJson() => _$LinkMenuOptionToJson(this);

  @override
  String toString() {
    return 'LinkMenuOption${toJson().toString()}';
  }
}