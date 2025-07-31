import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:teamshare/data/user_repository.dart';
import '../../constants.dart';
import 'package:teamshare/models/calendar.dart';
import 'package:teamshare/models/post.dart';
import 'package:teamshare/models/team.dart';
import 'package:teamshare/models/user.dart';

class TeamRepository {
  UserRepository userRepository = GetIt.instance<UserRepository>();

  // Example method to fetch teams
  Future<List<dynamic>> fetchTeams(dynamic id) async {
    http.Response response = await http.get(Uri.parse(fetchTeamUrl(id)));

    final List<dynamic> decoded = jsonDecode(response.body);
    return decoded;
  }

  Future<void> createTeam(dynamic team) async {
    var response = await http.post(
      Uri.parse(createTeamUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(team),
    );
    if (response.statusCode == 200) {
      return team;
    } else {
      throw Exception('Failed to create team');
    }
  }

  // Example method to update a team
  Future<void> updateTeam(String oldName, String newName) async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 1));
    print('Team $oldName updated to $newName');
  }

  // Example method to delete a team
  Future<void> deleteTeam(String teamId) async {
    http.Response response = await http.delete(
      Uri.parse(deleteTeamUrl(teamId)),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete team');
    }
  }

  Future<Team> getTeamMembers(String teamId) async {
    var url = fetchTeamMembersUrl(teamId);
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return Team.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load team members');
    }
  }

  Future<void> removeMember(String teamId, String userId) async {
    var url = removeMemberUrl(teamId, userId);
    var response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to remove member');
    }
  }

  Future<List<Post>> getTeamPosts(String teamId) async {
    var url = fetchTeamPostsUrl(teamId);
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return (jsonResponse as List).map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load team posts');
    }
  }

  Future<List<String>> getTeamPhotos(String teamId) async {
    var url = fetchTeamPhotosUrl(teamId);
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      return (jsonDecode(response.body) as List)
          .map((photo) => photo['photo'] as String)
          .toList();
    } else {
      throw Exception('Failed to load team photos');
    }
  }

  Future<void> addPhotoToGallery(String teamId, String photoUrl) async {
    var url = postTeamPhotosUrl(teamId);
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'photo': photoUrl}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add photo to gallery');
    }
  }

  Future<List<TeamCalendar>> getTeamCalendar(String teamId) async {
    var url = fetchTeamCalendarUrl(teamId);
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return (jsonResponse as List)
          .map((event) => TeamCalendar.fromJson(event))
          .toList();
    } else {
      throw Exception('Failed to load team calendar');
    }
  }

  Future<void> addTeamCalendarEvent(String teamId, TeamCalendar event) async {
    var url = postTeamCalendarEventUrl(teamId);
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(event.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add calendar event');
    }
  }

  Future<String> acceptTeamCalendarEvent(String eventId) async {
    final userId = await userRepository.getId();
    var url = acceptTeamCalendarEventUrl(eventId, userId);
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'eventId': eventId, 'userId': userId}),
    );
    if (response.statusCode == 200) {
      return userId;
    } else {
      throw Exception('Failed to accept calendar event');
    }
  }

  Future<String> declineTeamCalendarEvent(String eventId) async {
    final userId = await userRepository.getId();
    var url = declineTeamCalendarEventUrl(eventId, userId);
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'eventId': eventId, 'userId': userId}),
    );
    if (response.statusCode == 200) {
      return userId;
    } else {
      throw Exception('Failed to accept calendar event');
    }
  }

  Future<void> addPost(Post post, String teamId) async {
    final userId = await userRepository.getId();
    var url = addTeamPostUrl(teamId);
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({...post.toJson(), 'userId': userId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add post');
    }
  }

  Future<void> likePost(String postId, String userId) async {
    var url = likePostUrl(postId, userId);
    var response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'postId': postId, 'userId': userId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to like post');
    }
  }
}
