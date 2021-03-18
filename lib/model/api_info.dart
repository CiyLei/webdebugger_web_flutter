import 'package:json_annotation/json_annotation.dart';

part 'api_info.g.dart';

@JsonSerializable()
class ApiInfo extends Object {
  @JsonKey(name: 'isMock')
  bool isMock;

  @JsonKey(name: 'method')
  String method;

  @JsonKey(name: 'requestBody')
  Map<String, dynamic> requestBody;

  @JsonKey(name: 'detailedReturnType')
  List<DetailedReturnType> detailedReturnType;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'mock')
  String mock;

  @JsonKey(name: 'methodCode')
  String methodCode;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'returnType')
  dynamic returnType;

  /// 是否展示详情
  @JsonKey(ignore: true)
  bool isExpand = false;

  ApiInfo(
    this.isMock,
    this.method,
    this.requestBody,
    this.detailedReturnType,
    this.description,
    this.mock,
    this.methodCode,
    this.url,
    this.returnType,
  );

  factory ApiInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$ApiInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ApiInfoToJson(this);
}

@JsonSerializable()
class DetailedReturnType extends Object {
  @JsonKey(name: 'fileName')
  String fileName;

  @JsonKey(name: 'parameterMap')
  Map<String, String> parameterMap;

  DetailedReturnType(
    this.fileName,
    this.parameterMap,
  );

  factory DetailedReturnType.fromJson(Map<String, dynamic> srcJson) =>
      _$DetailedReturnTypeFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DetailedReturnTypeToJson(this);
}
