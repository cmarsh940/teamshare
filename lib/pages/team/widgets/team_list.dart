import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/auth/auth_bloc.dart';
import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/pages/team/bloc/team_bloc.dart';
import 'package:teamshare/utils/app_logger.dart';

class TeamList extends StatefulWidget {
  final List<dynamic> teams;

  const TeamList({super.key, required this.teams});

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  final UserRepository userRepository = GetIt.I<UserRepository>();
  String userId = "";
  bool emptyTeams = false;

  @override
  void initState() {
    super.initState();
    AppLogger.debug('Initializing TeamList');
    _getUserId();
    _checkTeams();
  }

  _checkTeams() {
    if (widget.teams.isEmpty) {
      emptyTeams = true;
    } else {
      emptyTeams = false;
    }
    setState(() {});
    AppLogger.debug('Teams checked: $emptyTeams');
  }

  _getUserId() async {
    final id = await userRepository.getId();
    setState(() {
      userId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeamBloc>.value(
      value: GetIt.I<TeamBloc>(),
      child: BlocListener<TeamBloc, TeamState>(
        listener: (context, state) {
          // Add your state handling logic here
          if (state is TeamDeleted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Team deleted')));
            setState(() {
              widget.teams.removeWhere((team) => team['_id'] == state.teamId);
            });
          }
          // Handle other states if needed
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('My Teams')),
          body:
              emptyTeams
                  ? Center(child: Text('No Teams Available'))
                  : ListView.builder(
                    itemCount: widget.teams.length,
                    itemBuilder: (context, index) {
                      final team = widget.teams[index];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            BlocProvider.of<AuthBloc>(
                              context,
                            ).add(ChangePage(team['_id']));
                            Navigator.pop(context);
                          },
                          title: Text(team['name']),
                          subtitle: Text(
                            team['description'] ?? 'No description',
                          ),
                          trailing:
                              (team['admins'] != null &&
                                      (team['admins'] as List).contains(userId))
                                  ? IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      context.read<TeamBloc>().add(
                                        DeleteTeamEvent(teamId: team['_id']),
                                      );
                                    },
                                  )
                                  : null,
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
