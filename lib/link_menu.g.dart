// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkMenu _$LinkMenuFromJson(Map<String, dynamic> json) => LinkMenu(
      cmd: (json['cmd'] as num).toInt(),
      name: json['name'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => LinkMenuOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..rule = json['rule'] as String?
      ..active = (json['active'] as num).toInt()
      ..enabled = json['enabled'] as bool
      ..type = (json['type'] as num).toInt()
      ..group = (json['group'] as num).toInt()
      ..order = (json['order'] as num).toInt();

Map<String, dynamic> _$LinkMenuToJson(LinkMenu instance) => <String, dynamic>{
      'cmd': instance.cmd,
      'name': instance.name,
      'rule': instance.rule,
      'options': instance.options,
      'active': instance.active,
      'enabled': instance.enabled,
      'type': instance.type,
      'group': instance.group,
      'order': instance.order,
    };
