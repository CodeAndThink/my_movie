import 'package:dio/dio.dart';
import 'package:my_movie/constain_values/values.dart';

class ApiService {
  final String _baseUrl = 'https://api.themoviedb.org/3/';

  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(baseUrl: _baseUrl));
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(endpoint,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              'Authorization': 'Bearer ${Values.authHeader}',
            },
          ));
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to load data: ${e.response?.statusCode}');
    }
  }

  Future<Response> post(String endpoint,
      {Map<String, dynamic>? queryParameters,
      dynamic data,
      Options? options}) async {
    try {
      final response = await _dio.post(endpoint,
          queryParameters: queryParameters,
          data: data,
          options: options ??
              Options(
                headers: {
                  'Authorization': 'Bearer ${Values.authHeader}',
                  'Content-Type': 'application/json;charset=utf-8',
                  'accept': 'application/json',
                },
              ));
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to post data: ${e.response?.statusCode}');
    }
  }

  Future<Response> delete(String endpoint,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.delete(endpoint,
          queryParameters: queryParameters,
          options: options ??
              Options(
                headers: {
                  'Authorization': 'Bearer ${Values.authHeader}',
                  'Content-Type': 'application/json;charset=utf-8',
                  'accept': 'application/json',
                },
              ));
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to delete data: ${e.response?.statusCode}');
    }
  }
}
