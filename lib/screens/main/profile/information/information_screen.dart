import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_event.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  InformationScreenState createState() => InformationScreenState();
}

class InformationScreenState extends State<InformationScreen> {
  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    final userId = authBloc.state is AuthAuthenticated
        ? (authBloc.state as AuthAuthenticated).docId
        : '';
    if (userId.isNotEmpty) {
      authBloc.add(FetchUserData(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FloatingActionButton pressed');
        },
        tooltip: 'Add',
        child: const Icon(Icons.edit),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is UserDataLoaded) {
            final userData = state.userData;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${AppLocalizations.of(context)!.email}: ${userData['email']}'),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    thickness: 1,
                  ),
                  Text(AppLocalizations.of(context)!
                      .displayName(userData['displayName'])),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    thickness: 1,
                  ),
                  Text(AppLocalizations.of(context)!.dob(userData['dob'])),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    thickness: 1,
                  ),
                  Text(AppLocalizations.of(context)!.gender(
                      userData['gender'] == 1
                          ? AppLocalizations.of(context)!.male
                          : AppLocalizations.of(context)!.female)),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    thickness: 1,
                  ),
                  Text(AppLocalizations.of(context)!.phone(userData['phone'])),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    thickness: 1,
                  ),
                  Text(AppLocalizations.of(context)!
                      .address(userData['address'])),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                    thickness: 1,
                  ),
                  Text(AppLocalizations.of(context)!
                      .createDate(userData['createDate'])),
                ],
              ),
            );
          }
          return const Center(child: Text('No user data available'));
        },
      ),
    );
  }
}
