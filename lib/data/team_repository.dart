import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teamshare/constants.dart';
import 'package:teamshare/models/team.dart';
import 'package:teamshare/models/user.dart';

class TeamRepository {
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
}
