import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_by_categories_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_by_categories_state.dart';
import 'package:my_movie/screens/main/home/list_items/medium_card.dart';
import 'package:my_movie/screens/main/home/list_items/small_card.dart';
import 'package:my_movie/screens/main/other_screens/movie_detail_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  MovieListScreenState createState() => MovieListScreenState();
}

class MovieListScreenState extends State<MovieListScreen> {
  bool isListView = true;
  String selectedCategory = 'popular';
  int selectedPage = 1;

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
            child: BlocBuilder<MainFetchMovieByCategoriesBloc,
                MainFetchMovieByCategoriesState>(
              builder: (context, state) {
                if (state is MovieCategoriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MovieCategoriesLoaded) {
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
                } else if (state is MovieCategoriesFalure) {
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
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: screenWidth * 0.55),
          child: Text(
            AppLocalizations.of(context)!.listOfMovies,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
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
