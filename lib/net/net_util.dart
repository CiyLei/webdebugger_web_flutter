import 'package:dio/dio.dart';

class NetUtil {
  static Dio _dio = Dio();

  static Future<dynamic> Get(String url, {Map<String, dynamic> params}) async {
    Response response = await _dio.get(
      url,
      queryParameters: params,
    );
    return response.data.toString();
  }

  static Future<dynamic> Post(String url, {dynamic params}) async {
    Response response = await _dio.post(url, data: params);
    return response.data;
  }
}
