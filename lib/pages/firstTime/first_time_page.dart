import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/models/user.dart';

import 'bloc/first_time_bloc.dart';
import 'widgets/first_time_form.dart';

class FirstTimePage extends StatelessWidget {
  final User user;
  final UserRepository _userRepository;

  FirstTimePage({
    Key? key,
    required User user,
    required UserRepository userRepository,
  }) : user = user,
       _userRepository = userRepository,
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Create Personal Plan')),
      body: Center(
        child: BlocProvider<FirstTimeBloc>(
          create: (context) => FirstTimeBloc(userRepository: _userRepository),
          child: FirstTimeForm(user: user),
        ),
      ),
    );
  }
}
