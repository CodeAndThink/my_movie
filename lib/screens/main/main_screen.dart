import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/screens/main/home/home_screen.dart';
import 'package:my_movie/screens/main/minigame/minigame_screen.dart';
import 'package:my_movie/screens/main/notifications/notifications_screen.dart';
import 'package:my_movie/screens/main/profile/profile_screen.dart';
import 'package:my_movie/screens/main/search/search_screen.dart';
import 'package:my_movie/screens/main/viewmodel/settings_bloc/settings_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/settings_bloc/settings_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/screens/main/viewmodel/notification_bloc/notification_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/notification_bloc/notification_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages() {
    return [
      const HomeScreen(),
      const SearchScreen(),
      const MinigameScreen(),
      const NotificationScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return Scaffold(
          body: _pages()[_selectedIndex],
          bottomNavigationBar: SafeArea(
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, notificationState) {
                Icon notificationIcon = const Icon(Icons.notifications);

                if (notificationState is NotificationLoaded) {
                  notificationIcon = const Icon(Icons.notifications_active);
                }

                return BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.home),
                      label: AppLocalizations.of(context)!.home,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.search),
                      label: AppLocalizations.of(context)!.search,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.games),
                      label: AppLocalizations.of(context)!.miniGame,
                    ),
                    BottomNavigationBarItem(
                      icon: notificationIcon,
                      label: AppLocalizations.of(context)!.notifications,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.account_circle),
                      label: AppLocalizations.of(context)!.profile,
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Theme.of(context).colorScheme.secondary,
                  unselectedItemColor: Theme.of(context).colorScheme.primary,
                  onTap: _onItemTapped,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
