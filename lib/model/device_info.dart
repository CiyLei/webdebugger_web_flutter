import 'package:json_annotation/json_annotation.dart';

part 'device_info.g.dart';

@JsonSerializable()
class DeviceInfo extends Object {
  @JsonKey(name: 'dbPort')
  int dbPort;

  @JsonKey(name: 'groups')
  List<Groups> groups;

  @JsonKey(name: 'port')
  int port;

  DeviceInfo(
    this.dbPort,
    this.groups,
    this.port,
  );

  factory DeviceInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$DeviceInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);
}

@JsonSerializable()
class Groups extends Object {
  @JsonKey(name: 'groupName')
  String groupName;

  @JsonKey(name: 'infos')
  List<Infos> infos;

  Groups(
    this.groupName,
    this.infos,
  );

  factory Groups.fromJson(Map<String, dynamic> srcJson) =>
      _$GroupsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GroupsToJson(this);
}

@JsonSerializable()
class Infos extends Object {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'value')
  String value;

  Infos(
    this.name,
    this.value,
  );

  factory Infos.fromJson(Map<String, dynamic> srcJson) =>
      _$InfosFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InfosToJson(this);
}
