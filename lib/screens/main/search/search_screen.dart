import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/data/repository/movie_repository.dart';
import 'package:my_movie/screens/main/other_screens/movie_detail_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(MovieRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: const SearchBox(),
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
              return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logos/logo.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.searchingMovie),
                ],
              ));
            }
          },
        ),
      ),
    );
  }
}

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  SearchBoxState createState() => SearchBoxState();
}

class SearchBoxState extends State<SearchBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.searchHint,
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  setState(() {});
                },
              )
            : null,
        border: InputBorder.none,
      ),
      onChanged: (value) {
        setState(() {});
        context.read<MovieBloc>().add(SearchMovies(value));
      },
    );
  }
}
