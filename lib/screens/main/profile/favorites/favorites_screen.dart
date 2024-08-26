import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_state.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_event.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() {
    final authBloc = context.read<AuthBloc>();
    final userDataBloc = context.read<UserDataBloc>();
    final userId = authBloc.state is AuthAuthenticated
        ? (authBloc.state as AuthAuthenticated).docId
        : '';
    if (userId.isNotEmpty) {
      userDataBloc.add(FetchUserData(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.favoritesList,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Center(
          child: Column(
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
      )),
    );
  }
}
