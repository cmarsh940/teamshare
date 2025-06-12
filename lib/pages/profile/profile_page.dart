import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/auth/auth_bloc.dart';
import 'package:teamshare/models/user.dart';
import 'package:teamshare/pages/profile/bloc/profile_bloc.dart';
import 'package:teamshare/pages/profile/widgets/profile_layout.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => BlocProvider.of<AuthBloc>(context).add(LoggedIn()),
        ),
        title: Text('Profile'),
      ),
      body: Center(
        child: BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
          child: ProfileLayout(user: user),
        ),
      ),
    );
  }
}
