import 'package:flutter/foundation.dart';
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
import 'package:teamshare/pages/home.dart';
import 'package:teamshare/pages/login/login_page.dart';
import 'package:teamshare/pages/message/bloc/message_bloc.dart';
import 'package:teamshare/pages/post/bloc/post_bloc.dart';
import 'package:teamshare/pages/profile/profile_page.dart';
import 'package:teamshare/pages/team/bloc/team_bloc.dart';
import 'package:teamshare/pages/team/team_page.dart';
import 'package:teamshare/shared/loading_indicator.dart';
import 'package:teamshare/shared/splash_page.dart';
import 'package:teamshare/utils/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.init(debugMode: kDebugMode);

  // Initialize dependencies
  await _initializeDependencies();

  runApp(
    BlocProvider<AuthBloc>(
      create: (context) {
        return AuthBloc(userRepository: GetIt.I<UserRepository>())
          ..add(AppStarted());
      },
      child: const App(),
    ),
  );
}

Future<void> _initializeDependencies() async {
  try {
    final userRepository = UserRepository();
    if (!GetIt.I.isRegistered<UserRepository>()) {
      GetIt.I.registerSingleton<UserRepository>(userRepository);
    }

    final teamRepository = TeamRepository();
    if (!GetIt.I.isRegistered<TeamRepository>()) {
      GetIt.I.registerSingleton<TeamRepository>(teamRepository);
    }

    final messageRepository = MessageRepository();
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

    AppLogger.info('Dependencies initialized successfully');
  } catch (e) {
    AppLogger.error('Failed to initialize dependencies', error: e);
    rethrow;
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeBloc(ThemeData.light()),
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (_, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (BuildContext context, AuthState state) {
                AppLogger.debug('Auth state changed: ${state.runtimeType}');

                switch (state.runtimeType) {
                  case Uninitialized:
                    return SplashPage();
                  case Unauthenticated:
                    return LoginPage(userRepository: GetIt.I<UserRepository>());
                  case Authenticated:
                    return HomePage(userRepository: GetIt.I<UserRepository>());
                  case ShowTeamPage:
                    final teamState = state as ShowTeamPage;
                    return TeamPage(teamId: teamState.page);
                  case Loading:
                    return LoadingIndicator();
                  case UserProfile:
                    final profileState = state as UserProfile;
                    return ProfilePage(user: profileState.user);
                  default:
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
  ThemeBloc(super.initialState) {
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
