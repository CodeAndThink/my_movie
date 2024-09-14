import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/screens/main/book_ticket/list_items/shopping_item_card.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_state.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_action_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_action_event.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_action_state.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ShoppingListScreenState createState() => ShoppingListScreenState();
}

class ShoppingListScreenState extends State<ShoppingListScreen> {
  late String userId;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() {
    final authBloc = context.read<AuthBloc>();
    userId = authBloc.state is AuthAuthenticated
        ? (authBloc.state as AuthAuthenticated).docId
        : '';
    if (userId.isNotEmpty) {
      _getOrderData(userId);
    }
  }

  void _getOrderData(String userDocId) {
    context.read<GiftActionBloc>().add(FetchGiftOrder(userDocId));
  }

  Widget _shoppingListScreenAppBar() {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.shoppingCart,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Spacer(),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.trending_up,
              color: Theme.of(context).colorScheme.primary,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _shoppingListScreenAppBar(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: BlocBuilder<GiftActionBloc, GiftActionState>(
                builder: (context, state) {
              if (state is GiftActionLoading) {
                return const CircularProgressIndicator();
              } else if (state is OrderLoadedSuccess) {
                final orders = state.listOrders;
                return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return ShoppingItemCard(
                          onTap: () {}, order: orders[index]);
                    });
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/logos/logo.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.searchingMovie),
                  ],
                );
              }
            }),
          ),
        ));
  }
}
