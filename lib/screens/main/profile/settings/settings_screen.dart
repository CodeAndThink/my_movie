import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/settings_bloc/settings_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/settings_bloc/settings_event.dart';
import 'package:my_movie/screens/main/viewmodel/settings_bloc/settings_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final List<String> languages = ['English', 'Vietnamese'];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings,
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          String selectedLanguage =
              state.locale.languageCode == 'en' ? 'English' : 'Vietnamese';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.6,
                      ),
                      child: Text(
                        '${AppLocalizations.of(context)!.themeChange}:',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: state.themeData.brightness == Brightness.dark,
                      onChanged: (bool value) {
                        BlocProvider.of<SettingsBloc>(context)
                            .add(ToggleThemeEvent());
                      },
                    ),
                  ],
                ),
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.6,
                      ),
                      child: Text(
                        '${AppLocalizations.of(context)!.language}:',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: selectedLanguage,
                      icon: const Icon(Icons.language),
                      elevation: 16,
                      style: Theme.of(context).textTheme.bodyMedium,
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLanguage = newValue!;
                          Locale newLocale = selectedLanguage == 'English'
                              ? const Locale('en')
                              : const Locale('vi');
                          BlocProvider.of<SettingsBloc>(context)
                              .add(ChangeLanguageEvent(newLocale));
                        });
                      },
                      items: languages
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ],
                ),
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.6,
                      ),
                      child: Text(
                        '${AppLocalizations.of(context)!.includeAdult}:',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: state.themeData.brightness == Brightness.dark,
                      onChanged: (bool value) {
                        BlocProvider.of<SettingsBloc>(context)
                            .add(ToggleThemeEvent());
                      },
                    ),
                  ],
                ),
                Divider(
                  color: Theme.of(context).colorScheme.primary,
                  thickness: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
