import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/data/models/actor.dart';
import 'package:my_movie/screens/main/search/list_items/actor_card.dart';
import 'package:my_movie/screens/main/search/movie_by_actor_screen.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';

class SearchByActor extends StatefulWidget {
  const SearchByActor({super.key});

  @override
  SearchByActorState createState() => SearchByActorState();
}

class SearchByActorState extends State<SearchByActor> {
  void _onCancel() {
    context.read<MovieBloc>().add(LoadPopularActor(page: 1));
  }

  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(LoadPopularActor(page: 1));
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
            } else if (state is ActorLoaded) {
              final List<Actor> listActors = state.actors;
              if (listActors.isEmpty) {
                return Center(
                    child: Text(AppLocalizations.of(context)!.noMoviesFound));
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1,
                ),
                itemCount: listActors.length,
                itemBuilder: (context, index) {
                  return ActorCard(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MovieByActorScreen(
                                  actor: listActors[index]))).then((_) {
                        _onCancel();
                      });
                    },
                    imageUrl: listActors[index].profilePath ?? '',
                    title: listActors[index].originalName,
                  );
                },
              );
            } else if (state is MovieError) {
              return Center(
                  child:
                      Text(AppLocalizations.of(context)!.error(state.message)));
            } else {
              return Center(
                child: Text(AppLocalizations.of(context)!.noActorFound),
              );
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
            context.read<MovieBloc>().add(SearchActor(name: value, page: 1));
          }
        });
      },
    );
  }
}
