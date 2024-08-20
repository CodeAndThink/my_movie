import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  FavoritesScreenState createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
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
