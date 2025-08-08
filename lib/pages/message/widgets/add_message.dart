import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/main.dart';
import 'package:teamshare/models/user.dart';
import 'package:teamshare/pages/message/bloc/message_bloc.dart';
import 'package:teamshare/pages/team/bloc/team_bloc.dart';
import 'package:teamshare/utils/app_logger.dart';

class AddMessageWidget extends StatefulWidget {
  final String? teamId;
  final String userId;

  const AddMessageWidget({super.key, this.teamId, required this.userId});

  @override
  State<AddMessageWidget> createState() => _AddMessageWidgetState();
}

class _AddMessageWidgetState extends State<AddMessageWidget> {
  final TextEditingController _controller = TextEditingController();
  List<User> _selectedMembers = [];
  List<User> _availableMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    AppLogger.info('**** Team ID: ${widget.teamId}');
    if (widget.teamId != null) {
      AppLogger.debug('Fetching team members for team: ${widget.teamId}');
      GetIt.I<TeamBloc>().add(GetTeamMembers(widget.teamId!));
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleMember(User member) {
    setState(() {
      if (_selectedMembers.any((m) => m.id == member.id)) {
        _selectedMembers.removeWhere((m) => m.id == member.id);
      } else {
        _selectedMembers.add(member);
      }
    });
  }

  void _showMemberSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        width: 40,
                        height: 4,
                        margin: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Recipients',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Done'),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      // Members list
                      Expanded(
                        child:
                            _availableMembers.isEmpty
                                ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.people_outline,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No team members found',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: _availableMembers.length,
                                  itemBuilder: (context, index) {
                                    final member = _availableMembers[index];
                                    final isSelected = _selectedMembers.any(
                                      (m) => m.id == member.id,
                                    );

                                    return CheckboxListTile(
                                      title: Text(
                                        member.firstName ??
                                            member.email ??
                                            'Unknown',
                                      ),
                                      subtitle: Text(member.email ?? ''),
                                      secondary: CircleAvatar(
                                        child: Text(
                                          (member.firstName ??
                                                  member.email ??
                                                  'U')[0]
                                              .toUpperCase(),
                                        ),
                                      ),
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        _toggleMember(member);
                                        setModalState(
                                          () {},
                                        ); // Update modal state
                                        setState(
                                          () {},
                                        ); // Update main widget state
                                      },
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                    );
                                  },
                                ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildSelectedMembersChips() {
    if (_selectedMembers.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Text(
          'No recipients selected. Tap to add recipients.',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            _selectedMembers.map((member) {
              return Chip(
                label: Text(
                  member.firstName ?? member.email ?? 'Unknown',
                  style: TextStyle(fontSize: 12),
                ),
                deleteIcon: Icon(Icons.close, size: 18),
                onDeleted: () => _toggleMember(member),
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.1),
                deleteIconColor: Theme.of(context).primaryColor,
              );
            }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Message'),
        backgroundColor: Colors.grey[300],
      ),
      body: BlocListener<TeamBloc, TeamState>(
        bloc: GetIt.I<TeamBloc>(),
        listener: (context, state) {
          if (state is TeamMembersLoaded) {
            AppLogger.debug(
              '***************** Loaded ${state.members.members.length} members for team: ${widget.teamId}',
            );
            setState(() {
              // Filter out the current user from available members
              _availableMembers =
                  state.members.members
                      .where((member) => member.id != widget.userId)
                      .toList();
              _isLoading = false;
            });
          } else if (state is TeamMembersError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading members: ${state.message}'),
              ),
            );
          }
        },
        child: BlocListener<MessageBloc, MessageState>(
          listener: (context, state) {
            if (state is MessageSent) {
              _controller.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Message sent successfully!')),
              );
              Navigator.pop(context); // Close the message screen after sending
            }
          },
          child:
              _isLoading
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Loading team members...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                  : Column(
                    children: [
                      // Recipients selector
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap:
                                  _availableMembers.isEmpty
                                      ? null
                                      : _showMemberSelector,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.people, color: Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Text(
                                      _availableMembers.isEmpty
                                          ? 'No team members available'
                                          : 'To: ${_selectedMembers.length} recipient${_selectedMembers.length != 1 ? 's' : ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            _availableMembers.isEmpty
                                                ? Colors.grey[500]
                                                : Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                    if (_availableMembers.isNotEmpty)
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.grey[600],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            _buildSelectedMembersChips(),
                          ],
                        ),
                      ),
                      // Chat area
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey[50],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  _availableMembers.isEmpty
                                      ? 'No team members available to message'
                                      : _selectedMembers.isEmpty
                                      ? 'Select recipients to start messaging'
                                      : 'Compose your message to ${_selectedMembers.length} recipient${_selectedMembers.length != 1 ? 's' : ''}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Message input area
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: SafeArea(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: 40,
                                    maxHeight: 120,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _controller,
                                    maxLines: null,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    enabled: _selectedMembers.isNotEmpty,
                                    decoration: InputDecoration(
                                      hintText:
                                          _selectedMembers.isEmpty
                                              ? 'Select recipients first...'
                                              : 'Type a message...',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color:
                                      _selectedMembers.isEmpty
                                          ? Colors.grey[400]
                                          : Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  onPressed:
                                      _selectedMembers.isEmpty
                                          ? null
                                          : () {
                                            final message =
                                                _controller.text.trim();
                                            if (message.isNotEmpty) {
                                              // Send message to all selected members
                                              for (final member
                                                  in _selectedMembers) {
                                                context.read<MessageBloc>().add(
                                                  SendMessage(
                                                    message,
                                                    member.id ?? '',
                                                    teamId: widget.teamId,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                  icon: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
