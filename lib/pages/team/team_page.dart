import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/auth/auth_bloc.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/main.dart';
import 'package:teamshare/pages/calendar/calendar_page.dart';
import 'package:teamshare/pages/member/member_page.dart';
import 'package:teamshare/pages/message/message_page.dart';
import 'package:teamshare/pages/photo_gallery/photo_gallery_page.dart';
import 'package:teamshare/pages/post/bloc/post_bloc.dart';
import 'package:teamshare/pages/post/post_page.dart';
import 'package:teamshare/utils/app_logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamPage extends StatefulWidget {
  final String teamId;

  const TeamPage({super.key, required this.teamId});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[];
  final TeamRepository teamRepository = GetIt.I<TeamRepository>();
  String userId = '';
  UserRepository userRepository = GetIt.instance<UserRepository>();
  String teamCode = '';
  String teamName = '';

  @override
  void initState() {
    _initUserId();
    _initWidgetOptions();
    _getTeamCodeAndName();
    super.initState();
  }

  void _initWidgetOptions() {
    _widgetOptions.clear();
    _widgetOptions.add(
      BlocProvider<PostBloc>(
        key: ValueKey('post-bloc-${widget.teamId}'),
        create: (_) => GetIt.I<PostBloc>(param1: widget.teamId),
        child: PostPage(teamId: widget.teamId, userId: userId),
      ),
    );
    _widgetOptions.add(
      MessagePage(teamId: widget.teamId, userId: userId, isTeamMessages: true),
    );
    _widgetOptions.add(PhotoGalleryPage(teamId: widget.teamId));
    _widgetOptions.add(
      CalendarPage(teamId: widget.teamId, teamRepository: teamRepository),
    );
    _widgetOptions.add(MemberPage(teamId: widget.teamId));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initUserId() async {
    userId = await userRepository.getId();

    if (userId.isEmpty) {
      AppLogger.error('User ID is empty! Check SecureStorage.');
      return;
    }

    // Rebuild widget options with the initialized userId
    setState(() {
      _initWidgetOptions();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _getTeamCodeAndName() async {
    var team = await teamRepository.getTeamCode(widget.teamId);
    if (team.isNotEmpty) {
      setState(() {
        teamCode = team['teamCode'] ?? '';
        teamName = team['teamName'] ?? '';
      });
    } else {
      AppLogger.error('Failed to retrieve team code for ${widget.teamId}');
    }
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                padding: EdgeInsets.all(16),
                child: Text(
                  'Share Team Code',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.message,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Send via Text Message'),
                subtitle: Text('Share team code through SMS'),
                onTap: () {
                  Navigator.pop(context);
                  _shareViaTextMessage();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.share,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Share via Other Apps'),
                subtitle: Text('Share team code through other apps'),
                onTap: () {
                  Navigator.pop(context);
                  _shareViaOtherApps();
                },
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _shareViaTextMessage() async {
    final String message = _buildShareMessage();

    try {
      // Use a more direct approach
      final String encodedMessage = message
          .replaceAll(' ', '%20')
          .replaceAll('\n', '%0A');
      final Uri smsUri = Uri.parse('sms:?body=$encodedMessage');

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        // Fallback to share_plus if SMS launcher fails
        await Share.share(message, subject: 'Join my team on TeamShare!');
      }
    } catch (e) {
      AppLogger.error('Error launching SMS: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to open text messaging. Please try another option.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _buildShareMessage() {
    return 'Join "$teamName" on TeamShare!\n\nTeam Code: $teamCode\n\nDownload the TeamShare app and enter this code to join our team and stay connected!';
  }

  void _shareViaOtherApps() async {
    final String message = _buildShareMessage();
    try {
      await Share.share(message, subject: 'Join my team on TeamShare!');
    } catch (e) {
      AppLogger.error('Error sharing: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to share team code. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          tooltip: 'Back Button',
          onPressed: () {
            BlocProvider.of<AuthBloc>(context).add(ChangePage('0'));
          },
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (teamName.isNotEmpty)
              Text(
                teamName,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (teamCode.isNotEmpty)
              GestureDetector(
                onTap: _showShareOptions,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Team Code: $teamCode',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.share, size: 14, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: Icon(Icons.account_circle),
              color: Theme.of(context).primaryColor,
              tooltip: 'Account',
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(Profile());
              },
            ),
          ),
        ],
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: 'messages'),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Photo Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Members'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
