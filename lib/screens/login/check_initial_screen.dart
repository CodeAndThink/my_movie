import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_movie/screens/login/login_screen.dart';
import 'package:my_movie/screens/login/remember_account_screen.dart';

class CheckInitialScreen extends StatelessWidget {
  const CheckInitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkStoredAccount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            return const AccountListScreen();
          } else {
            return const LoginScreen();
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<String?> _checkStoredAccount() async {
    const storage = FlutterSecureStorage();
    final email = await storage.read(key: 'lastLoggedInEmail');
    return email;
  }
}
