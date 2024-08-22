import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_movie/constain_values/values.dart';
import 'package:my_movie/data/models/movie.dart';

class LargeCard extends StatelessWidget {
  final Movie movie;
  final double width;
  final double height;
  final VoidCallback onTap;

  const LargeCard({
    super.key,
    required this.movie,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Center(
                    child: Stack(
                  children: [
                    FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder.png',
                      image: Values.imageUrl +
                          Values.imageSmall +
                          (movie.posterPath ?? ''),
                      width: cardWidth,
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned(
                        bottom: 20,
                        width: cardWidth,
                        child: Container(
                            color: Theme.of(context).colorScheme.surface,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.fade,
                                  ),
                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        initialRating:
                                            (movie.voteAverage / 2).toDouble(),
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 20,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      Text(
                                        movie.voteAverage.toStringAsFixed(1),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )))
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
