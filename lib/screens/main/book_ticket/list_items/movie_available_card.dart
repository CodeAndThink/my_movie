import 'package:flutter/material.dart';
import 'package:my_movie/data/models/gift.dart';

class MovieAvailableCard extends StatelessWidget {
  const MovieAvailableCard(
      {super.key, required this.onTap, required this.gift});
  final VoidCallback onTap;
  final Gift gift;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return GestureDetector(
        onTap: onTap,
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              height: screenHeight * 0.25,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder.png',
                      image: gift.url.first,
                      width: 150,
                      height: 200,
                      fit: BoxFit.fitWidth,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/placeholder.png',
                          width: 150,
                          height: 200,
                          fit: BoxFit.fitWidth,
                        );
                      },
                    ),
                    Text(
                      gift.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            )));
  }
}
