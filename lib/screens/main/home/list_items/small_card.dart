import 'package:flutter/material.dart';
import 'package:my_movie/constain_values/values.dart';
import 'package:my_movie/data/models/movie.dart';

class SmallCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const SmallCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 160,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Center(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder.png',
                      image: Values.imageUrl +
                          Values.imageSmall +
                          (movie.posterPath ?? ''),
                      width: 150,
                      height: 200,
                      fit: BoxFit.fitWidth,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                    Text(movie.releaseDate?.substring(0, 4) ?? ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
