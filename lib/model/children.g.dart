// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'children.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Children _$ChildrenFromJson(Map<String, dynamic> json) {
  return Children(
    (json['children'] as List)
        ?.map((e) =>
            e == null ? null : Children.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['id'] as String,
    json['label'] as String,
  );
}

Map<String, dynamic> _$ChildrenToJson(Children instance) => <String, dynamic>{
      'children': instance.children,
      'id': instance.id,
      'label': instance.label,
    };
