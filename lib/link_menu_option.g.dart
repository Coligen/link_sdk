// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_menu_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkMenuOption _$LinkMenuOptionFromJson(Map<String, dynamic> json) =>
    LinkMenuOption(
      name: json['name'] as String,
    )
      ..extra = json['extra'] as String?
      ..display = json['display'] as String?
      ..enabled = json['enabled'] as bool
      ..active = json['active'] as bool;

Map<String, dynamic> _$LinkMenuOptionToJson(LinkMenuOption instance) =>
    <String, dynamic>{
      'name': instance.name,
      'extra': instance.extra,
      'display': instance.display,
      'enabled': instance.enabled,
      'active': instance.active,
    };
