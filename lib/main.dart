import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:teamshare/auth/auth_bloc.dart';
import 'package:teamshare/data/message_repository.dart';
import 'package:teamshare/data/notification_repository.dart';
import 'package:teamshare/data/repositories.dart';
import 'package:teamshare/data/team_repository.dart';
import 'package:teamshare/pages/calendar/bloc/calendar_bloc.dart';
import 'package:teamshare/pages/firstTime/first_time_page.dart';
import 'package:teamshare/pages/home.dart';
import 'package:teamshare/pages/login/login_page.dart';
import 'package:teamshare/pages/message/bloc/message_bloc.dart';
import 'package:teamshare/pages/post/bloc/post_bloc.dart';
import 'package:teamshare/pages/profile/profile_page.dart';
import 'package:teamshare/pages/team/bloc/team_bloc.dart';
import 'package:teamshare/pages/team/team_page.dart';
import 'package:teamshare/shared/loading_indicator.dart';
import 'package:teamshare/shared/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userRepository = UserRepository();
  if (!GetIt.I.isRegistered<UserRepository>()) {
    GetIt.I.registerSingleton<UserRepository>(userRepository);
  }

  final TeamRepository teamRepository = TeamRepository();
  if (!GetIt.I.isRegistered<TeamRepository>()) {
    GetIt.I.registerSingleton<TeamRepository>(teamRepository);
  }

  final MessageRepository messageRepository = MessageRepository();
  if (!GetIt.I.isRegistered<MessageRepository>()) {
    GetIt.I.registerSingleton<MessageRepository>(messageRepository);
  }

  final teamBloc = TeamBloc(GetIt.I<TeamRepository>());
  if (!GetIt.I.isRegistered<TeamBloc>()) {
    GetIt.I.registerSingleton<TeamBloc>(teamBloc);
  }

  final calendarBloc = CalendarBloc(GetIt.I<TeamRepository>());
  if (!GetIt.I.isRegistered<CalendarBloc>()) {
    GetIt.I.registerSingleton<CalendarBloc>(calendarBloc);
  }

  final messageBloc = MessageBloc();
  if (!GetIt.I.isRegistered<MessageBloc>()) {
    GetIt.I.registerSingleton<MessageBloc>(messageBloc);
  }

  final postBloc = PostBloc();
  if (!GetIt.I.isRegistered<PostBloc>()) {
    GetIt.I.registerSingleton<PostBloc>(postBloc);
  }

  final notificationRepository = NotificationRepository();
  if (!GetIt.I.isRegistered<NotificationRepository>()) {
    GetIt.I.registerSingleton<NotificationRepository>(notificationRepository);
  }

  final sharedPreferences = await SharedPreferences.getInstance();
  if (!GetIt.I.isRegistered<SharedPreferences>()) {
    GetIt.I.registerSingleton<SharedPreferences>(sharedPreferences);
  }

  runApp(
    BlocProvider<AuthBloc>(
      // lazy: false,
      create: (context) {
        return AuthBloc(userRepository: userRepository)..add(AppStarted());
      },
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository userRepository = GetIt.I<UserRepository>();

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeBloc(ThemeData.light()),
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (_, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: BlocBuilder<AuthBloc, AuthState>(
              bloc: BlocProvider.of<AuthBloc>(context),
              // ignore: missing_return
              builder: (BuildContext context, AuthState state) {
                if (state is Uninitialized) {
                  print('uninitialized');
                  return SplashPage();
                }
                if (state is Unauthenticated) {
                  print('unauthenticated');
                  return LoginPage(userRepository: userRepository);
                }
                if (state is Authenticated) {
                  print('authenticated');
                  return HomePage(userRepository: userRepository);
                }
                if (state is ShowTeamPage) {
                  print('show team page');
                  return TeamPage(teamId: state.page);
                }
                if (state is Loading) {
                  print('loading');
                  return LoadingIndicator();
                }

                if (state is FirstTimeForm) {
                  print('first time');
                  return FirstTimePage(
                    user: state.user,
                    userRepository: userRepository,
                  );
                }
                if (state is UserProfile) {
                  print('user profile');
                  return ProfilePage(user: state.user);
                } else {
                  return LoadingIndicator();
                }
              },
            ),
            theme: theme.copyWith(
              primaryColor: const Color.fromARGB(255, 199, 199, 199),
            ),
            initialRoute: '/',
          );
        },
      ),
    );
  }
}

enum ThemeEvent { toggle }

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc(ThemeData initialState) : super(initialState) {
    on<ThemeEvent>((event, emit) {
      if (event == ThemeEvent.toggle) {
        if (state == ThemeData.dark()) {
          emit(ThemeData.light());
        } else {
          emit(ThemeData.dark());
        }
      }
    });
  }
}
