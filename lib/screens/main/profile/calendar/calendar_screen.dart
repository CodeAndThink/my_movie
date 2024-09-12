import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.calendar,
          style: Theme.of(context).textTheme.headlineMedium,
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
