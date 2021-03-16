// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaInfo _$MediaInfoFromJson(Map<String, dynamic> json) {
  return MediaInfo(
    (json['list'] as List)?.map((e) => e as String)?.toList(),
    json['port'] as int,
  );
}

Map<String, dynamic> _$MediaInfoToJson(MediaInfo instance) => <String, dynamic>{
      'list': instance.list,
      'port': instance.port,
    };
