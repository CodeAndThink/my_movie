import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/movie_genre.dart';
import 'package:my_movie/screens/main/search/list_items/category_items.dart';
import 'package:my_movie/screens/main/search/movie_by_genre_screen.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_genre_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_genre_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/main_fetch_movie_genre_state.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  CategoryListScreenState createState() => CategoryListScreenState();
}

class CategoryListScreenState extends State<CategoryListScreen> {
  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    context.read<MainFetchMovieGenreBloc>().add(FetchMovieGenres());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.categories,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        body: Center(
          child: BlocBuilder<MainFetchMovieGenreBloc, MainFetchMovieGenreState>(
            builder: (context, state) {
              if (state is FetchMovieGenresLoading) {
                return const CircularProgressIndicator();
              } else if (state is FetchMovieGenresLoaded) {
                List<MovieGenre> genres = state.genres;
                return ListView.builder(
                  itemCount: genres.length,
                  itemBuilder: (context, index) {
                    final category = genres[index];
                    return CategoryItems(
                      title: category.name,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieByGenreScreen(
                              genreId: category.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (state is FetchMovieGenresError) {
                return Text(state.message);
              } else {
                return Text(AppLocalizations.of(context)!.noGenreFound);
              }
            },
          ),
        ));
  }
}
