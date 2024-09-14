import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/data/models/order.dart';

class ShoppingItemCard extends StatelessWidget {
  const ShoppingItemCard({super.key, required this.onTap, required this.order});
  final VoidCallback onTap;
  final Order order;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: screenHeight * 0.15,
          width: screenWidth - 16,
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder.png',
                      image: order.gift.url.first,
                      height: screenHeight * 0.15,
                      fit: BoxFit.fitHeight,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.fitHeight,
                        );
                      },
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          order.gift.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.quantity}: ${order.quantity}',
                          style: Theme.of(context).textTheme.headlineSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.delete))
                      ],
                    ))
                  ],
                )),
          ),
        ));
  }
}
