// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_software_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkSoftwareVersion _$LinkSoftwareVersionFromJson(Map<String, dynamic> json) =>
    LinkSoftwareVersion(
      company: json['company'] as String,
      productName: json['productName'] as String,
      type: (json['type'] as num).toInt(),
      buildDate: (json['buildDate'] as num).toInt(),
      buildVersion: json['buildVersion'] as String,
      locale: json['locale'] as String,
    );

Map<String, dynamic> _$LinkSoftwareVersionToJson(
        LinkSoftwareVersion instance) =>
    <String, dynamic>{
      'company': instance.company,
      'productName': instance.productName,
      'type': instance.type,
      'buildDate': instance.buildDate,
      'buildVersion': instance.buildVersion,
      'locale': instance.locale,
    };
