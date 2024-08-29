import 'package:dio/dio.dart';
import 'package:my_movie/data/connections/network/quizz_api_service.dart';

class QuizzRepository {
  final QuizzApiService _quizzApiService = QuizzApiService();

  Future<Response> getQuizz(int num, int questDifficulty, int questType) async {
    String difficulty;
    String type;
    switch (questDifficulty) {
      case 0:
        difficulty = 'easy';
        break;
      case 1:
        difficulty = 'medium';
        break;
      case 2:
        difficulty = 'hard';
        break;
      default:
        difficulty = 'easy';
    }
    switch (questType) {
      case 0:
        type = '';

        break;
      case 1:
        type = 'boolean';
        break;
      case 2:
        type = 'multiple';
        break;
      default:
        type = '';
    }
    return _quizzApiService.getTriviaQuestions('', queryParameters: {
      'amount': num,
      'category': 11,
      'difficulty': difficulty,
      'type': type
    });
  }
}
