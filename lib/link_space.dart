import 'package:json_annotation/json_annotation.dart';

part 'link_space.g.dart';

@JsonSerializable()
class LinkSpace {
  int free;
  int total;

  LinkSpace({required this.free, required this. total});

  factory LinkSpace.fromJson(Map<String, dynamic> json) => _$LinkSpaceFromJson(json);
  Map<String, dynamic> toJson() => _$LinkSpaceToJson(this);

  @override
  String toString() {
    return 'LinkSpace${toJson().toString()}';
  }
}