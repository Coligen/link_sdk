// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_space.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkSpace _$LinkSpaceFromJson(Map<String, dynamic> json) => LinkSpace(
      free: (json['free'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$LinkSpaceToJson(LinkSpace instance) => <String, dynamic>{
      'free': instance.free,
      'total': instance.total,
    };
