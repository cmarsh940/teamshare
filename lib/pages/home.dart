import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamshare/auth/auth_bloc.dart';
import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/pages/dashboard/dashboard_page.dart';
import 'package:teamshare/pages/message/message_page.dart';
import 'package:teamshare/pages/notification/notification_page.dart';
import 'package:teamshare/pages/profile/profile_page.dart';
import 'package:teamshare/pages/setting/setting_page.dart';
import 'package:teamshare/pages/team/team_page.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  final UserRepository userRepository;

  HomePage({Key? key, required UserRepository userRepository})
    : userRepository = userRepository,
      super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  UserRepository get userRepository => widget.userRepository;
  bool? darkTheme;
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[];
  SharedPreferences prefs = GetIt.I<SharedPreferences>();

  @override
  void initState() {
    super.initState();
    _widgetOptions.add(DashboardPage());
    _widgetOptions.add(NotificationPage());
    _widgetOptions.add(MessagePage());
    _widgetOptions.add(SettingPage());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
        title: Image.asset('assets/images/TEAM.png', height: 75),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: Icon(Icons.account_circle),
              color: Theme.of(context).primaryColor,
              tooltip: 'Settings',
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
            label: 'Messages',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
