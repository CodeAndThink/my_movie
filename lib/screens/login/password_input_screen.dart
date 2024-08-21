import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_event.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_state.dart';

class PasswordInputScreen extends StatefulWidget {
  final String email;

  const PasswordInputScreen({super.key, required this.email});

  @override
  PasswordInputScreenState createState() => PasswordInputScreenState();
}

class PasswordInputScreenState extends State<PasswordInputScreen> {
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final password = _passwordController.text;

    final authBloc = context.read<AuthBloc>();
    authBloc.add(AuthSignInRequested(widget.email, password));

    authBloc.stream.listen((state) {
      if (state is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${state.error}')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
