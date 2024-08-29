import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/data/models/trivia_question.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<QuizzBloc>().add(LoadQuizz(1, 0, 0));
  }

  void checkAnswer(
      String answer, String correctAnswer, AnswerCardState cardState) {
    bool isCorrect = answer == correctAnswer;
    cardState.updateColor(isCorrect);

    Future.delayed(const Duration(seconds: 3), () {
      context.read<QuizzBloc>().add(LoadQuizz(1, 0, 0));
      answer == correctAnswer ? score += 1 : score += 0;
      setState(() {});
    });
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
                    return Text(AppLocalizations.of(context)!.noQuizzAvailable);
                  } else {
                    return Text(AppLocalizations.of(context)!.noQuizzAvailable);
                  }
                }),
              ),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: SizedBox(
                  height: 50,
                  width: 130,
                  child: Card(
                    elevation: 2,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.score(score),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                ))
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
  Color stateColor = Colors.white;

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
