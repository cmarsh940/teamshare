import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/auth/auth_bloc.dart';
import 'package:teamshare/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:teamshare/pages/team/widgets/create_team_form.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<DashboardBloc>(
        create: (context) => DashboardBloc(),
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardInitial) {
              BlocProvider.of<DashboardBloc>(context).add(LoadTeams());
            } else if (state is LoadingTeams) {
              return Center(child: CircularProgressIndicator());
            } else if (state is Loaded) {
              return Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Chip(
                          label: Text('My Teams'),
                          backgroundColor: Colors.black,
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 5)),
                        const Text(
                          'Teams',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            // Navigate to team details
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.teams.length,
                        itemBuilder: (context, index) {
                          final team = state.teams[index];
                          // Adjust these keys based on your team object structure
                          final teamName = team['name'] ?? 'Team';
                          final teamImage = team['imageUrl'];

                          return GestureDetector(
                            onTap: () {
                              BlocProvider.of<AuthBloc>(
                                context,
                              ).add(ChangePage(1));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        teamImage != null
                                            ? NetworkImage(teamImage)
                                            : null,
                                    child:
                                        teamImage == null
                                            ? Icon(Icons.groups, size: 30)
                                            : null,
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      teamName,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          color: Colors.black26,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateTeamForm(),
                              ),
                            );
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Create Team',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "It's easy - Get started in seconds!",
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('No teams available'));
          },
        ),
      ),
    );
  }
}
