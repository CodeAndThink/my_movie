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
              elevation: 4.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.blue,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  Positioned(
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 40,
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
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.info),
                  const Spacer(),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.information,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                  ),
                  const Spacer(),
                  Title(
                      color: Theme.of(context).colorScheme.primary,
                      child: Text(AppLocalizations.of(context)!.favoritesList)),
                  const Spacer(),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.calendar_month),
                  const Spacer(),
                  Title(
                      color: Theme.of(context).colorScheme.primary,
                      child: Text(AppLocalizations.of(context)!.calendar)),
                  const Spacer(),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()))
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.settings),
                  const Spacer(),
                  Title(
                      color: Theme.of(context).colorScheme.primary,
                      child: Text(AppLocalizations.of(context)!.settings)),
                  const Spacer(),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutUsScreen()))
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.device_hub),
                  const Spacer(),
                  Title(
                      color: Theme.of(context).colorScheme.primary,
                      child: Text(AppLocalizations.of(context)!.aboutUs)),
                  const Spacer(),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.logout),
                  const Spacer(),
                  Title(
                      color: Theme.of(context).colorScheme.primary,
                      child: Text(AppLocalizations.of(context)!.logOut)),
                  const Spacer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
