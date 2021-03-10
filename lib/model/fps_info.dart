import 'package:json_annotation/json_annotation.dart';

part 'fps_info.g.dart';

@JsonSerializable()
class FpsInfo extends Object {
  @JsonKey(name: 'fps')
  double fps;

  @JsonKey(name: 'totalMem')
  int totalMem;

  @JsonKey(name: 'totalPrivateDirty')
  int totalPrivateDirty;

  @JsonKey(name: 'totalPss')
  int totalPss;

  FpsInfo(
    this.fps,
    this.totalMem,
    this.totalPrivateDirty,
    this.totalPss,
  );

  factory FpsInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$FpsInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FpsInfoToJson(this);
}
