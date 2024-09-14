import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_movie/data/models/gift.dart';
import 'package:my_movie/data/models/gift_item.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_state.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_action_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_action_event.dart';
import 'package:my_movie/screens/main/viewmodel/location_bloc/location_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/location_bloc/location_event.dart';
import 'package:my_movie/screens/main/viewmodel/location_bloc/location_state.dart';

class ReconfirmScreen extends StatefulWidget {
  const ReconfirmScreen(
      {super.key, required this.giftItem, required this.quantity});
  final GiftItem giftItem;
  final int quantity;

  @override
  ReconfirmScreenState createState() => ReconfirmScreenState();
}

class ReconfirmScreenState extends State<ReconfirmScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _getLocation() {
    context.read<LocationBloc>().add(RequestPermissionEvent());
  }

  void _createOrder(String productDocId, int quantity, Gift gift) {
    final authBloc = context.read<AuthBloc>();
    var userId = authBloc.state is AuthAuthenticated
        ? (authBloc.state as AuthAuthenticated).docId
        : '';
    if (userId.isNotEmpty && quantity > 0) {
      context
          .read<GiftActionBloc>()
          .add(CreateGiftOrder(userId, productDocId, quantity, gift));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.reconfirmOrder,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              width: screenWidth,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.mapLocation,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            AppLocalizations.of(context)!.shippingAddress,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                _getLocation();
                              },
                              icon: Icon(
                                FontAwesomeIcons.locationArrow,
                                color: Theme.of(context).colorScheme.primary,
                              ))
                        ],
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocConsumer<LocationBloc, LocationState>(
                        listener: (context, state) {
                          if (state is GetLocationError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Lỗi: ${state.message}')),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is GetLocationLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is GetLocationLoaded) {
                            return Text(
                                'Position: ${state.position.accuracy.toString()}, ${state.position.altitude.toString()}');
                          } else if (state is GetLocationError) {
                            return Container();
                          } else {
                            return const Text('No position available!');
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: screenWidth,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.box,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            AppLocalizations.of(context)!.product,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          //Product image
                          SizedBox(
                            height: 50,
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/placeholder.png',
                              image: widget.giftItem.gift.url.first,
                              width: 50,
                              height: 50,
                              fit: BoxFit.fitWidth,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/placeholder.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.fitWidth,
                                );
                              },
                            ),
                          ),
                          Text(
                            widget.giftItem.gift.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Spacer(),
                          Text('x${widget.quantity}')
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                _createOrder(widget.giftItem.productDocId, widget.quantity,
                    widget.giftItem.gift);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.surface,
                minimumSize: Size(screenWidth - 20, 50),
              ),
              child: Text(
                AppLocalizations.of(context)!.purchase,
                style: TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
