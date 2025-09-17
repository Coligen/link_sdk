import 'package:json_annotation/json_annotation.dart';

part 'link_software_version.g.dart';

@JsonSerializable()
class LinkSoftwareVersion {
  String company;
  String productName;
  int type;
  int buildDate;
  String buildVersion;
  String locale;

  LinkSoftwareVersion({required this.company, required this.productName, required this.type, required this.buildDate, required this.buildVersion, required this.locale});

  factory LinkSoftwareVersion.fromJson(Map<String, dynamic> json) => _$LinkSoftwareVersionFromJson(json);
  Map<String, dynamic> toJson() => _$LinkSoftwareVersionToJson(this);

  @override
  String toString() {
    return 'LinkSoftwareVersion${toJson().toString()}';
  }
}