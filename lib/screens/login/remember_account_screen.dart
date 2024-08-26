import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_movie/constain_values/values.dart';
import 'package:my_movie/screens/login/login_screen.dart';
import 'package:my_movie/screens/login/password_input_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({super.key});

  @override
  AccountListScreenState createState() => AccountListScreenState();
}

class AccountListScreenState extends State<AccountListScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  List<String> _accounts = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final accountsString = await _secureStorage.read(key: 'lastLoggedInEmail');
    if (accountsString != null) {
      setState(() {
        _accounts = List<String>.from(jsonDecode(accountsString));
      });
    }
  }

  void _onAccountSelected(String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasswordInputScreen(email: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width;
    final cardHeight = screenSize.height;

    return Scaffold(
      body: Column(
        children: [
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
                                color: Theme.of(context).colorScheme.surface,
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
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ))),
          ),
          Text(
            AppLocalizations.of(context)!.savedAccount,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Expanded(
              child: _accounts.isEmpty
                  ? const Center(
                      child: Text('No accounts found'),
                    )
                  : ListView.builder(
                      itemCount: _accounts.length,
                      itemBuilder: (context, index) {
                        final email = _accounts[index];
                        return Card(
                          color: Theme.of(context).colorScheme.primary,
                          margin: const EdgeInsets.all(8.0),
                          elevation: 4.0,
                          child: ListTile(
                            title: Text(
                              email,
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            onTap: () => _onAccountSelected(email),
                          ),
                        );
                      },
                    )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(cardWidth - 20, 50),
                ),
                child: Text(
                  AppLocalizations.of(context)!.moveToLogin,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
