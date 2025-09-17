import 'package:json_annotation/json_annotation.dart';

import 'link_code.dart';
import 'link_menu_option.dart';

part 'link_menu.g.dart';

@JsonSerializable()
class LinkMenu {
  int cmd;
  String name;
  String? rule;
  List<LinkMenuOption> options;
  int active = 0;
  bool enabled = true;
  int type = CommandType.LINK_CMD_TYPE_NORMAL;
  int group = CommandGroup.LINK_CMD_GROUP_DEVICE;
  int order = 0;

  LinkMenu({required this.cmd, required this.name, required this.options});
  
  factory LinkMenu.fromJson(Map<String, dynamic> json) => _$LinkMenuFromJson(json);
  Map<String, dynamic> toJson() => _$LinkMenuToJson(this);

  @override
  String toString() {
    return 'LinkMenu${toJson().toString()}';
  }
}