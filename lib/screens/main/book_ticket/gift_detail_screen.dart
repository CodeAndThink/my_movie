import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/data/models/gift_item.dart';
import 'package:my_movie/screens/main/book_ticket/reconfirm_screen.dart';
import 'package:my_movie/screens/main/book_ticket/shopping_list_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GiftDetailScreen extends StatefulWidget {
  const GiftDetailScreen({super.key, required this.gift});
  final GiftItem gift;

  @override
  GiftDetailScreenState createState() => GiftDetailScreenState();
}

class GiftDetailScreenState extends State<GiftDetailScreen> {
  final PageController _controller = PageController();
  final TextEditingController _countController =
      TextEditingController(text: '0');
  final int maxCount = 100;
  final int minCount = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget _giftDetailAppBar() {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.giftDetail,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Spacer(),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ShoppingListScreen()));
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.primary,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
        appBar: AppBar(title: _giftDetailAppBar()),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: screenSize.height * 0.4,
                    //Product image list
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: widget.gift.gift.url.length,
                      itemBuilder: (context, index) {
                        return FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image: widget.gift.gift.url[index],
                          width: screenWidth * 0.7,
                          fit: BoxFit.fitWidth,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/placeholder.png',
                              width: screenWidth * 0.7,
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
                        count: widget.gift.gift.url.length,
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
                widget.gift.gift.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.gift.gift.price} \$',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  //Change quantity for purchase part
                  SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Add button
                        IconButton(
                          onPressed: () {
                            int currentValue =
                                int.tryParse(_countController.text) ?? 0;
                            if (currentValue < maxCount) {
                              currentValue += 1;
                              _countController.text = currentValue.toString();
                              _countController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: _countController.text.length),
                              );
                            }
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),

                        // Number of product
                        SizedBox(
                          height: 30,
                          width: 55,
                          child: TextField(
                            textAlign: TextAlign.end,
                            controller: _countController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(2),
                              isDense: true,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                int enteredValue = int.tryParse(value) ?? 0;
                                if (enteredValue > maxCount) {
                                  _countController.text = maxCount.toString();
                                } else if (enteredValue < minCount) {
                                  _countController.text = minCount.toString();
                                }
                                _countController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: _countController.text.length),
                                );
                              }
                            },
                          ),
                        ),

                        // Minus button
                        IconButton(
                          onPressed: () {
                            int currentValue =
                                int.tryParse(_countController.text) ?? 0;
                            if (currentValue > minCount) {
                              currentValue -= 1;
                              _countController.text = currentValue.toString();
                              _countController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: _countController.text.length),
                              );
                            }
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                      ],
                    ),
                  ),

                  //Purchase button
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      final count = int.tryParse(_countController.text) ?? 0;

                      if (count > 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReconfirmScreen(
                              giftItem: widget.gift,
                              quantity: count,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!
                                  .pleaseEnterAnotherQuantity,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.surface,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.purchase,
                    ),
                  ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.detailInformation,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${AppLocalizations.of(context)!.source}: ${widget.gift.gift.source}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${AppLocalizations.of(context)!.material}: ${widget.gift.gift.material}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              Text(
                '${AppLocalizations.of(context)!.mfgDate}: ${widget.gift.gift.mfgDate.toString().substring(0, 10).split('-').reversed.toList().join('-')}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ));
  }
}
