import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/constain_values/values.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width;
    final cardHeight = screenSize.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.forgotPassword,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              SizedBox(
                height: cardHeight * 0.3,
                child: Center(
                    child: Card(
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
                              Text(
                                Values.appName,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ))),
              ),
              const SizedBox(height: 16.0),
              Text(
                AppLocalizations.of(context)!.enterEmail,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.surface,
                  minimumSize: Size(MediaQuery.of(context).size.width - 20, 50),
                ),
                child: Text(
                  AppLocalizations.of(context)!.sendCode,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.surface),
                ),
              ),
            ])));
  }
}
