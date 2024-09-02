import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/data/models/trivia_question.dart';
import 'package:my_movie/screens/main/minigame/ranking_screen.dart';
import 'package:my_movie/screens/main/viewmodel/quizz_bloc/quizz_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/quizz_bloc/quizz_event.dart';
import 'package:my_movie/screens/main/viewmodel/quizz_bloc/quizz_state.dart';
import 'package:html_unescape/html_unescape.dart';

class QuizzScreen extends StatefulWidget {
  const QuizzScreen({super.key});

  @override
  QuizzScreenState createState() => QuizzScreenState();
}

class QuizzScreenState extends State<QuizzScreen> {
  int score = 0;
  int heard = 3;
  List<TriviaQuestion> listQuestions = [];

  @override
  void initState() {
    super.initState();
    context.read<QuizzBloc>().add(LoadQuizz(1, 0, 0));
  }

  void loadMoreQuizz() {
    context.read<QuizzBloc>().add(LoadQuizz(1, 0, 0));
  }

  void checkAnswer(
      String answer, String correctAnswer, AnswerCardState cardState) {
    bool isCorrect = answer == correctAnswer;
    cardState.updateColor(isCorrect);

    if (heard > 0) {
      if (isCorrect) {
        score += 1;
      } else {
        heard--;
      }

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        context.read<QuizzBloc>().add(LoadQuizz(100, 0, 0));
        setState(() {});
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RankingScreen(
                      score: score,
                      listQuestions: listQuestions,
                    )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.quizz,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              child: Center(
                child: BlocBuilder<QuizzBloc, QuizzState>(
                    builder: (context, state) {
                  if (state is QuizzLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is QuizzLoaded) {
                    TriviaQuestion question = state.listQuestions.first;
                    listQuestions.add(question);
                    String quizz = convertString(question.question);
                    List<String> answers = question.incorrectAnswers;
                    String correctAnswer = question.correctAnswer;
                    answers.add(question.correctAnswer);
                    answers.shuffle();

                    return question.type == 'multiple'
                        ? Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.3,
                                  child: Card(
                                    child: Center(
                                      child: Text(
                                        quizz,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                for (int i = 0; i < answers.length; i++)
                                  AnswerCard(
                                    answer: answers[i],
                                    correctAnswer: correctAnswer,
                                    onTap: (cardState) {
                                      checkAnswer(
                                          answers[i], correctAnswer, cardState);
                                    },
                                  ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.3,
                                  child: Card(
                                    child: Center(
                                      child: Text(
                                        quizz,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                AnswerCard(
                                  answer: answers[0],
                                  correctAnswer: correctAnswer,
                                  onTap: (cardState) {
                                    checkAnswer(
                                        answers[0], correctAnswer, cardState);
                                  },
                                ),
                                const SizedBox(height: 5),
                                AnswerCard(
                                  answer: answers[1],
                                  correctAnswer: correctAnswer,
                                  onTap: (cardState) {
                                    checkAnswer(
                                        answers[1], correctAnswer, cardState);
                                  },
                                ),
                              ],
                            ),
                          );
                  } else if (state is QuizzLoadedFailure) {
                    loadMoreQuizz();
                    return const CircularProgressIndicator();
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!
                                    .noQuizzAvailable),
                                const SizedBox(
                                  height: 5,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    loadMoreQuizz();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.loadQuizz,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),
              ),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: SizedBox(
                    width: 130,
                    child: Column(
                      children: [
                        Card(
                          elevation: 2,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.score(score),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Row(
                            children: [
                              for (int i = heard; i > 0; i--)
                                const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    )))
          ],
        ));
  }

  String convertString(String input) {
    var unescape = HtmlUnescape();
    return unescape.convert(input);
  }
}

class AnswerCard extends StatefulWidget {
  const AnswerCard(
      {super.key,
      required this.answer,
      required this.correctAnswer,
      required this.onTap});
  final String answer;
  final String correctAnswer;
  final Function(AnswerCardState) onTap;

  @override
  AnswerCardState createState() => AnswerCardState();
}

class AnswerCardState extends State<AnswerCard> {
  Color stateColor = Colors.grey;

  void updateColor(bool isCorrect) {
    setState(() {
      stateColor = isCorrect ? Colors.green : Colors.red;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(this),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Card(
          color: stateColor,
          child: Center(
            child: Text(
              widget.answer,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      ),
    );
  }
}
