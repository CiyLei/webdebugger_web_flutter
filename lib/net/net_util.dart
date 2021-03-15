import 'package:dio/dio.dart';

/// 网络请求封装出
///
/// 目的让接口请求和具体的网络请求库分离
class NetUtil {
  static Dio _dio = Dio();

  /// get请求
  static Future<dynamic> get(String url, {Map<String, dynamic> params}) async {
    Response response = await _dio.get(
      url,
      queryParameters: params,
    );
    return response.data.toString();
  }

  /// post请求
  static Future<dynamic> post(String url, {dynamic params}) async {
    Response response = await _dio.post(url, data: params);
    return response.data;
  }
}
