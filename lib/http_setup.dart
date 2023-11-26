import 'package:dio/dio.dart';

const String baseUrl =
    "http://ec2-13-209-75-188.ap-northeast-2.compute.amazonaws.com";

BaseOptions options = new BaseOptions(
    baseUrl: baseUrl,
    receiveDataWhenStatusError: true,
    connectTimeout: Duration(seconds: 3),
    receiveTimeout: Duration(seconds: 3));
Dio dio = new Dio(options);

Future<Response> post(String url, Map<String, dynamic>? body) async {
  final response = await dio.post('$baseUrl$url',
      data: body,
      options:
          Options(headers: {"Content-Type": "application/json; charset=utf8"}));

  return response;
}

Future<Response> get(String url, Map<String, dynamic>? body) async {
  final response = await dio.get('$baseUrl$url', queryParameters: body);

  return response;
}
