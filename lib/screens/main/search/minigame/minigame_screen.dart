import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/animation/dice_roll_animation.dart';
import 'package:my_movie/screens/main/search/minigame/list_items/mini_games_card.dart';
import 'package:my_movie/screens/main/search/minigame/quizz_screen.dart';
import 'package:my_movie/screens/main/other_screens/movie_detail_screen.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MinigameScreen extends StatefulWidget {
  const MinigameScreen({super.key});

  @override
  MinigameScreenState createState() => MinigameScreenState();
}

class MinigameScreenState extends State<MinigameScreen> {
  @override
  Widget build(BuildContext context) {
    final movieBloc = context.read<MovieBloc>();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.miniGame,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: [
                MiniGamesCard(
                  title: AppLocalizations.of(context)!.pickRandomMovie,
                  imageUrl: 'assets/images/dice.png',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoadingRandomScreen()));
                    var rng = Random();
                    movieBloc.add(LoadMovieById(2 + rng.nextInt(299)));
                  },
                ),
                MiniGamesCard(
                  title: AppLocalizations.of(context)!.quizz,
                  imageUrl: 'assets/images/quizz.png',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuizzScreen()));
                  },
                ),
              ],
            )));
  }
}

class LoadingRandomScreen extends StatelessWidget {
  const LoadingRandomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MovieBloc, MovieState>(
        listener: (context, state) {
          if (state is SearchByIdLoaded) {
            final resuilt = state.movie;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DiceRollScreen(
                  nextScreen: MovieDetailScreen(movieId: resuilt.id),
                ),
              ),
            );
          }
        },
        child: const Center(child: CircularProgressIndicator()));
  }
}
