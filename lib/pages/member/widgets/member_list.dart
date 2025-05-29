import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/member/bloc/member_bloc.dart';

class MemberList extends StatefulWidget {
  final String teamId;

  const MemberList({super.key, required this.teamId});

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  late MemberBloc _memberBloc;

  @override
  void initState() {
    super.initState();
    _memberBloc = BlocProvider.of<MemberBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, state) {
        if (state is MemberInitial) {
          _memberBloc.add(LoadMembers(widget.teamId));
        }
        if (state is MembersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MembersLoaded) {
          if (state.members.isEmpty) {
            return const Center(
              child: Text(
                'No members available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.members.length,
            itemBuilder: (context, index) {
              final member = state.members[index];
              return ListTile(title: Text(member));
            },
          );
        }
        return const Center(
          child: Text(
            'No Members Available',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _memberBloc.close();
    super.dispose();
  }
}
