import 'package:json_annotation/json_annotation.dart';

part 'attributes.g.dart';

@JsonSerializable()
class Attributes extends Object {
  @JsonKey(name: 'attributes')
  String attributes;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'inputType')
  int inputType;

  @JsonKey(name: 'isEdit')
  bool isEdit;

  @JsonKey(name: 'selectOptions')
  List<String> selectOptions;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'value')
  String value;

  Attributes(
    this.attributes,
    this.description,
    this.inputType,
    this.isEdit,
    this.selectOptions,
    this.type,
    this.value,
  );

  factory Attributes.fromJson(Map<String, dynamic> srcJson) =>
      _$AttributesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AttributesToJson(this);
}
