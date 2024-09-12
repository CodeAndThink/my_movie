import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/data/models/gift.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GiftDetailScreen extends StatefulWidget {
  const GiftDetailScreen({super.key, required this.gift});
  final Gift gift;

  @override
  GiftDetailScreenState createState() => GiftDetailScreenState();
}

class GiftDetailScreenState extends State<GiftDetailScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.giftDetail,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: screenSize.height * 0.4,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: widget.gift.url.length,
                      itemBuilder: (context, index) {
                        return FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image: widget.gift.url[index],
                          width: screenWidth * 0.9,
                          fit: BoxFit.fitWidth,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/placeholder.png',
                              width: screenWidth * 0.9,
                              fit: BoxFit.fitWidth,
                            );
                          },
                        );
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _controller,
                        count: widget.gift.url.length,
                        effect: WormEffect(
                          dotColor: Theme.of(context).colorScheme.secondary,
                          activeDotColor: Theme.of(context).colorScheme.primary,
                          dotHeight: 8,
                          dotWidth: 10,
                          spacing: 5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.gift.name,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                '${AppLocalizations.of(context)!.price}: ${widget.gift.price}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              Text(
                '${AppLocalizations.of(context)!.source}: ${widget.gift.source}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              Text(
                '${AppLocalizations.of(context)!.quantity}: ${widget.gift.quantity}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(screenWidth - 16, 50),
                ),
                child: Text(
                  AppLocalizations.of(context)!.purchase,
                ),
              )
            ],
          ),
        ));
  }
}
