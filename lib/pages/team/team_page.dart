import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teamshare/auth/auth_bloc.dart';
import 'package:teamshare/pages/calendar/calendar_page.dart';
import 'package:teamshare/pages/member/member_page.dart';
import 'package:teamshare/pages/message/message_page.dart';
import 'package:teamshare/pages/notification/notification_page.dart';
import 'package:teamshare/pages/photo_gallery/photo_gallery_page.dart';
import 'package:teamshare/pages/post/post_page.dart';

class TeamPage extends StatefulWidget {
  final String teamId;

  const TeamPage({super.key, required this.teamId});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[];

  @override
  void initState() {
    print('Team id is : ${widget.teamId}');
    _widgetOptions.add(PostPage(teamId: widget.teamId));
    _widgetOptions.add(MessagePage(teamId: widget.teamId));
    _widgetOptions.add(PhotoGalleryPage(teamId: widget.teamId));
    _widgetOptions.add(CalendarPage(teamId: widget.teamId));
    _widgetOptions.add(MemberPage(teamId: widget.teamId));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
