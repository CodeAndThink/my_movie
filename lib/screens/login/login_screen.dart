import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/screens/login/register_screen.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_event.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final AuthBloc authBloc;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.authBloc,
  });

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width;

    final backgroundImage = Theme.of(context).brightness == Brightness.dark
        ? 'assets/images/dark_background.jpg'
        : 'assets/images/background.jpg';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  backgroundImage,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                ),
                Positioned(
                  top: 50,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/logos/logo.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          'myMovie',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 30.0),
                        Text(
                          AppLocalizations.of(context)!.welcomeBack,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.enterEmailPassword),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                        },
                      ),
                      Text(AppLocalizations.of(context)!.rememberAccount),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child:
                            Text(AppLocalizations.of(context)!.forgotPassword),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        final email = emailController.text;
                        final password = passwordController.text;

                        if (email.isNotEmpty && password.isNotEmpty) {
                          widget.authBloc.add(
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
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size(cardWidth - 20, 50),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.logIn,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  BlocConsumer<AuthBloc, AuthState>(
                    bloc: widget.authBloc,
                    listener: (context, state) {
                      if (state is AuthAuthenticated) {
                        widget.onLoginSuccess();
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
                      return Container();
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.haveNoAccount),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(
                              authBloc: widget.authBloc,
                            ),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.becomeNewMember,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
