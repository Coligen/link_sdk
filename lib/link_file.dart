import 'package:json_annotation/json_annotation.dart';

part 'link_file.g.dart';

@JsonSerializable()
class LinkFile{
  final String name;
  final int size;
  final int timeStamp;
  final String thumbUrl;
  final String showUrl;
  final String downloadUrl;
  final String extra;

  LinkFile({required this.name, required this.size, required this.timeStamp, required this.thumbUrl, required this.showUrl, required this.downloadUrl, required this.extra});
  
  factory LinkFile.fromJson(Map<String, dynamic> json) => _$LinkFileFromJson(json);
  Map<String, dynamic> toJson() => _$LinkFileToJson(this);

  @override
  String toString() {
    return 'LinkFile${toJson().toString()}';
  }
}