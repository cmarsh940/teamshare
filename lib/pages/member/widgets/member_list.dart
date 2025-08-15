import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/data/repositories.dart';
import 'package:teamshare/pages/member/bloc/member_bloc.dart';
import 'package:teamshare/shared/dialogs/confirmation_dialog.dart';

class MemberList extends StatefulWidget {
  final String teamId;

  const MemberList({super.key, required this.teamId});

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  late MemberBloc _memberBloc;
  final UserRepository userRepository = GetIt.I<UserRepository>();
  String userId = "";

  @override
  void initState() {
    super.initState();
    _memberBloc = BlocProvider.of<MemberBloc>(context);
    _getUserId();
  }

  _getUserId() async {
    final id = await userRepository.getId();
    setState(() {
      userId = id;
    });
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
          if (state.team.members == []) {
            return const Center(
              child: Text(
                'No members available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: state.team.members.length,
            itemBuilder: (context, index) {
              final member = state.team.members[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      member.picture != null && member.picture!.isNotEmpty
                          ? NetworkImage(member.picture!)
                          : const AssetImage('assets/images/missing.jpg')
                              as ImageProvider,
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${member.firstName ?? ''} ${member.lastName ?? ''}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (state.team.admins.contains(member.id)) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.shield, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      const Text(
                        'Admin',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (member.email != null &&
                            member.email!.isNotEmpty) ...[
                          Flexible(
                            child: Text(
                              member.email!,
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        if (member.phone != null &&
                            member.phone!.isNotEmpty) ...[
                          if (member.email != null && member.email!.isNotEmpty)
                            const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              member.phone!,
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                trailing:
                    (state.team.admins.contains(userId) && member.id != userId)
                        ? IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          tooltip: 'Remove from team',
                          onPressed: () async {
                            final name =
                                '${member.firstName ?? ''} ${member.lastName ?? ''}'
                                    .trim();
                            final confirmed = await showConfirmationDialog(
                              context,
                              title: 'Remove Member',
                              message:
                                  'Are you sure you want to remove ${name.isEmpty ? 'this member' : name} from the team?',
                              confirmText: 'Remove',
                              cancelText: 'Cancel',
                              destructive: true,
                              icon: Icons.warning_amber_rounded,
                            );
                            if (confirmed == true) {
                              if (!mounted) return;
                              context.read<MemberBloc>().add(
                                RemoveMemberFromTeam(
                                  state.team.id!,
                                  member.id!,
                                ),
                              );
                            }
                          },
                        )
                        : null,
              );
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
