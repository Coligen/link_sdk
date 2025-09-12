// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkFile _$LinkFileFromJson(Map<String, dynamic> json) => LinkFile(
      name: json['name'] as String,
      size: (json['size'] as num).toInt(),
      timeStamp: (json['timeStamp'] as num).toInt(),
      thumbUrl: json['thumbUrl'] as String,
      showUrl: json['showUrl'] as String,
      downloadUrl: json['downloadUrl'] as String,
      extra: json['extra'] as String,
    );

Map<String, dynamic> _$LinkFileToJson(LinkFile instance) => <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'timeStamp': instance.timeStamp,
      'thumbUrl': instance.thumbUrl,
      'showUrl': instance.showUrl,
      'downloadUrl': instance.downloadUrl,
      'extra': instance.extra,
    };
