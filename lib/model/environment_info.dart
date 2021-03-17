import 'package:json_annotation/json_annotation.dart';

part 'environment_info.g.dart';

@JsonSerializable()
class EnvironmentInfo extends Object {
  @JsonKey(name: 'environment')
  List<Environment> environment;

  @JsonKey(name: 'url')
  String url;

  EnvironmentInfo(
    this.environment,
    this.url,
  );

  factory EnvironmentInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$EnvironmentInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EnvironmentInfoToJson(this);
}

@JsonSerializable()
class Environment extends Object {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'url')
  String url;

  Environment(
    this.name,
    this.url,
  );

  factory Environment.fromJson(Map<String, dynamic> srcJson) =>
      _$EnvironmentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EnvironmentToJson(this);
}
