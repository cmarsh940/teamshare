import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/auth/auth_bloc.dart';
import 'package:teamshare/models/user.dart';
import 'package:teamshare/pages/firstTime/bloc/first_time_bloc.dart';

class FirstTimeForm extends StatefulWidget {
  final User user;

  FirstTimeForm({Key? key, required this.user}) : super(key: key);

  @override
  State<FirstTimeForm> createState() => _FirstTimeFormState();
}

class _FirstTimeFormState extends State<FirstTimeForm> {
  User get user => widget.user;

  FirstTimeBloc? _firstTimeBloc;

  @override
  void initState() {
    super.initState();
    _firstTimeBloc = BlocProvider.of<FirstTimeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _firstTimeBloc,
      listener: (BuildContext context, FirstTimeState state) {
        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Finishing Up...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthBloc>(context).add(LoggedIn());
        }
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isChannelValid) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Cannot use that channel name'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder(
        bloc: _firstTimeBloc,
        builder: (BuildContext context, FirstTimeState state) {
          return Placeholder();
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
