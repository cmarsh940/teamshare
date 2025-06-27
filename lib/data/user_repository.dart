import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:teamshare/models/user.dart';

import '../../constants.dart';

class UserRepository {
  Future<User?> authenticate({
    required String email,
    required String password,
  }) async {
    var response = await http.post(
      Uri.parse(loginUrl),
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      print('response : ${response.body}');
      Map<String, dynamic> userMap = jsonDecode(response.body);
      final User user = new User.fromJson(userMap);
      print('user: ${user.email}');
      if (user.id == null) {
        print('User ID IS NULL');
        return null;
      } else {
        final token = 'test';
        final id = user.id;
        final firstTime = false;

        SharedPreferences.getInstance().then((prefs) {
          prefs.setString("user_token", token!);
          prefs.setString("user_id", id!);
          prefs.setBool("is_login", true);
          prefs.setBool("first_time", firstTime!);
          prefs.setBool("asked_for_permissions", false);
          prefs.setString("theme", "light");
        });
        return user;
      }
    } else {
      return null;
    }
  }

  Future finishSetup(User user) async {
    SharedPreferences prefs = GetIt.I<SharedPreferences>();
    String _token = prefs.getString("user_token")!;
    var id = user.id;
    if (id == null) {
      return null;
    } else {
      var url = finishSetupUrl + '$id';
      var _body = json.encode(user.toJson());
      final http.Response response = await http.put(
        Uri.parse(url),
        body: _body,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: "Bearer $_token",
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> userMap = jsonDecode(response.body);
        final User _user = new User.fromJson(userMap);
        if (_user.id == null) {
          print('User ID IS NULL');
          return null;
        } else {
          final firstTime = _user.firstTime;
          SharedPreferences.getInstance().then((prefs) {
            prefs.setBool("first_time", firstTime!);
            prefs.setBool("is_login", true);
            prefs.setBool("asked_for_permissions", false);
            prefs.setString("theme", "light");
          });
          return _user;
        }
      }
    }
  }

