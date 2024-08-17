import 'package:dio/dio.dart';
import 'package:my_movie/constain_values/values.dart';

class ApiService {
  final String _baseUrl = 'https://api.themoviedb.org/3/';

  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(baseUrl: _baseUrl));
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParameters, options: Options(
        headers: {
          'Authorization': 'Bearer ${Values.authHeader}',
        },
      ));
      return response;
    } on DioException catch (e) {
      throw Exception('Failed to load data: ${e.response?.statusCode}');
    }
  }
}