import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/data/models/user.dart';
import 'package:my_movie/screens/main/home/list_items/small_card.dart';
import 'package:my_movie/screens/main/other_screens/movie_detail_screen.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_state.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_event.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_state.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() {
    final authBloc = context.read<AuthBloc>();
    final userDataBloc = context.read<UserDataBloc>();
    final userId = authBloc.state is AuthAuthenticated
        ? (authBloc.state as AuthAuthenticated).docId
        : '';
    if (userId.isNotEmpty) {
      userDataBloc.add(FetchUserData(userId));
    }
  }

  void getFavoritesList(List<int> list) {
    final movieBloc = context.read<MovieBloc>();
    movieBloc.add(LoadMovieByListId(listMovieId: list));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.favoritesList,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body:
            BlocBuilder<UserDataBloc, UserDataState>(builder: (context, state) {
          if (state is UserDataLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserDataLoaded) {
            User userData = state.userData;
            List<int> favoritesList = userData.favoritesList;
            getFavoritesList(favoritesList);

            return BlocBuilder<MovieBloc, MovieState>(
                builder: (context, movieState) {
              if (movieState is MovieLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (movieState is SearchByListIdLoaded) {
                final movies = movieState.listMovie;

                return movies.isEmpty
                    ? Center(
                        child: Text(
                            AppLocalizations.of(context)!.noMoviesAvailable))
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
              } else {
                return const Center(child: Text('No movies found.'));
              }
            });
          } else {
            return const Center(child: Text('Failed to load user data.'));
          }
        }));
  }
}
