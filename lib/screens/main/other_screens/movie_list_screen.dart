import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/data/repository/movie_repository.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';
import 'package:my_movie/screens/main/home/list_items/medium_card.dart';
import 'package:my_movie/screens/main/home/list_items/small_card.dart';
import 'package:my_movie/screens/main/other_screens/movie_detail_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(MovieRepository())
        ..add(LoadMoviesByCategories('popular', 1)),
      child: const MovieListView(),
    );
  }
}

class MovieListView extends StatefulWidget {
  const MovieListView({super.key});

  @override
  MovieListScreenState createState() => MovieListScreenState();
}

class MovieListScreenState extends State<MovieListView> {
  bool isListView = true;
  String selectedCategory = 'popular';
  int selectedPage = 1;

  @override
  void initState() {
    super.initState();
  }

  void getMovieByCategory() {
    context
        .read<MovieBloc>()
        .add(LoadMoviesByCategories(selectedCategory, selectedPage));
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
      body: Column(
        children: [
          SizedBox(
            height: 60.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                categoryChip(
                    AppLocalizations.of(context)!.popularMovies, 'popular'),
                categoryChip(AppLocalizations.of(context)!.nowPlayingMovies,
                    'now_playing'),
                categoryChip(
                    AppLocalizations.of(context)!.topRatedMovies, 'top_rated'),
                categoryChip(
                    AppLocalizations.of(context)!.upcomingMovies, 'upcoming'),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MovieLoaded) {
                  List<Movie> movies;
                  switch (selectedCategory) {
                    case 'popular':
                      movies = state.popularMovies;
                      break;
                    case 'top_rated':
                      movies = state.topRatedMovies;
                      break;
                    case 'now_playing':
                      movies = state.nowPlayingMovies;
                      break;
                    case 'upcoming':
                      movies = state.upcomingMovies;
                      break;
                    default:
                      movies = [];
                  }
                  return movies.isEmpty
                      ? Center(
                          child: Text(
                              AppLocalizations.of(context)!.noMoviesAvailable))
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
                                maxCrossAxisExtent: 258,
                                childAspectRatio: 150 / 230,
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
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryChip(String label, String categoryKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: selectedCategory == categoryKey,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              selectedCategory = categoryKey;
            });
            getMovieByCategory();
          }
        },
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
