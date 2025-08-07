import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/pages/member/bloc/member_bloc.dart';
import 'package:teamshare/pages/member/widgets/member_list.dart';

class MemberPage extends StatelessWidget {
  final String teamId;
  final TeamRepository teamRepository = GetIt.I<TeamRepository>();

  MemberPage({super.key, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider<MemberBloc>(
          create: (context) => MemberBloc(teamRepository),
          child: MemberList(teamId: teamId),
        ),
      ),
    );
  }
}
