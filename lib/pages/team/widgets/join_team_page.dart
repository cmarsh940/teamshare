import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/pages/team/bloc/team_bloc.dart';

class JoinTeamPage extends StatefulWidget {
  final String userId;
  const JoinTeamPage({super.key, required this.userId});

  @override
  State<JoinTeamPage> createState() => _JoinTeamPageState();
}

class _JoinTeamPageState extends State<JoinTeamPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  TeamRepository teamRepository = GetIt.I<TeamRepository>();

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Check if all fields are filled and auto-join using GetIt
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      final code = _controllers.map((c) => c.text).join();
      if (code.length == 6 && !_isLoading) {
        setState(() {
          _isLoading = true;
        });

        // Use GetIt to access TeamBloc directly
        final teamBloc = GetIt.I<TeamBloc>();
        teamBloc.add(JoinTeamEvent(teamCode: code, userId: widget.userId));
      }
    }
  }

  void _clearCode() {
    for (var controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _isLoading = false;
    });
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join A Team'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<TeamBloc, TeamState>(
        bloc: GetIt.I<TeamBloc>(), // Listen to the TeamBloc from GetIt
        listener: (context, state) {
          if (state is TeamJoinedSuccess) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Successfully joined team!')),
            );
            Navigator.pop(context);
          } else if (state is TeamJoinError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                const Icon(Icons.group_add, size: 80, color: Colors.orange),
                const SizedBox(height: 24),

                const Text(
                  'Enter Team Code',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                const Text(
                  'Enter the 6-digit code provided by your team',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Code input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 45,
                      height: 55,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        textAlignVertical:
                            TextAlignVertical
                                .center, // This centers the text vertically
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType: TextInputType.number,
                        autofillHints:
                            index == 0 ? [AutofillHints.oneTimeCode] : null,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.zero, // Remove default padding
                        ),
                        onChanged: (value) => _onChanged(value, index),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // Join button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        _isLoading
                            ? null
                            : () {
                              final code =
                                  _controllers.map((c) => c.text).join();
                              if (code.length == 6) {
                                setState(() {
                                  _isLoading = true;
                                });
                                // Use GetIt here too
                                GetIt.I<TeamBloc>().add(
                                  JoinTeamEvent(
                                    teamCode: code,
                                    userId: widget.userId,
                                  ),
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text(
                              'Join Team',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 16),

                // Clear button
                TextButton(
                  onPressed: _clearCode,
                  child: const Text(
                    'Clear Code',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),

                const Spacer(),

                // Help text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Ask your team admin for the team code to join',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
