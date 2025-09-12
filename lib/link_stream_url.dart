import 'package:json_annotation/json_annotation.dart';

part 'link_stream_url.g.dart';

@JsonSerializable()
class LinkStreamUrl {
  int mode;
  String url;

  LinkStreamUrl({required this.mode, required this.url});

  factory LinkStreamUrl.fromJson(Map<String, dynamic> json) => _$LinkStreamUrlFromJson(json);
  Map<String, dynamic> toJson() => _$LinkStreamUrlToJson(this);

  @override
  String toString() {
    return 'LinkStreamUrl{mode: $mode, url: $url}';
  }
}
