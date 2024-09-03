import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_movie/constain_values/values.dart';
import 'package:my_movie/data/models/comment.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/data/models/user.dart' as my_user;
import 'package:my_movie/data/models/user_display_info.dart';
import 'package:my_movie/data/repository/movie_repository.dart';
import 'package:my_movie/screens/main/other_screens/cast_and_crew_screen.dart';
import 'package:my_movie/screens/main/other_screens/comment_screen.dart';
import 'package:my_movie/screens/main/other_screens/list_items/comment_box.dart';
import 'package:my_movie/screens/main/other_screens/list_items/credits_card.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_state.dart';
import 'package:my_movie/screens/main/viewmodel/comment_bloc/comment_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/comment_bloc/comment_event.dart';
import 'package:my_movie/screens/main/viewmodel/comment_bloc/comment_state.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_event.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_state.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MovieBloc(MovieRepository()),
        child: MovieDetailScreenView(
          id: movieId,
        ));
  }
}

class MovieDetailScreenView extends StatefulWidget {
  final int id;
  const MovieDetailScreenView({super.key, required this.id});

  @override
  MovieDetailScreenState createState() => MovieDetailScreenState();
}

class MovieDetailScreenState extends State<MovieDetailScreenView> {
  late final WebViewController _controller;
  final TextEditingController _comment = TextEditingController();
  late my_user.User userData;
  bool buttonState = false;
  late String userId;
  int favoriteLevel = 0;
  late Movie movie;
  late List trailers;
  late Map credits;
  late List<Comment> comments;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadMovieData();
    _comment.addListener(() {
      setState(() {});
    });
    _loadUserData();
  }

  void _loadUserData() {
    final authBloc = context.read<AuthBloc>();
    final userDataBloc = context.read<UserDataBloc>();
    userId = authBloc.state is AuthAuthenticated
        ? (authBloc.state as AuthAuthenticated).docId
        : '';
    if (userId.isNotEmpty) {
      userDataBloc.add(FetchUserData(userId));
      _loadUserComment(userId);
    }
  }

  void _loadUserComment(String userDocId) {
    context.read<CommentBloc>().add(FetchCommentByUserId(userDocId));
  }

  void _loadTrailer(String trailerKey) {
    _controller.loadRequest(Uri.parse(Values.youtubeUrl + trailerKey));
  }

  void _loadMovieData() {
    final movieBloc = context.read<MovieBloc>();
    movieBloc.add(LoadMovieById(widget.id));
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width;

    return BlocListener<UserDataBloc, UserDataState>(
        listener: (context, state) {
          if (state is UserDataLoaded) {
            setState(() {
              userData = state.userData;
              if (userData.favoritesList.contains(widget.id)) {
                buttonState = true;
              } else {
                buttonState = false;
              }
            });
          } else if (state is UserDataUpdated) {
            _loadUserData();
          }
        },
        child: Scaffold(
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
                movie = state.movie;
                trailers = state.trailers;
                credits = state.credits;

                if (trailers.isNotEmpty) {
                  String trailerKey = trailers.first['key'];
                  _loadTrailer(trailerKey);
                }

                final casts = credits['cast'] ?? [];
                final crews = credits['crew'] ?? [];

                return Stack(
                  children: [
                    Positioned.fill(
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.png',
                        image: movie.posterPath != null
                            ? Values.imageUrl +
                                Values.imageSmall +
                                movie.posterPath!
                            : 'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/placeholder.png',
                            fit: BoxFit.cover,
                          );
                        },
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
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 280),
                            Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 200,
                                  child: FadeInImage.assetNetwork(
                                    placeholder:
                                        'assets/images/placeholder.png',
                                    image: movie.posterPath != null
                                        ? Values.imageUrl +
                                            Values.imageSmall +
                                            movie.posterPath!
                                        : 'assets/images/placeholder.png',
                                    fit: BoxFit.cover,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/placeholder.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
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
                                                  itemPadding: const EdgeInsets
                                                      .symmetric(
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
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.trailer,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 200,
                                  color: Colors.black,
                                  child: trailers.isNotEmpty
                                      ? WebViewWidget(controller: _controller)
                                      : Center(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .emptyTrailer),
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.castAndCrew,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
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
                                        profilePath:
                                            credit['profile_path'] ?? '',
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
                                                          credit: credit,
                                                          isCast: isCast)));
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.overview,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  movie.overview ?? '',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            //Comments part area
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Comments title
                                Text(
                                  AppLocalizations.of(context)!.comments,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                        //Comments text feild
                                        child: TextField(
                                      controller: _comment,
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context)!
                                            .commentHint,
                                        suffixIcon: _comment.text.isNotEmpty
                                            ? IconButton(
                                                icon: const Icon(Icons.clear),
                                                onPressed: () {
                                                  _comment.clear();
                                                },
                                              )
                                            : null,
                                        border: const OutlineInputBorder(),
                                      ),
                                    )),
                                    IconButton(
                                      onPressed: () => {
                                        context
                                            .read<CommentBloc>()
                                            .add(CreateMymovieComment(
                                              userId,
                                              userData.avatarPath,
                                              userData.displayName,
                                              widget.id,
                                              favoriteLevel,
                                              _comment.text,
                                            )),
                                      },
                                      icon: const Icon(
                                        Icons.send,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                //Like, dislike and unsure comments
                                Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: cardWidth * 0.6,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .doYouLikeThisMovie,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () => {favoriteLevel = 1},
                                      icon: const Icon(
                                        Icons.thumb_up,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => {favoriteLevel = 2},
                                      icon: const Icon(
                                        Icons.thumb_down,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
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
                                                      CommentScreen(
                                                          movieId: movie.id),
                                                ),
                                              ).then((_) {
                                                _loadUserComment(userId);
                                              }),
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
                            BlocBuilder<CommentBloc, CommentState>(
                                builder: (context, state) {
                              if (state is CommentLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is FetchCommentByUserIdSucess) {
                                final userComment = state.listComments;
                                final List<Comment> comments = [];
                                for (Comment comment in userComment) {
                                  if (comment.movieId == movie.id) {
                                    comments.add(comment);
                                  }
                                }
                                if (comments.isNotEmpty) {
                                  final UserDisplayInfo userDisplayInfo =
                                      UserDisplayInfo(userData.displayName,
                                          userData.avatarPath);
                                  return SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        itemCount: comments.length,
                                        itemBuilder: (context, index) {
                                          return CommentBox(
                                            comment: comments[index],
                                            userDisplayInfo: userDisplayInfo,
                                          );
                                        },
                                      ));
                                } else {
                                  return Container();
                                }
                              } else if (state is CommentError) {
                                return Center(
                                  child: Column(
                                    children: [
                                      Text(AppLocalizations.of(context)!
                                          .loadCommentError)
                                    ],
                                  ),
                                );
                              } else if (state
                                  is CreateMymovieCommentsSuccess) {
                                _loadUserComment(userId);
                                return const CircularProgressIndicator();
                              } else {
                                return Container();
                              }
                            }),

                            const SizedBox(height: 70)
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            onPressed: () {
                              final List<int> userFavoriteList =
                                  userData.favoritesList;
                              final authBloc = context.read<AuthBloc>();
                              final userId = authBloc.state is AuthAuthenticated
                                  ? (authBloc.state as AuthAuthenticated).docId
                                  : '';
                              final userDataBloc = context.read<UserDataBloc>();
                              if (userId.isNotEmpty) {
                                if (userFavoriteList.contains(widget.id)) {
                                  final newFavoriteList =
                                      List<int>.from(userFavoriteList)
                                        ..remove(widget.id);
                                  userDataBloc.add(UpdateFavorite(
                                      movieId: newFavoriteList,
                                      userId: userId));
                                } else {
                                  final newFavoriteList =
                                      List<int>.from(userFavoriteList)
                                        ..add(widget.id);
                                  userDataBloc.add(UpdateFavorite(
                                      movieId: newFavoriteList,
                                      userId: userId));
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  buttonState ? Colors.red : Colors.green,
                              foregroundColor: Colors.white,
                              minimumSize: Size(cardWidth - 20, 50),
                            ),
                            child: Text(
                              buttonState
                                  ? AppLocalizations.of(context)!
                                      .removeFromFavorites
                                  : AppLocalizations.of(context)!
                                      .saveToFavorites,
                            ),
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
        ));
  }
}
