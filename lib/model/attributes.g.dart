// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attributes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attributes _$AttributesFromJson(Map<String, dynamic> json) {
  return Attributes(
    json['attributes'] as String,
    json['description'] as String,
    json['inputType'] as int,
    json['isEdit'] as bool,
    (json['selectOptions'] as List)?.map((e) => e as String)?.toList(),
    json['type'] as int,
    json['value'] as String,
  );
}

Map<String, dynamic> _$AttributesToJson(Attributes instance) =>
    <String, dynamic>{
      'attributes': instance.attributes,
      'description': instance.description,
      'inputType': instance.inputType,
      'isEdit': instance.isEdit,
      'selectOptions': instance.selectOptions,
      'type': instance.type,
      'value': instance.value,
    };
