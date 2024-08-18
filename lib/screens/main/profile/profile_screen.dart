import 'package:flutter/material.dart';
import 'package:my_movie/permission/permission_services.dart';
import 'package:my_movie/screens/main/profile/settings/about_us_screen.dart';
import 'package:my_movie/screens/main/profile/settings/settings_screen.dart';
import 'package:my_movie/screens/main/viewmodel/user_avatar_bloc/image_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/user_avatar_bloc/image_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final ImageBloc _imageBloc = ImageBloc();
  final PermissionServices _permissionService = PermissionServices();

  Future<void> _pickImageFromGallery() async {
    final hasPermissions = await _permissionService.requestStoragePermission();
    if (hasPermissions) {
      _imageBloc.add(PickImageFromGalleryEvent());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.storagePermissionAsk)),
      );
    }
  }

  Future<void> _pickImageFromCamera() async {
    final hasPermissions = await _permissionService.requestCameraPermission();
    if (hasPermissions) {
      _imageBloc.add(PickImageFromCameraEvent());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.cameraPermissionAsk)),
      );
    }
  }

  void _showImageSourceDialog(BuildContext context) {
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
                onPressed: () {
                  _pickImageFromGallery();
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.imagesFromGallery),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  _pickImageFromCamera();
                  Navigator.of(context).pop();
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
        elevation: 10,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              elevation: 7.0,
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
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/man.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () {
                              _showImageSourceDialog(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildProfileCard('1', 'Like'),
                        _buildProfileCard('2', 'Comments'),
                        _buildProfileCard('3', 'Level'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildProfileButton(Icons.info,
                AppLocalizations.of(context)!.information, () => {}),
            _buildProfileButton(Icons.favorite,
                AppLocalizations.of(context)!.favoritesList, () => {}),
            _buildProfileButton(Icons.calendar_month,
                AppLocalizations.of(context)!.calendar, () => {}),
            _buildProfileButton(
                Icons.settings, AppLocalizations.of(context)!.settings, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            }),
            _buildProfileButton(
                Icons.device_hub, AppLocalizations.of(context)!.aboutUs, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutUsScreen()));
            }),
            _buildProfileButton(
                Icons.logout, AppLocalizations.of(context)!.logOut, () => {}),
          ],
        ),
      ),
    );
  }
}
