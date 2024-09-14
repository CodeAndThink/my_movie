import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/user.dart';
import 'package:my_movie/screens/login/check_initial_screen.dart';
import 'package:my_movie/screens/main/book_ticket/book_ticket_screen.dart';
import 'package:my_movie/screens/main/profile/calendar/calendar_screen.dart';
import 'package:my_movie/screens/main/profile/comment/comment_screen.dart';
import 'package:my_movie/screens/main/profile/favorites/favorites_screen.dart';
import 'package:my_movie/screens/main/profile/information/information_screen.dart';
import 'package:my_movie/screens/main/profile/about_us/about_us_screen.dart';
import 'package:my_movie/screens/main/profile/settings/settings_screen.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_state.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_event.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late User userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _changeAvatar() {
    
  }

  void _getUserData() {
    final authBloc = context.read<AuthBloc>();
    final userDataBloc = context.read<UserDataBloc>();
    final userId = authBloc.state is AuthAuthenticated
        ? (authBloc.state as AuthAuthenticated).docId
        : '';
    if (userId.isNotEmpty) {
      userDataBloc.add(FetchUserData(userId));
    }
  }

  Widget _buildProfileCard(String count, String label) {
    return SizedBox(
      height: 80,
      width: 100,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton(
      IconData icon, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          const Spacer(),
          Center(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDataBloc, UserDataState>(
        listener: (context, state) {
          if (state is UserDataUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!.updateSuccess)),
            );
          } else if (state is UserDataFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.profile,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            child: BlocBuilder<UserDataBloc, UserDataState>(
                              builder: (context, state) {
                                if (state is UserDataLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (state is UserDataFailure) {
                                  return Center(
                                      child: Text('Error: ${state.error}'));
                                } else if (state is UserDataLoaded) {
                                  userData = state.userData;
                                  return Center(
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            ClipOval(
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/images/placeholder.png',
                                                image: userData.avatarPath,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/placeholder.png',
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons.camera_alt),
                                                onPressed: () {},
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildProfileCard(
                                                userData.favoritesList.length
                                                    .toString(),
                                                AppLocalizations.of(context)!
                                                    .like),
                                            _buildProfileCard(
                                                userData.commentIds.length
                                                    .toString(),
                                                AppLocalizations.of(context)!
                                                    .comments),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return const CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      AssetImage('assets/logos/logo.png'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildProfileButton(
                        Icons.info, AppLocalizations.of(context)!.information,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const InformationScreen()));
                    }),
                    _buildProfileButton(Icons.favorite,
                        AppLocalizations.of(context)!.favoritesList, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FavoritesScreen()));
                    }),
                    _buildProfileButton(Icons.confirmation_number,
                        AppLocalizations.of(context)!.bookTicket, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookTicketScreen()));
                    }),
                    _buildProfileButton(
                        Icons.comment, AppLocalizations.of(context)!.comments,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                    user: userData,
                                  )));
                    }),
                    _buildProfileButton(Icons.calendar_month,
                        AppLocalizations.of(context)!.calendar, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CalendarScreen()));
                    }),
                    _buildProfileButton(
                        Icons.settings, AppLocalizations.of(context)!.settings,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsScreen()));
                    }),
                    _buildProfileButton(
                        Icons.device_hub, AppLocalizations.of(context)!.aboutUs,
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AboutUsScreen()));
                    }),
                    _buildProfileButton(Icons.delete,
                        AppLocalizations.of(context)!.deleteAccount, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AboutUsScreen()));
                    }),
                    _buildProfileButton(
                        Icons.logout, AppLocalizations.of(context)!.logOut, () {
                      context.read<AuthBloc>().add(AuthSignOutRequested());
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckInitialScreen(),
                        ),
                        (route) => false,
                      );
                    }),
                  ],
                ),
              )),
        ));
  }
}
