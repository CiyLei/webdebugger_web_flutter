import 'package:json_annotation/json_annotation.dart';

part 'media_info.g.dart';

@JsonSerializable()
class MediaInfo extends Object {
  @JsonKey(name: 'list')
  List<String> list;

  @JsonKey(name: 'port')
  int port;

  MediaInfo(
    this.list,
    this.port,
  );

  factory MediaInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$MediaInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MediaInfoToJson(this);
}
