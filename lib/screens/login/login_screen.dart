import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/screens/login/register_screen.dart';
import 'package:my_movie/theme/theme.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width;
    bool isChecked = false;

    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/background.jpg',
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
                          child: Text(
                              AppLocalizations.of(context)!.forgotPassword),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          bool isValidLogin = _checkLogin(
                              emailController.text, passwordController.text);
                          if (isValidLogin) {
                            widget.onLoginSuccess();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    AppLocalizations.of(context)!.loginFailed),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.haveNoAccount),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.becomeNewMember,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _checkLogin(String email, String password) {
    return email == "1" && password == "1";
  }
}
