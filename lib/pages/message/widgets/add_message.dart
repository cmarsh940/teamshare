// This widget will allow users to input and send new messages.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/pages/message/bloc/message_bloc.dart';

class AddMessageWidget extends StatefulWidget {
  final String recipientId;
  final String? teamId;

  const AddMessageWidget({super.key, required this.recipientId, this.teamId});

  @override
  State<AddMessageWidget> createState() => _AddMessageWidgetState();
}

class _AddMessageWidgetState extends State<AddMessageWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Message'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocListener<MessageBloc, MessageState>(
        listener: (context, state) {
          if (state is MessageSent) {
            _controller.clear();
            // Show a snackbar message after sending message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Message sent successfully!')),
            );
          }
        },
        child: Column(
          children: [
            // Chat area (empty for now, could show preview or recent messages)
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
                        'Compose your message',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
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
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
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
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
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
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          final message = _controller.text.trim();
                          if (message.isNotEmpty) {
                            context.read<MessageBloc>().add(
                              SendMessage(
                                message,
                                widget.recipientId,
                                teamId: widget.teamId,
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.send, color: Colors.white, size: 20),
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
    );
  }
}
