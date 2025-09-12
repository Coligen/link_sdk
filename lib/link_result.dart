import 'package:json_annotation/json_annotation.dart';

part 'link_result.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class LinkResult<T> {
  final int code;
  final T? data;

  LinkResult({required this.code, required this.data});

  factory LinkResult.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$LinkResultFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$LinkResultToJson(this, toJsonT);

  @override
  String toString() {
    return 'LinkResult{code: $code, data: ${data?.toString()}}';
  }
}
