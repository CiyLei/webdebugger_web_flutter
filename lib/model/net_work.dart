import 'package:json_annotation/json_annotation.dart';

part 'net_work.g.dart';

@JsonSerializable()
class NetWork extends Object {
  @JsonKey(name: 'callEndTime')
  int callEndTime;

  @JsonKey(name: 'callFailError')
  String callFailError;

  @JsonKey(name: 'callFailErrorDetail')
  String callFailErrorDetail;

  @JsonKey(name: 'callFailedTime')
  int callFailedTime;

  @JsonKey(name: 'callStartTime')
  int callStartTime;

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'connectEndTime')
  int connectEndTime;

  @JsonKey(name: 'connectFailedTime')
  int connectFailedTime;

  @JsonKey(name: 'connectStartTime')
  int connectStartTime;

  @JsonKey(name: 'connectionAcquiredTime')
  int connectionAcquiredTime;

  @JsonKey(name: 'connectionReleasedTime')
  int connectionReleasedTime;

  @JsonKey(name: 'dnsEndTime')
  int dnsEndTime;

  @JsonKey(name: 'dnsStartTime')
  int dnsStartTime;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'isSent')
  bool isSent;

  @JsonKey(name: 'method')
  String method;

  @JsonKey(name: 'requestBody')
  String requestBody;

  @JsonKey(name: 'requestBodyEndTime')
  int requestBodyEndTime;

  @JsonKey(name: 'requestBodyStartTime')
  int requestBodyStartTime;

  @JsonKey(name: 'requestDataTime')
  String requestDataTime;

  @JsonKey(name: 'requestHeaders')
  Map<String, dynamic> requestHeaders;

  @JsonKey(name: 'requestHeadersEndTime')
  int requestHeadersEndTime;

  @JsonKey(name: 'requestHeadersStartTime')
  int requestHeadersStartTime;

  @JsonKey(name: 'requestTime')
  int requestTime;

  @JsonKey(name: 'responseBody')
  String responseBody;

  @JsonKey(name: 'responseBodyEndTime')
  int responseBodyEndTime;

  @JsonKey(name: 'responseBodyStartTime')
  int responseBodyStartTime;

  @JsonKey(name: 'responseHeaders')
  Map<String, dynamic> responseHeaders;

  @JsonKey(name: 'responseHeadersEndTime')
  int responseHeadersEndTime;

  @JsonKey(name: 'responseHeadersStartTime')
  int responseHeadersStartTime;

  @JsonKey(name: 'secureConnectEndTime')
  int secureConnectEndTime;

  @JsonKey(name: 'secureConnectStartTime')
  int secureConnectStartTime;

  @JsonKey(name: 'timeCost')
  int timeCost;

  @JsonKey(name: 'url')
  String url;

  /// 是否展示详情
  @JsonKey(ignore: true)
  bool isExpand = false;

  /// 控制展示请求头的文本还是json
  @JsonKey(ignore: true)
  var showRequestHeaderText = false;

  /// 控制是否展开显示请求头
  @JsonKey(ignore: true)
  var expandRequestHeader = false;

  /// 控制展示请求内容的文本还是json
  @JsonKey(ignore: true)
  var showRequestBodyText = false;

  /// 控制是否展开显示请求内容
  @JsonKey(ignore: true)
  var expandRequestBody = false;

  /// 控制展示响应头的文本还是json
  @JsonKey(ignore: true)
  var showResponseHeaderText = false;

  /// 控制是否展开显示响应头
  @JsonKey(ignore: true)
  var expandResponseHeader = false;

  /// 控制展示响应内容的文本还是json
  @JsonKey(ignore: true)
  var showResponseBodyText = false;

  /// 控制是否展开显示响应内容
  @JsonKey(ignore: true)
  var expandResponseBody = true;

  /// 控制是否展开显示时间分析
  @JsonKey(ignore: true)
  var expandTimeAnalysis = false;

  NetWork(
    this.callEndTime,
    this.callFailError,
    this.callFailErrorDetail,
    this.callFailedTime,
    this.callStartTime,
    this.code,
    this.connectEndTime,
    this.connectFailedTime,
    this.connectStartTime,
    this.connectionAcquiredTime,
    this.connectionReleasedTime,
    this.dnsEndTime,
    this.dnsStartTime,
    this.id,
    this.isSent,
    this.method,
    this.requestBody,
    this.requestBodyEndTime,
    this.requestBodyStartTime,
    this.requestDataTime,
    this.requestHeaders,
    this.requestHeadersEndTime,
    this.requestHeadersStartTime,
    this.requestTime,
    this.responseBody,
    this.responseBodyEndTime,
    this.responseBodyStartTime,
    this.responseHeaders,
    this.responseHeadersEndTime,
    this.responseHeadersStartTime,
    this.secureConnectEndTime,
    this.secureConnectStartTime,
    this.timeCost,
    this.url,
  );

  factory NetWork.fromJson(Map<String, dynamic> srcJson) =>
      _$NetWorkFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NetWorkToJson(this);
}
