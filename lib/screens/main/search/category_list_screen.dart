import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_movie/data/models/movie_genre.dart';
import 'package:my_movie/screens/main/search/list_items/category_items.dart';
import 'package:my_movie/screens/main/search/movie_by_genre_screen.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  CategoryListScreenState createState() => CategoryListScreenState();
}

class CategoryListScreenState extends State<CategoryListScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  List<MovieGenre> _genres = [];

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  Future<void> _loadGenres() async {
    final genresString = await _secureStorage.read(key: 'movie_genres');
    if (genresString != null) {
      final List<dynamic> genresJson = jsonDecode(genresString);
      setState(() {
        _genres = genresJson.map((json) => MovieGenre.fromJson(json)).toList();
      });
    } else {
      context.read<MovieBloc>().add(LoadMovieGenres());
    }
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
            child: ListView.builder(
          itemCount: _genres.length,
          itemBuilder: (context, index) {
            final category = _genres[index];
            return CategoryItems(
                title: category.name,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MovieByGenreScreen(
                                genreId: _genres[index].id,
                              )));
                });
          },
        )));
  }
}
