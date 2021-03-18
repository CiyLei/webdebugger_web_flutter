// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiInfo _$ApiInfoFromJson(Map<String, dynamic> json) {
  return ApiInfo(
    json['isMock'] as bool,
    json['method'] as String,
    json['requestBody'] as Map<String, dynamic>,
    (json['detailedReturnType'] as List)
        ?.map((e) => e == null
            ? null
            : DetailedReturnType.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['description'] as String,
    json['mock'] as String,
    json['methodCode'] as String,
    json['url'] as String,
    json['returnType'],
  );
}

Map<String, dynamic> _$ApiInfoToJson(ApiInfo instance) => <String, dynamic>{
      'isMock': instance.isMock,
      'method': instance.method,
      'requestBody': instance.requestBody,
      'detailedReturnType': instance.detailedReturnType,
      'description': instance.description,
      'mock': instance.mock,
      'methodCode': instance.methodCode,
      'url': instance.url,
      'returnType': instance.returnType,
    };

DetailedReturnType _$DetailedReturnTypeFromJson(Map<String, dynamic> json) {
  return DetailedReturnType(
    json['fileName'] as String,
    (json['parameterMap'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
  );
}

Map<String, dynamic> _$DetailedReturnTypeToJson(DetailedReturnType instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'parameterMap': instance.parameterMap,
    };
