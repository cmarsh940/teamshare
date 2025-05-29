import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/auth/auth_bloc.dart';

class TeamList extends StatelessWidget {
  final List<dynamic> teams;

  const TeamList({super.key, required this.teams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Team')),
      body: ListView.builder(
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return Card(
            child: ListTile(
              onTap:
                  () => {
                    BlocProvider.of<AuthBloc>(
                      context,
                    ).add(ChangePage(team['id'])),
                    Navigator.pop(context),
                  },
              title: Text(team['name']),
              subtitle: Text(team['description'] ?? 'No description'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  print('Delete team: ${team['name']}');
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
