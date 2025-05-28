import 'package:flutter/material.dart';

import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/pages/register/register_page.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({Key? key, required UserRepository userRepository})
    : _userRepository = userRepository,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'Create an Account',
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return RegisterPage(userRepository: _userRepository);
            },
          ),
        );
      },
    );
  }
}
