import 'package:dio/dio.dart';

class QuizzApiService {
  final String _baseUrl = 'https://opentdb.com/api.php';

  late final Dio _dio;

  QuizzApiService() {
    _dio = Dio(BaseOptions(baseUrl: _baseUrl));
  }

  Future<Response> getTriviaQuestions(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.get(endpoint, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw Exception(
          'Failed to load trivia questions: ${e.response?.statusCode}');
    }
  }
}
