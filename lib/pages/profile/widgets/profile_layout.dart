import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/auth/auth_bloc.dart';
import 'package:teamshare/models/user.dart';
import 'package:teamshare/pages/profile/bloc/profile_bloc.dart';

class ProfileLayout extends StatefulWidget {
  final User user;

  const ProfileLayout({super.key, required this.user});

  @override
  State<ProfileLayout> createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> {
  late ProfileBloc _profileBloc;
  User get user => widget.user;

  @override
  void initState() {
    print('ProfileLayout initState called');
    super.initState();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _profileBloc,
      listener: (BuildContext context, ProfileState state) {},
      child: BlocBuilder(
        bloc: _profileBloc,
        builder: (BuildContext context, ProfileState state) {
          return Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    user.picture != null
                        ? NetworkImage(user.picture!)
                        : const AssetImage('assets/images/missing.jpg')
                            as ImageProvider,
              ),
              const SizedBox(height: 20),
              Text(
                '${user.firstName} ${user.lastName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                user.email ?? 'No Email',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Spacer(),
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(LogOut());
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
