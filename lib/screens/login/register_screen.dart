import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/constain_values/values.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_event.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  final AuthBloc authBloc;

  const RegisterScreen({super.key, required this.authBloc});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width;
    final cardHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.register,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: widget.authBloc,
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.canPop(context);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: cardHeight * 0.3,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'assets/logos/logo.png',
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    )),
                                Text(Values.appName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context)!.becomeNewMember),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.email,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.password,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.confirmPassword,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          final email = emailController.text;
                          final password = passwordController.text;
                          final confirmPassword =
                              confirmPasswordController.text;

                          if (password == confirmPassword) {
                            widget.authBloc.add(
                              AuthSignUpRequested(email, password),
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
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: Size(cardWidth - 20, 50),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.register,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
