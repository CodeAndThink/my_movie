import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/screens/main/home/list_items/medium_card.dart';
import 'package:my_movie/screens/main/home/list_items/small_card.dart';
import 'package:my_movie/screens/main/other_screens/movie_detail_screen.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieByGenreScreen extends StatefulWidget {
  const MovieByGenreScreen({super.key, required this.genreId});
  final int genreId;

  @override
  MovieByGenreScreenState createState() => MovieByGenreScreenState();
}

class MovieByGenreScreenState extends State<MovieByGenreScreen> {
  bool isListView = true;
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(LoadMovieByGenre(widget.genreId, 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MovieListAppBar(
          isListView: isListView,
          onToggleView: () {
            setState(() {
              isListView = !isListView;
            });
          },
        ),
      ),
      body: Center(
        child: BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
          if (state is MovieLoading) {
            return const CircularProgressIndicator();
          } else if (state is SearchByMovieGenre) {
            final List<Movie> movies = state.movies;

            return movies.isEmpty
                ? Center(
                    child:
                        Text(AppLocalizations.of(context)!.noMoviesAvailable))
                : isListView
                    ? ListView.builder(
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return MediumCard(
                            movie: movies[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(
                                      movieId: movies[index].id),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 230.0,
                          childAspectRatio: 150 / 200,
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return SmallCard(
                            movie: movies[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(
                                      movieId: movies[index].id),
                                ),
                              );
                            },
                          );
                        },
                      );
          } else if (state is MovieError) {
            return Text(state.message);
          } else {
            return const Text('data');
          }
        }),
      ),
    );
  }
}

class MovieListAppBar extends StatelessWidget {
  final bool isListView;
  final VoidCallback onToggleView;

  const MovieListAppBar({
    super.key,
    required this.isListView,
    required this.onToggleView,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.listOfMovies,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        const Spacer(),
        IconButton(
          onPressed: onToggleView,
          icon: Icon(
            isListView ? Icons.grid_view : Icons.list,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
