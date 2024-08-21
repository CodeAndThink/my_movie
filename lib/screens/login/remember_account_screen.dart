import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_movie/screens/login/login_screen.dart';
import 'package:my_movie/screens/login/password_input_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';

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
    final email = await _secureStorage.read(key: 'lastLoggedInEmail');
    if (email != null) {
      setState(() {
        _accounts = [email];
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
    final authBloc = context.read<AuthBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select an Account',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Column(
        children: [
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
                        color: Theme.of(context).colorScheme.surface,
                        margin: const EdgeInsets.all(8.0),
                        elevation: 4.0,
                        child: ListTile(
                          title: Text(email,
                              style: Theme.of(context).textTheme.bodyMedium),
                          onTap: () => _onAccountSelected(email),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(
                        authBloc: authBloc,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Move to Login Screen',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
