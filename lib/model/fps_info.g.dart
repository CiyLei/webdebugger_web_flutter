// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fps_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FpsInfo _$FpsInfoFromJson(Map<String, dynamic> json) {
  return FpsInfo(
    (json['fps'] as num)?.toDouble(),
    json['totalMem'] as int,
    json['totalPrivateDirty'] as int,
    json['totalPss'] as int,
  );
}

Map<String, dynamic> _$FpsInfoToJson(FpsInfo instance) => <String, dynamic>{
      'fps': instance.fps,
      'totalMem': instance.totalMem,
      'totalPrivateDirty': instance.totalPrivateDirty,
      'totalPss': instance.totalPss,
    };
