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
  int page = 1;
  int sortOption = 0;

  @override
  void initState() {
    super.initState();
    context
        .read<MovieBloc>()
        .add(LoadMovieByGenre(widget.genreId, 1, sortOption));
  }

  void getMovieListByPage(int page) {
    context
        .read<MovieBloc>()
        .add(LoadMovieByGenre(widget.genreId, page, sortOption));
  }

  void sortMovie(int sortOption) {
    setState(() {
      this.sortOption = sortOption;
    });
    context
        .read<MovieBloc>()
        .add(LoadMovieByGenre(widget.genreId, page, sortOption));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MovieListAppBar(
          isListView: isListView,
          onToggleChangeLayoutView: () {
            setState(() {
              isListView = !isListView;
            });
          },
          onToggleSortView: (int newSortOption) {
            sortMovie(newSortOption);
          },
        ),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
        if (state is MovieLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchByMovieGenre) {
          final List<Movie> movies = state.movies;

          return Column(
            children: [
              Expanded(
                child: movies.isEmpty
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
                          ),
              ),
              SizedBox(
                child: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          if (page > 1) {
                            page = page - 1;
                            getMovieListByPage(page);
                          }
                        },
                        icon: const Icon(Icons.arrow_back)),
                    Text(page.toString()),
                    IconButton(
                        onPressed: () {
                          page = page + 1;
                          getMovieListByPage(page);
                        },
                        icon: const Icon(Icons.arrow_forward)),
                    const Spacer(),
                  ],
                ),
              )
            ],
          );
        } else if (state is MovieError) {
          return Center(child: Text(state.message));
        } else {
          return Center(
              child: Text(AppLocalizations.of(context)!.noMoviesAvailable));
        }
      }),
    );
  }
}

class MovieListAppBar extends StatefulWidget {
  const MovieListAppBar(
      {super.key,
      required this.isListView,
      required this.onToggleChangeLayoutView,
      required this.onToggleSortView});

  final bool isListView;
  final VoidCallback onToggleChangeLayoutView;
  final Function(int) onToggleSortView;

  @override
  MovieListAppBarState createState() => MovieListAppBarState();
}

class MovieListAppBarState extends State<MovieListAppBar> {
  late IconData selectedIcon;
  late int selectedSortOption;

  @override
  void initState() {
    super.initState();
    selectedIcon = Icons.trending_up;
    selectedSortOption = 0;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sortOptions = [
      {
        'icon': Icons.trending_up,
        'label': AppLocalizations.of(context)!.sortByPopularity,
        'sort': 0
      },
      {
        'icon': Icons.date_range,
        'label': AppLocalizations.of(context)!.sortByReleasedDate,
        'sort': 1
      },
      {
        'icon': Icons.star,
        'label': AppLocalizations.of(context)!.sortByRatingScore,
        'sort': 2
      }
    ];

    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.listOfMovies,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        const Spacer(),
        PopupMenuButton<int>(
          icon:
              Icon(selectedIcon, color: Theme.of(context).colorScheme.primary),
          onSelected: (int newSortOption) {
            final selectedOption = sortOptions
                .firstWhere((option) => option['sort'] == newSortOption);
            setState(() {
              selectedSortOption = newSortOption;
              selectedIcon = selectedOption['icon'];
            });
            widget.onToggleSortView(newSortOption);
          },
          itemBuilder: (BuildContext context) {
            return sortOptions.map((option) {
              return PopupMenuItem<int>(
                value: option['sort'],
                child: Row(
                  children: [
                    Icon(option['icon'],
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(option['label']),
                  ],
                ),
              );
            }).toList();
          },
        ),
        IconButton(
          onPressed: widget.onToggleChangeLayoutView,
          icon: Icon(
            widget.isListView ? Icons.grid_view : Icons.list,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
