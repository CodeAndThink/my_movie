import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListCinemaScreen extends StatelessWidget {
  const ListCinemaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.cinema,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
