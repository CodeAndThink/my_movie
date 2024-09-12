import 'package:flutter/material.dart';
import 'package:my_movie/data/models/movie.dart';
import 'package:my_movie/screens/main/home/list_items/small_card.dart';
import 'package:my_movie/screens/main/other_screens/movie_list_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoviesSection extends StatelessWidget {
  final List<Movie> movies;
  final String title;
  final void Function(Movie) onCardTap;

  const MoviesSection({
    super.key,
    required this.title,
    required this.movies,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenWidth * 0.6,
                ),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const Spacer(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenWidth * 0.25,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MovieListScreen(),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.seeMore,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 290,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: SmallCard(
                  movie: movie,
                  onTap: () => onCardTap(movie),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
