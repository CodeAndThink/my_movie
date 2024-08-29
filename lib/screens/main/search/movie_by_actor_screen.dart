import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/constain_values/values.dart';
import 'package:my_movie/data/models/actor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/screens/main/home/list_items/medium_card.dart';
import 'package:my_movie/screens/main/other_screens/movie_detail_screen.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';

class MovieByActorScreen extends StatefulWidget {
  const MovieByActorScreen({super.key, required this.actor});
  final Actor actor;

  @override
  MovieByActorScreenState createState() => MovieByActorScreenState();
}

class MovieByActorScreenState extends State<MovieByActorScreen> {
  void getActorWellKnownList(List<int> list) {
    final movieBloc = context.read<MovieBloc>();
    movieBloc.add(LoadMovieByListId(listMovieId: list));
  }

  @override
  void initState() {
    super.initState();
    final List<int> listMovieIds =
        widget.actor.knownFor.map((element) => element.id).toList();
    getActorWellKnownList(listMovieIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.actor.originalName,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Column(
        children: [
          Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Positioned(
                    child: Container(
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Card(
                            elevation: 2,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10),
                                  bottom: Radius.circular(10)),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/logos/logo.png',
                                image: widget.actor.profilePath != null
                                    ? Values.imageUrl +
                                        Values.imageSmall +
                                        widget.actor.profilePath!
                                    : 'assets/logos/logo.png',
                                width: 150,
                                fit: BoxFit.fitWidth,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/logos/logo.png',
                                    width: 150,
                                    fit: BoxFit.fitWidth,
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.actor.originalName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                    overflow: TextOverflow.clip,
                                  ),
                                  Text(
                                    widget.actor.name,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.clip,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .job(widget.actor.knownForDepartment),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.clip,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${AppLocalizations.of(context)!.gender}: ${widget.actor.gender == 1 ? AppLocalizations.of(context)!.female : AppLocalizations.of(context)!.male}",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.clip,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child:
                BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
              if (state is MovieLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchByListIdLoaded) {
                List<Movie> movies = state.listMovie;
                return ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return MediumCard(
                      movie: movies[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailScreen(movieId: movies[index].id),
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
            }),
          ),
        ],
      ),
    );
  }
}
