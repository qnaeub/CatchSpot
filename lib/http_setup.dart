import 'dart:io';

import 'package:dio/dio.dart';

const String baseUrl =
    "http://ec2-43-201-30-210.ap-northeast-2.compute.amazonaws.com";

BaseOptions options = new BaseOptions(
  baseUrl: baseUrl,
  receiveDataWhenStatusError: true,
  connectTimeout: Duration(seconds: 3),
  receiveTimeout: Duration(seconds: 3),
  headers: {
    "Content-Type": "application/json",
  },
);
Dio dio = new Dio(options);

Future<Response> post(String url, Map<String, dynamic>? body) async {
  final response = await dio.post('$baseUrl$url', data: body);

  return response;
}

Future<Response> get(String url, Map<String, dynamic>? body) async {
  final response = await dio.get('$baseUrl$url', queryParameters: body);

  return response;
}

Future<Response> put(String url, Map<String, dynamic>? body) async {
  final response = await dio.put('$baseUrl$url', queryParameters: body);

  return response;
}
