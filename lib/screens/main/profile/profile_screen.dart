import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/screens/login/check_initial_screen.dart';
import 'package:my_movie/screens/main/profile/calendar/calendar_screen.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
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

  void _showImageSourceDialog(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.selectImageSource,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final permissionStatus = await Permission.photos.request();
                  if (permissionStatus.isGranted) {
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .selectedImagePath(image.path)),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.permissionDenied),
                      ),
                    );
                  }
                },
                child: Text(AppLocalizations.of(context)!.imagesFromGallery),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();

                  final permissionStatus = await Permission.camera.request();
                  if (permissionStatus.isGranted) {
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!
                                .capturedImagePath(image.path),
                          ),
                        ),
                      );
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.permissionDenied,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Text(AppLocalizations.of(context)!.imagesFromCamera),
              ),
            ],
          ),
        );
      },
    );
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
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
                                  final userData = state.userData;
                                  return Center(
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                  userData['avatarPath']),
                                            ),
                                            Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons.camera_alt),
                                                onPressed: () {
                                                  _showImageSourceDialog(
                                                      context);
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildProfileCard(
                                                userData['favoritesList']
                                                    .length
                                                    .toString(),
                                                AppLocalizations.of(context)!
                                                    .like),
                                            _buildProfileCard(
                                                userData['commentIds']
                                                    .length
                                                    .toString(),
                                                AppLocalizations.of(context)!
                                                    .comments),
                                            _buildProfileCard(
                                                '3',
                                                AppLocalizations.of(context)!
                                                    .level),
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
                    _buildProfileButton(Icons.comment,
                        AppLocalizations.of(context)!.comments, () {}),
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
