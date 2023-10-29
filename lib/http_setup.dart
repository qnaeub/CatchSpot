import 'package:dio/dio.dart';

const String baseUrl = "http://10.0.2.2:8080";

final dio = Dio();

Future<Response> post(String url, String body) async {
  final response = await dio.post('$baseUrl$url', data: body);

  return response;
}