  Future appleAuthenticate({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    // print('email $email');
    // print('password $password');
    // print('firstName $firstName');
    // print('lastName $lastName');
    // var response = await http.post(appleLoginURL, body: {'email': email, 'password': password, 'firstName': firstName, 'lastName': lastName});
    // if (response.statusCode == 200) {
    //   Map userMap = jsonDecode(response.body);
    //   final UserModel _user = new UserModel.fromJson(userMap);
    //   if (_user.id == null) {
    //     print('user ID IS NULL');
    //     return null;
    //   } else {
    //     final _token = _user.token;
    //     final _id = _user.id;
    //     final _count = _user.surveyCount;
    //     final _subscription = _user.subscription;

    //     SharedPreferences.getInstance().then((prefs) {
    //       prefs.setString("user_token", _token);
    //       prefs.setString("user_id", _id);
    //       prefs.setBool("is_login", true);
    //       prefs.setInt("_count", _count);
    //       prefs.setString("_subscription", _subscription);
    //     });
    //     return _user;
    //   }
    // } else {
    //   return null;
    // }
  }

  Future googleAuthenticate({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    // var response = await http.post(googleLoginURL, body: {'email': email, 'password': password, 'firstName': firstName, 'lastName': lastName});
    // if (response.statusCode == 200) {
    //   Map userMap = jsonDecode(response.body);
    //   final UserModel _user = new UserModel.fromJson(userMap);
    //   // userModel _user = userModel.fromJson(json.decode(response.body));
    //   if (_user.id == null) {
    //     print('user ID IS NULL');
    //     return null;
    //   } else {
    //     final _token = _user.token;
    //     final _id = _user.id;
    //     final _count = _user.surveyCount;
    //     final _subscription = _user.subscription;

    //     SharedPreferences.getInstance().then((prefs) {
    //       prefs.setString("user_token", _token);
    //       prefs.setString("user_id", _id);
    //       prefs.setBool("is_login", true);
    //       prefs.setInt("_count", _count);
    //       prefs.setString("_subscription", _subscription);
    //     });
    //     return _user;
    //   }
    // } else {
    //   return null;
    // }
  }

  Future facebookAuthenticate({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    // var response = await http.post(facebookLoginURL, body: {'email': email, 'password': password, 'firstName': firstName, 'lastName': lastName});
    // if (response.statusCode == 200) {
    //   Map userMap = jsonDecode(response.body);
    //   final UserModel _user = new UserModel.fromJson(userMap);
    //   if (_user.id == null) {
    //     print('user ID IS NULL');
    //     return null;
    //   } else {
    //     final _token = _user.token;
    //     final _id = _user.id;
    //     final _count = _user.surveyCount;
    //     final _subscription = _user.subscription;

    //     SharedPreferences.getInstance().then((prefs) {
    //       prefs.setString("user_token", _token);
    //       prefs.setString("user_id", _id);
    //       prefs.setBool("is_login", true);
    //       prefs.setInt("_count", _count);
    //       prefs.setString("_subscription", _subscription);
    //     });
    //     return _user;
    //   }
    // } else {
    //   return null;
    // }
  }

  Future<void> deleteToken() async {
    SharedPreferences prefs = GetIt.I<SharedPreferences>();
    prefs.remove("user_token");
    return;
  }

  Future<String> getId() async {
    SharedPreferences prefs = GetIt.I<SharedPreferences>();
    return prefs.getString("user_id") ?? '';
  }

  Future<bool> checkFirstTime() async {
    SharedPreferences prefs = GetIt.I<SharedPreferences>();
    return prefs.getBool("first_time") ?? false;
  }

  getTheme() async {
    SharedPreferences prefs = GetIt.I<SharedPreferences>();
    return prefs.getString("theme");
  }

  Future<void> changeTheme() async {
    SharedPreferences prefs = GetIt.I<SharedPreferences>();
    if (prefs.getString("theme") == "light") {
      prefs.setString("theme", "dark");
    } else {
      prefs.setString("theme", "light");
    }
    return;
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = GetIt.I<SharedPreferences>();
    return prefs.getString("user_token");
  }

  Future<bool?> isSignedIn() async {
    SharedPreferences prefs = GetIt.I<SharedPreferences>();
    return prefs.getBool("is_login");
  }

  Future<dynamic> getUser() async {
    var _token = await getToken();
    String id = await getId();
    var url = Uri.parse(getUserUrl(id));
    var response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: "Bearer $_token"},
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    SharedPreferences prefs = GetIt.I<SharedPreferences>();
    prefs.clear();
    return;
  }

  Future signUp(
  // ignore: non_constant_identifier_names
  {
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPass,
  }) async {
    var response = await http.post(
      Uri.parse(registerUrl),
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'confirm_pass': confirmPass,
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> userMap = jsonDecode(response.body);
      final User _user = new User.fromJson(userMap);
      if (_user.id == null) {
        print('User ID IS NULL');
        return null;
      } else {
        final _token = _user.token;
        final _id = _user.id;
        final _firstTime = _user.firstTime;
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString("user_token", _token!);
          prefs.setString("user_id", _id!);
          prefs.setBool("is_login", true);
          prefs.setBool("first_time", _firstTime!);
          prefs.setString("theme", "light");
        });
        return _user;
      }
    }
  }

  Future updateUser(User user) async {
    SharedPreferences prefs = GetIt.I<SharedPreferences>();

    String _token = prefs.getString("user_token")!;
    var id = user.id;
    if (id == null) {
      return null;
    } else {
      var url = updateUserUrl(id);
      var _body = json.encode(user.toJson());
      final http.Response response = await http.put(
        Uri.parse(url),
        body: _body,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: "Bearer $_token",
        },
      );
      if (response.statusCode == 200) {
        var data = User.fromJson(json.decode(response.body));
        return data;
      } else {
        print('Error did not return 200');
        return null;
      }
    }
  }

  // Future uploadProfilePicture(String id, File file, String name) async {
  //   String id = (await getId())!;
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String _token = pref.getString("user_token")!;
  //   var url = uploadProfilePictureURL + '$id';
  //   var filePath = basename(file.path);
  //   var fileType = extension(filePath);
  //   var date = DateTime.now().toIso8601String();
  //   var newName = date + 'X' + id + fileType;
  //   FormData formData = FormData.fromMap({
  //     "picture": await MultipartFile.fromFile(file.path, filename: newName),
  //   });
  //   var response = await Dio().post(
  //     url,
  //     data: formData,
  //     options: Options(
  //       headers: {
  //         HttpHeaders.authorizationHeader:
  //             "Bearer $_token", // set content-length
  //       },
  //     ),
  //   );
  //   if (response.statusCode == 200) {
  //     return response.data;
  //   } else {
  //     return false;
  //   }
  // }
}
