import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/member/bloc/member_bloc.dart';
import 'package:teamshare/pages/member/widgets/member_list.dart';

class MemberPage extends StatelessWidget {
  final String teamId;

  const MemberPage({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider<MemberBloc>(
          create: (context) => MemberBloc(),
          child: MemberList(teamId: teamId),
        ),
      ),
    );
  }
}
