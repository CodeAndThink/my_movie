import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/screens/main/book_ticket/gift_detail_screen.dart';
import 'package:my_movie/screens/main/book_ticket/list_items/gift_card.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_event.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_state.dart';

class GiftStoreScreen extends StatefulWidget {
  const GiftStoreScreen({super.key});

  @override
  GiftStoreScreenState createState() => GiftStoreScreenState();
}

class GiftStoreScreenState extends State<GiftStoreScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadGiftData();

    //Scroll to load event
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels <=
              _scrollController.position.minScrollExtent &&
          !_scrollController.position.outOfRange)) {
        _loadGiftData();
      }
    });
  }

  //Load gift data
  void _loadGiftData() {
    context.read<GiftBloc>().add(FetchGiftData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.gift,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocBuilder<GiftBloc, GiftState>(builder: (context, state) {
            if (state is GiftLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GiftLoaded) {
              final gifts = state.listGifts;

              //List of gift product
              return GridView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return GiftCard(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GiftDetailScreen(
                                      gift: gifts[index],
                                    )));
                      },
                      gift: gifts[index]);
                },
                itemCount: gifts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
              );
            } else if (state is GiftError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.loadGiftError),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadGiftData,
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Column(),
              );
            }
          }),
        ));
  }
}
