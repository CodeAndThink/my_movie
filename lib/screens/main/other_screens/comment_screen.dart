import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/screens/main/other_screens/list_items/comment_box.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_state.dart';

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
    final movieBloc = BlocProvider.of<MovieBloc>(context);
    movieBloc.add(LoadMovieReviews(widget.movieId, 1));
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
                Expanded(
                  child: ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      final authorDetails = review.authorDetails;

                      return CommentBox(
                        authorDetails: authorDetails,
                        review: review,
                      );
                    },
                  ),
                ),
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
