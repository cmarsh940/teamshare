import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/data/repositories.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/pages/team/bloc/team_bloc.dart';

class CreateTeamForm extends StatefulWidget {
  const CreateTeamForm({super.key});

  @override
  State<CreateTeamForm> createState() => _CreateTeamFormState();
}

class _CreateTeamFormState extends State<CreateTeamForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  UserRepository userRepository = GetIt.I<UserRepository>();
  TeamRepository teamRepository = GetIt.I<TeamRepository>();

  createTeam(BuildContext context) async {
    final userId = await userRepository.getId();

    if (_formKey.currentState!.validate()) {
      final team = {
        'admins': [userId],
        'members': [userId],
        'name': _nameController.text,
        'description': _descriptionController.text,
      };

      context.read<TeamBloc>().add(TeamCreateEvent(team: team));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Processing Data')));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Team')),
      body: BlocProvider<TeamBloc>(
        create: (context) => TeamBloc(teamRepository),
        child: BlocBuilder<TeamBloc, TeamState>(
          builder: (context, state) {
            if (state is TeamInitial) {
              context.read<TeamBloc>().add(LoadForm());
            } else if (state is Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is Loaded) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          // icon: Icon(Icons., color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black45),
                          labelText: 'Team Name',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter your team name',
                          hintStyle: TextStyle(color: Colors.black45),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        autocorrect: false,
                        cursorColor: Colors.black45,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _descriptionController,
                        minLines: 6,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black45),
                          labelText: 'Team Description',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter your team description',
                          hintStyle: TextStyle(color: Colors.black45),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        autocorrect: false,
                        cursorColor: Colors.black45,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              createTeam(context);
                            }
                          },
                          child: const Text(
                            'Create Team',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
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
