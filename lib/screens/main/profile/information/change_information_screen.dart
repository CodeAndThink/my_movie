import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/data/models/user.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_event.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_state.dart';

class ChangeInformationScreen extends StatefulWidget {
  final User user;
  const ChangeInformationScreen({super.key, required this.user});

  @override
  ChangeInformationScreenState createState() => ChangeInformationScreenState();
}

class ChangeInformationScreenState extends State<ChangeInformationScreen> {
  late TextEditingController _emailController;
  late TextEditingController _displayNameController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _createDateController;
  late int _gender;
  DateTime? _selectedDate;

  Future<void> _selectDate() async {
    final DateTime currentDate = DateTime.now();
    final DateTime initialDate = _selectedDate ?? currentDate;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        _selectedDate = pickedDate;
        _updateDateController();
      });
    }
  }

  void _updateDateController() {
    _dobController.text = _selectedDate == null
        ? widget.user.dob
        : _selectedDate!.toLocal().toString().split(' ')[0];
  }

  @override
  void initState() {
    super.initState();
    _gender = widget.user.gender;
    _emailController = TextEditingController(text: widget.user.email);
    _displayNameController =
        TextEditingController(text: widget.user.displayName);
    _dobController = TextEditingController(text: widget.user.dob);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
    _createDateController = TextEditingController(
      text: widget.user.createDate
          .toString()
          .substring(0, 10)
          .split('-')
          .reversed
          .join('/')
          .toString(),
    );
    _updateDateController();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDataBloc, UserDataState>(
        listener: (context, state) {
          if (state is UserDataUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!.updateSuccess)),
            );
          } else if (state is UserDataFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.changeInformation,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                    controller: _emailController,
                    enabled: false,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.email,
                        labelStyle: Theme.of(context).textTheme.headlineMedium),
                  ),
                  TextField(
                    controller: _displayNameController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.name(''),
                        labelStyle: Theme.of(context).textTheme.headlineMedium),
                  ),
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _dobController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.dob,
                                labelStyle:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: _selectDate,
                              icon: const Icon(Icons.calendar_month))
                        ],
                      )
                    ],
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
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.phone,
                        labelStyle: Theme.of(context).textTheme.headlineMedium),
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.address,
                        labelStyle: Theme.of(context).textTheme.headlineMedium),
                  ),
                  TextField(
                    controller: _createDateController,
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.createDate,
                        labelStyle: Theme.of(context).textTheme.headlineMedium),
                    enabled: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        final userDataBloc = (context).read<UserDataBloc>();
                        User user = User(
                          id: widget.user.id,
                          email: widget.user.email,
                          displayName: _displayNameController.text,
                          dob: _dobController.text,
                          gender: _gender,
                          phone: _phoneController.text,
                          address: _addressController.text,
                          password: widget.user.password,
                          avatarPath: widget.user.avatarPath,
                          createDate: widget.user.createDate,
                          favoritesList: widget.user.favoritesList,
                        );
                        Map<String, dynamic> userJsonMap = user.toJson();
                        if (_displayNameController.text.isNotEmpty &&
                            _phoneController.text.isNotEmpty &&
                            _addressController.text.isNotEmpty) {
                          userDataBloc
                              .add(UpdateUserData(widget.user.id, userJsonMap));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .pleaseFillAllFields)),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width - 20, 50),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.changeInformation,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
