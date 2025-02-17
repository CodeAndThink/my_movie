import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/user.dart';
import 'package:my_movie/screens/main/profile/information/change_information_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_state.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_event.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_state.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  InformationScreenState createState() => InformationScreenState();
}

class InformationScreenState extends State<InformationScreen> {
  late TextEditingController _emailController;
  late TextEditingController _displayNameController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _createDateController;
  late int _gender;

  void getUserData() {
    final authBloc = context.read<AuthBloc>();
    final userDataBloc = context.read<UserDataBloc>();
    final userId = authBloc.state is AuthAuthenticated
        ? (authBloc.state as AuthAuthenticated).docId
        : '';
    if (userId.isNotEmpty) {
      userDataBloc.add(FetchUserData(userId));
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _displayNameController = TextEditingController();
    _dobController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _createDateController = TextEditingController();
    _gender = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.userProfile,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<UserDataBloc, UserDataState>(
            builder: (context, state) {
              if (state is UserDataLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UserDataFailure) {
                return Center(child: Text('Error: ${state.error}'));
              } else if (state is UserDataLoaded) {
                final User user = state.userData;

                _gender = user.gender;
                _emailController.text = user.email;
                _displayNameController.text = user.displayName;
                _dobController.text = user.dob;
                _phoneController.text = user.phone;
                _addressController.text = user.address;
                _createDateController.text = user.createDate
                    .toString()
                    .substring(0, 10)
                    .split('-')
                    .reversed
                    .join('/');

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _emailController,
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.email,
                            labelStyle:
                                Theme.of(context).textTheme.headlineMedium),
                      ),
                      TextField(
                        controller: _displayNameController,
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.name(''),
                            labelStyle:
                                Theme.of(context).textTheme.headlineMedium),
                      ),
                      TextField(
                        controller: _dobController,
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.dob,
                            labelStyle:
                                Theme.of(context).textTheme.headlineMedium),
                      ),
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.gender,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Expanded(
                            child: RadioListTile<int>(
                              title: Text(AppLocalizations.of(context)!.female),
                              value: 1,
                              enableFeedback: false,
                              groupValue: _gender,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<int>(
                              title: Text(AppLocalizations.of(context)!.male),
                              value: 2,
                              groupValue: _gender,
                              enableFeedback: false,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      TextField(
                        controller: _phoneController,
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.phone,
                            labelStyle:
                                Theme.of(context).textTheme.headlineMedium),
                      ),
                      TextField(
                        controller: _addressController,
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.address,
                            labelStyle:
                                Theme.of(context).textTheme.headlineMedium),
                      ),
                      TextField(
                        controller: _createDateController,
                        enabled: false,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.createDate,
                            labelStyle:
                                Theme.of(context).textTheme.headlineMedium),
                        readOnly: true,
                      ),
                      Container(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeInformationScreen(
                                          user: user,
                                        ))).then((_) {
                              getUserData();
                            });
                          },
                          tooltip: 'Change Information',
                          child: const Icon(Icons.edit),
                        ),
                      )
                    ],
                  ),
                );
              }
              return Center(
                  child:
                      Text(AppLocalizations.of(context)!.noUserDataAvailable));
            },
          ),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _displayNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _createDateController.dispose();
    super.dispose();
  }
}
