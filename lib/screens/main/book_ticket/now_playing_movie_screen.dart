import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_by_categories_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_by_categories_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NowPlayingMovieScreen extends StatelessWidget {
  const NowPlayingMovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.nowPlayingMovies,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: BlocBuilder<MainFetchMovieByCategoriesBloc,
          MainFetchMovieByCategoriesState>(builder: (context, state) {
        if (state is MovieCategoriesLoading) {
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
          // } else if (state is MovieCategoriesLoaded) {
          //   return ;
          // } else if (state is MovieCategoriesFalure) {
          //   return ;
        } else {
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }
      }),
    );
  }
}
