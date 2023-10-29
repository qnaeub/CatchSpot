import 'package:dio/dio.dart';

const String baseUrl = "http://3.34.125.190:8000";

BaseOptions options = new BaseOptions(
    baseUrl: baseUrl,
    receiveDataWhenStatusError: true,
    connectTimeout: Duration(seconds: 3),
    receiveTimeout: Duration(seconds: 3));
Dio dio = new Dio(options);

Future<Response> post(String url, String body) async {
  final response = await dio.post('$baseUrl$url', data: body);

  return response;
}
