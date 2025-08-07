import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teamshare/auth/auth_bloc.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/pages/calendar/calendar_page.dart';
import 'package:teamshare/pages/member/member_page.dart';
import 'package:teamshare/pages/message/message_page.dart';
import 'package:teamshare/pages/photo_gallery/photo_gallery_page.dart';
import 'package:teamshare/pages/post/post_page.dart';
import 'package:teamshare/utils/app_logger.dart';

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

  @override
  void initState() {
    _initUserId();
    _initWidgetOptions();
    super.initState();
  }

  void _initWidgetOptions() {
    _widgetOptions.clear();
    _widgetOptions.add(PostPage(teamId: widget.teamId, userId: userId));
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
        title: Image.asset('assets/images/TEAM.png', height: 75),
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
