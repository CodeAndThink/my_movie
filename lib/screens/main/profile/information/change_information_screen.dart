import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/data/models/user.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.changeInformation,
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _emailController,
                readOnly: true,
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
              TextField(
                controller: _dobController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.dob,
                    labelStyle: Theme.of(context).textTheme.headlineMedium),
              ),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.gender,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Expanded(
                    child: RadioListTile<int>(
                      title: Text(AppLocalizations.of(context)!.male),
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
                      title: Text(AppLocalizations.of(context)!.female),
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
                readOnly: true,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {},
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
        ));
  }
}
