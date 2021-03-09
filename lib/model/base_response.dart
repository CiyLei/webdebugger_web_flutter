import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> extends Object {
  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  T data;

  @JsonKey(name: 'message')
  String message;

  @JsonKey(name: 'success')
  bool success;

  BaseResponse(
    this.code,
    this.data,
    this.message,
    this.success,
  );

  factory BaseResponse.fromJson(
          Map<String, dynamic> srcJson, T Function(Object data) fromJsonT) =>
      _$BaseResponseFromJson(srcJson, fromJsonT);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this, (data) => data);
}
