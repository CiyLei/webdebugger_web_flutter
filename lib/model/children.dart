import 'package:json_annotation/json_annotation.dart';

part 'children.g.dart';

@JsonSerializable()
class Children extends Object {
  @JsonKey(name: 'children')
  List<Children> children;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'label')
  String label;

  bool expand = true;

  Children(
    this.children,
    this.id,
    this.label,
  );

  factory Children.fromJson(Map<String, dynamic> srcJson) =>
      _$ChildrenFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ChildrenToJson(this);
}
