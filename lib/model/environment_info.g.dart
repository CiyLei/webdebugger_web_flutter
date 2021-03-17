// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnvironmentInfo _$EnvironmentInfoFromJson(Map<String, dynamic> json) {
  return EnvironmentInfo(
    (json['environment'] as List)
        ?.map((e) =>
            e == null ? null : Environment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['url'] as String,
  );
}

Map<String, dynamic> _$EnvironmentInfoToJson(EnvironmentInfo instance) =>
    <String, dynamic>{
      'environment': instance.environment,
      'url': instance.url,
    };

Environment _$EnvironmentFromJson(Map<String, dynamic> json) {
  return Environment(
    json['name'] as String,
    json['url'] as String,
  );
}

Map<String, dynamic> _$EnvironmentToJson(Environment instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };
