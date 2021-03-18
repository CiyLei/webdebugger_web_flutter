import 'dart:html';

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

  /// 上传文件
  static Future<dynamic> upload(String url, File file) async {
    FileReader fileReader = FileReader();
    fileReader.readAsArrayBuffer(file);
    var result = await fileReader.onLoad.first
        .then((value) => fileReader.result) as List<int>;
    var data = FormData.fromMap(
        {"file": MultipartFile.fromBytes(result, filename: file.name)});
    Response response = await _dio.post(url, data: data);
    return response.data;
  }
}
