import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/user_display_info.dart';
import 'package:my_movie/screens/main/other_screens/list_items/comment_box.dart';
import 'package:my_movie/screens/main/other_screens/list_items/review_box.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_event.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_state.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.movieId});
  final int movieId;

  @override
  CommentScreenState createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {
  late List<String> rate;
  late String selectedRate;

  @override
  void initState() {
    super.initState();
    _loadMovieData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    rate = [
      AppLocalizations.of(context)!.tmdbComments,
      AppLocalizations.of(context)!.ourCommunity
    ];
    selectedRate = rate[0];
    _loadMovieData();
  }

  void _loadMovieData() {
    context.read<MovieBloc>().add(LoadMovieReviews(widget.movieId, 1));
  }

  void _loadUserById(List<String> listIds) {
    context.read<UserDataBloc>().add(FetchUserDisplayInfo(listIds));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.movieDetail,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieReviewsLoaded) {
            final reviews = state.reviews;
            final comments = state.comments;
            final List<String> listUserIds =
                comments.map((comment) => comment.userId).toList();

            _loadUserById(listUserIds);
            return Column(
              children: [
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: rate.map((r) => rateChip(r)).toList(),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                selectedRate == AppLocalizations.of(context)!.tmdbComments
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            final authorDetails = review.authorDetails;

                            return ReviewBox(
                              authorDetails: authorDetails,
                              review: review,
                            );
                          },
                        ),
                      )
                    : BlocBuilder<UserDataBloc, UserDataState>(
                        builder: (context, state) {
                        if (state is UserDataLoading) {
                          return const Expanded(
                              child: Center(
                            child: CircularProgressIndicator(),
                          ));
                        } else if (state is UserCommentDatasLoaded) {
                          List<UserDisplayInfo> listUserInfors =
                              state.userCommentDatas;
                          return Expanded(
                            child: ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                return CommentBox(
                                  comment: comments[index],
                                  userDisplayInfo: listUserInfors[index],
                                );
                              },
                            ),
                          );
                        } else if (state is UserDataFailure) {
                          return const Expanded(
                              child: Center(
                            child: CircularProgressIndicator(),
                          ));
                        } else {
                          return const Expanded(
                              child: Center(
                            child: CircularProgressIndicator(),
                          ));
                        }
                      })
              ],
            );
          } else if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget rateChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChoiceChip(
        label: Row(
          children: [
            Text(label),
            const SizedBox(
              width: 5.0,
            ),
            const Icon(
              Icons.star,
              size: 14.0,
            )
          ],
        ),
        selected: selectedRate == label,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              selectedRate = label;
            });
          }
        },
      ),
    );
  }
}
