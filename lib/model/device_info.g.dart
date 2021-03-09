// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) {
  return DeviceInfo(
    json['dbPort'] as int,
    (json['groups'] as List)
        ?.map((e) =>
            e == null ? null : Groups.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['port'] as int,
  );
}

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'dbPort': instance.dbPort,
      'groups': instance.groups,
      'port': instance.port,
    };

Groups _$GroupsFromJson(Map<String, dynamic> json) {
  return Groups(
    json['groupName'] as String,
    (json['infos'] as List)
        ?.map(
            (e) => e == null ? null : Infos.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GroupsToJson(Groups instance) => <String, dynamic>{
      'groupName': instance.groupName,
      'infos': instance.infos,
    };

Infos _$InfosFromJson(Map<String, dynamic> json) {
  return Infos(
    json['name'] as String,
    json['value'] as String,
  );
}

Map<String, dynamic> _$InfosToJson(Infos instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };
