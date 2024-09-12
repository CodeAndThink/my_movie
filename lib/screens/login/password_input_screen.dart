import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/screens/main/main_screen.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_event.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordInputScreen extends StatefulWidget {
  final String email;

  const PasswordInputScreen({super.key, required this.email});

  @override
  PasswordInputScreenState createState() => PasswordInputScreenState();
}

class PasswordInputScreenState extends State<PasswordInputScreen> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void onLoginSuccess() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.password,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            onLoginSuccess();
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width - 32,
                child: ElevatedButton(
                  onPressed: () {
                    final email = widget.email;
                    final password = _passwordController.text;

                    if (email.isNotEmpty && password.isNotEmpty) {
                      authBloc.add(
                        AuthSignInRequested(email, password),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!
                                .pleaseEnterCredentials,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    minimumSize:
                        Size(MediaQuery.of(context).size.width - 20, 50),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.logIn,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.surface),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
