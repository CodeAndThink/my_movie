import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/screens/main/minigame/list_items/mini_games_card.dart';
import 'package:my_movie/screens/main/other_screens/movie_detail_screen.dart';
import 'package:my_movie/screens/main/search/category_list_screen.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  void _onCancel() {
    context.read<MovieBloc>().add(SearchMovies(''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const SearchBox(),
          actions: [
            TextButton(
                onPressed: _onCancel,
                child: Text(AppLocalizations.of(context)!.cancel))
          ],
        ),
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchLoaded) {
              final movies = state.movies;
              final List<Movie> listMovie =
                  movies.map((json) => Movie.fromJson(json)).toList();

              if (listMovie.isEmpty) {
                return Center(
                    child: Text(AppLocalizations.of(context)!.noMoviesFound));
              }

              return ListView.builder(
                itemCount: listMovie.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(listMovie[index].title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(
                                movieId: listMovie[index].id)),
                      );
                    },
                  );
                },
              );
            } else if (state is MovieError) {
              return Center(
                  child:
                      Text(AppLocalizations.of(context)!.error(state.message)));
            } else {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: [
                      MiniGamesCard(
                        title: AppLocalizations.of(context)!.searchByCategory,
                        imageUrl: 'assets/images/category.png',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CategoryListScreen()),
                          );
                        },
                      ),
                    ],
                  ));
            }
          },
        ));
  }
}

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  SearchBoxState createState() => SearchBoxState();
}

class SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _debounce?.cancel();
    _searchController.dispose();
  }

  void clearSearch() {
    _searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.searchHint,
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  clearSearch();
                },
              )
            : null,
        border: InputBorder.none,
      ),
      onChanged: (value) {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 200), () {
          if (value.isNotEmpty) {
            context.read<MovieBloc>().add(SearchMovies(value));
          }
        });
      },
    );
  }
}
