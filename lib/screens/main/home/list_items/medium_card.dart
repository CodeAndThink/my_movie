import 'package:flutter/material.dart';
import 'package:my_movie/constain_values/values.dart';
import 'package:my_movie/data/models/movie.dart';

class MediumCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MediumCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width *
        0.8;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth,
        height: 200,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(10),
                child: Image.network(
                  Values.imageUrl + Values.imageSmall + (movie.posterPath ?? ''),
                  width: 150,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title.toUpperCase(),
                          style: Theme.of(context).textTheme.headlineSmall,
                          overflow: TextOverflow.clip,
                          maxLines: 3,
                        ),
                        Text(movie.releaseDate?.substring(0, 4) ?? ''),
                        Text(
                          movie.overview.toString(),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
