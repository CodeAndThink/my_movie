import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/screens/main/book_ticket/gift_detail_screen.dart';
import 'package:my_movie/screens/main/book_ticket/list_items/movie_available_card.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_event.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_state.dart';

class GiftStoreScreen extends StatefulWidget {
  const GiftStoreScreen({super.key});

  @override
  GiftStoreScreenState createState() => GiftStoreScreenState();
}

class GiftStoreScreenState extends State<GiftStoreScreen> {
  @override
  void initState() {
    super.initState();
    _loadGiftData();
  }

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
              return GridView.builder(
                itemBuilder: (context, index) {
                  return MovieAvailableCard(
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
                  child: Text(AppLocalizations.of(context)!.loadGiftError));
            } else {
              return const Center(
                child: Column(),
              );
            }
          }),
        ));
  }
}
