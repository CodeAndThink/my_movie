import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_movie/screens/login/login_screen.dart';
import 'package:my_movie/screens/login/remember_account_screen.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';

class CheckInitialScreen extends StatelessWidget {
  const CheckInitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return FutureBuilder(
      future: _checkStoredAccount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            return const AccountListScreen();
          } else {
            return LoginScreen(
              authBloc: authBloc,
            );
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
