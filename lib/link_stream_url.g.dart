// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_stream_url.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkStreamUrl _$LinkStreamUrlFromJson(Map<String, dynamic> json) =>
    LinkStreamUrl(
      mode: (json['mode'] as num).toInt(),
      url: json['url'] as String,
    );

Map<String, dynamic> _$LinkStreamUrlToJson(LinkStreamUrl instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'url': instance.url,
    };
