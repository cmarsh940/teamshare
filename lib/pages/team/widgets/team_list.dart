import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/auth/auth_bloc.dart';
import 'package:teamshare/pages/team/bloc/team_bloc.dart';

class TeamList extends StatefulWidget {
  final List<dynamic> teams;

  const TeamList({super.key, required this.teams});

  @override
  State<TeamList> createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
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
          appBar: AppBar(title: const Text('New Team')),
          body: ListView.builder(
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
                  subtitle: Text(team['description'] ?? 'No description'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<TeamBloc>().add(
                        DeleteTeamEvent(teamId: team['_id']),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
