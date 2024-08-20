import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_movie/constain_values/values.dart';
import 'package:my_movie/data/repository/movie_repository.dart';
import 'package:my_movie/screens/main/other_screens/cast_and_crew_screen.dart';
import 'package:my_movie/screens/main/other_screens/comment_screen.dart';
import 'package:my_movie/screens/main/other_screens/list_items/credits_card.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieBloc(MovieRepository()),
      child: MovieDetailView(
        id: movieId,
      ),
    );
  }
}

class MovieDetailView extends StatefulWidget {
  final int id;
  const MovieDetailView({super.key, required this.id});

  @override
  MovieDetailScreenState createState() => MovieDetailScreenState();
}

class MovieDetailScreenState extends State<MovieDetailView> {
  late final WebViewController _controller;
  final TextEditingController comment = TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadMovieData();
  }

  void _loadTrailer(String trailerKey) {
    _controller.loadRequest(Uri.parse(Values.youtubeUrl + trailerKey));
  }

  void _loadMovieData() {
    final movieBloc = BlocProvider.of<MovieBloc>(context);
    movieBloc.add(LoadMovieById(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.movieDetail,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchByIdLoaded) {
            final movie = state.movie;
            final trailers = state.trailers;
            final credits = state.credits;

            if (trailers.isNotEmpty) {
              String trailerKey = trailers.first['key'];
              _loadTrailer(trailerKey);
            }

            final casts = credits['cast'] ?? [];
            final crews = credits['crew'] ?? [];

            return Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    Values.imageUrl +
                        Values.imageSize +
                        (movie.posterPath ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Theme.of(context).colorScheme.surface
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 280),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 200,
                              child: Image.network(
                                Values.imageUrl +
                                    Values.imageSize +
                                    (movie.posterPath ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    (movie.releaseDate != null &&
                                            movie.releaseDate!.length >= 4
                                        ? movie.releaseDate!.substring(0, 4)
                                        : ''),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  Text(
                                    (movie.genres ?? [])
                                        .map((genre) => genre.name)
                                        .join(" | "),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RatingBar.builder(
                                              initialRating:
                                                  (movie.voteAverage / 2)
                                                      .toDouble(),
                                              minRating: 0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 20,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                            Text(
                                              movie.voteAverage
                                                  .toStringAsFixed(1),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.trailer,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Container(
                              height: 200,
                              color: Colors.black,
                              child: trailers.isNotEmpty
                                  ? WebViewWidget(controller: _controller)
                                  : Center(
                                      child: Text(AppLocalizations.of(context)!
                                          .emptyTrailer),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.castAndCrew,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 220,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: casts.length + crews.length,
                                itemBuilder: (context, index) {
                                  final isCast = index < casts.length;
                                  final credit = isCast
                                      ? casts[index]
                                      : crews[index - casts.length];

                                  return CreditsCard(
                                    profilePath: credit['profile_path'] ?? '',
                                    name: credit['name'],
                                    role: isCast
                                        ? credit['character']
                                        : credit['job'],
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CastAndCrewScreen(
                                                    credit: credit, isCast: isCast
                                                  )));
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.overview,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              movie.overview ?? '',
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.comments,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: comment,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .commentHint,
                                      suffixIcon: _textEditingController
                                              .text.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                _textEditingController.clear();
                                                setState(() {});
                                              },
                                            )
                                          : null,
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => {},
                                  icon: const Icon(Icons.send),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(AppLocalizations.of(context)!
                                    .doYouLikeThisMovie),
                                const Spacer(),
                                IconButton(
                                  onPressed: () => {},
                                  icon: const Icon(Icons.thumb_up),
                                ),
                                IconButton(
                                  onPressed: () => {},
                                  icon: const Icon(Icons.thumb_down),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.rates,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const Spacer(),
                                TextButton(
                                    onPressed: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider(
                                                create: (context) => MovieBloc(
                                                    MovieRepository()),
                                                child: CommentScreen(
                                                    movieId: widget.id),
                                              ),
                                            ),
                                          )
                                        },
                                    child: Text(
                                      AppLocalizations.of(context)!.details,
                                      style: const TextStyle(
                                          color: Colors.blueAccent),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 70)
                    ],
                  ),
                ),
                Positioned(
                    bottom: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          minimumSize: Size(cardWidth - 20, 50),
                        ),
                        child:
                            Text(AppLocalizations.of(context)!.saveToFavorites),
                      ),
                    ))
              ],
            );
          } else if (state is MovieError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
