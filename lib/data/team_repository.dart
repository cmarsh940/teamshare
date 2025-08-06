import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:teamshare/data/user_repository.dart';
import 'package:teamshare/models/comment.dart';
import 'package:teamshare/models/calendar.dart';
import 'package:teamshare/models/post.dart';
import 'package:teamshare/models/team.dart';
import 'package:teamshare/utils/app_logger.dart';
import 'package:teamshare/utils/secure_http_client.dart';
import '../../constants.dart';

class TeamRepository {
  UserRepository userRepository = GetIt.instance<UserRepository>();

  // Cache for frequently accessed data
  final Map<String, List<dynamic>> _teamsCache = {};
  final Map<String, List<Post>> _postsCache = {};
  final Map<String, List<TeamCalendar>> _calendarCache = {};

  Future<List<dynamic>> fetchTeams(dynamic id) async {
    try {
      final cacheKey = 'teams_$id';
      if (_teamsCache.containsKey(cacheKey)) {
        AppLogger.performance('Using cached teams for $id');
        return _teamsCache[cacheKey]!;
      }

      final response = await SecureHttpClient.get(Uri.parse(fetchTeamUrl(id)));

      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        _teamsCache[cacheKey] = decoded;
        return decoded;
      } else {
        throw Exception('Failed to fetch teams: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error fetching teams', error: e);
      rethrow;
    }
  }

  Future<void> createTeam(dynamic team) async {
    try {
      final response = await SecureHttpClient.post(
        Uri.parse(createTeamUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(team),
      );

      if (response.statusCode == 200) {
        // Clear teams cache since we added a new team
        _teamsCache.clear();
        AppLogger.info('Team created successfully');
      } else {
        throw Exception('Failed to create team: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error creating team', error: e);
      rethrow;
    }
  }

  Future<void> updateTeam(String oldName, String newName) async {
    try {
      // Simulate a network call
      await Future.delayed(const Duration(seconds: 1));
      AppLogger.info('Team $oldName updated to $newName');
      // Clear cache after update
      _teamsCache.clear();
    } catch (e) {
      AppLogger.error('Error updating team', error: e);
      rethrow;
    }
  }

  Future<void> deleteTeam(String teamId) async {
    try {
      final response = await SecureHttpClient.delete(
        Uri.parse(deleteTeamUrl(teamId)),
      );

      if (response.statusCode == 200) {
        // Clear relevant caches
        _teamsCache.clear();
        _postsCache.removeWhere((key, value) => key.contains(teamId));
        _calendarCache.remove(teamId);
        AppLogger.info('Team deleted successfully');
      } else {
        throw Exception('Failed to delete team: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error deleting team', error: e);
      rethrow;
    }
  }

  Future<Team> getTeamMembers(String teamId) async {
    try {
      final url = fetchTeamMembersUrl(teamId);
      final response = await SecureHttpClient.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Team.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load team members: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error loading team members', error: e);
      rethrow;
    }
  }

  Future<void> removeMember(String teamId, String userId) async {
    try {
      final url = removeMemberUrl(teamId, userId);
      final response = await SecureHttpClient.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        AppLogger.info('Member removed successfully');
      } else {
        throw Exception('Failed to remove member: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error removing member', error: e);
      rethrow;
    }
  }

  Future<List<Post>> getTeamPosts(String teamId) async {
    try {
      final cacheKey = 'posts_$teamId';
      if (_postsCache.containsKey(cacheKey)) {
        AppLogger.performance('Using cached posts for team $teamId');
        return _postsCache[cacheKey]!;
      }

      final url = fetchTeamPostsUrl(teamId);
      final response = await SecureHttpClient.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final posts =
            (jsonResponse as List).map((post) => Post.fromJson(post)).toList();
        _postsCache[cacheKey] = posts;
        return posts;
      } else {
        throw Exception('Failed to load team posts: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error loading team posts', error: e);
      rethrow;
    }
  }

  Future<List<String>> getTeamPhotos(String teamId) async {
    try {
      final url = fetchTeamPhotosUrl(teamId);
      final response = await SecureHttpClient.get(Uri.parse(url));

      if (response.statusCode == 200) {
        AppLogger.network('Photos response received for team $teamId');
        return (jsonDecode(response.body) as List)
            .map((photo) => photo['photo'] as String)
            .toList();
      } else {
        throw Exception('Failed to load team photos: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error loading team photos', error: e);
      rethrow;
    }
  }

  Future<void> addPhotoToGallery(String teamId, String photoUrl) async {
    try {
      final url = postTeamPhotosUrl(teamId);
      final response = await SecureHttpClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'photo': photoUrl}),
      );

      if (response.statusCode == 200) {
        AppLogger.info('Photo added to gallery successfully');
      } else {
        throw Exception(
          'Failed to add photo to gallery: ${response.statusCode}',
        );
      }
    } catch (e) {
      AppLogger.error('Error adding photo to gallery', error: e);
      rethrow;
    }
  }

  Future<List<TeamCalendar>> getTeamCalendar(String teamId) async {
    try {
      if (_calendarCache.containsKey(teamId)) {
        AppLogger.performance('Using cached calendar for team $teamId');
        return _calendarCache[teamId]!;
      }

      final url = fetchTeamCalendarUrl(teamId);
      final response = await SecureHttpClient.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final events =
            (jsonResponse as List)
                .map((event) => TeamCalendar.fromJson(event))
                .toList();
        _calendarCache[teamId] = events;
        return events;
      } else {
        throw Exception('Failed to load team calendar: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error loading team calendar', error: e);
      rethrow;
    }
  }

  Future<void> addTeamCalendarEvent(String teamId, TeamCalendar event) async {
    try {
      final url = postTeamCalendarEventUrl(teamId);
      final response = await SecureHttpClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(event.toJson()),
      );

      if (response.statusCode == 200) {
        // Clear calendar cache since we added a new event
        _calendarCache.remove(teamId);
        AppLogger.info('Calendar event added successfully');
      } else {
        throw Exception('Failed to add calendar event: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error adding calendar event', error: e);
      rethrow;
    }
  }

  Future<String> acceptTeamCalendarEvent(String eventId) async {
    try {
      final userId = await userRepository.getId();
      final url = acceptTeamCalendarEventUrl(eventId, userId);
      final response = await SecureHttpClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'eventId': eventId, 'userId': userId}),
      );

      if (response.statusCode == 200) {
        // Clear calendar cache since event status changed
        _calendarCache.clear();
        return userId;
      } else {
        throw Exception(
          'Failed to accept calendar event: ${response.statusCode}',
        );
      }
    } catch (e) {
      AppLogger.error('Error accepting calendar event', error: e);
      rethrow;
    }
  }

  Future<String> declineTeamCalendarEvent(String eventId) async {
    try {
      final userId = await userRepository.getId();
      final url = declineTeamCalendarEventUrl(eventId, userId);
      final response = await SecureHttpClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'eventId': eventId, 'userId': userId}),
      );

      if (response.statusCode == 200) {
        // Clear calendar cache since event status changed
        _calendarCache.clear();
        return userId;
      } else {
        throw Exception(
          'Failed to decline calendar event: ${response.statusCode}',
        );
      }
    } catch (e) {
      AppLogger.error('Error declining calendar event', error: e);
      rethrow;
    }
  }

  Future<void> addPost(Post post, String teamId) async {
    try {
      final userId = await userRepository.getId();
      final url = addTeamPostUrl(teamId);
      final response = await SecureHttpClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({...post.toJson(), 'userId': userId}),
      );

      if (response.statusCode == 200) {
        // Clear posts cache since we added a new post
        _postsCache.removeWhere((key, value) => key.contains(teamId));
        AppLogger.info('Post added successfully');
      } else {
        throw Exception('Failed to add post: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error adding post', error: e);
      rethrow;
    }
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      final url = likePostUrl(postId, userId);
      final response = await SecureHttpClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'postId': postId, 'userId': userId}),
      );

      if (response.statusCode == 200) {
        AppLogger.info('Post liked successfully');
      } else {
        throw Exception('Failed to like post: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error liking post', error: e);
      rethrow;
    }
  }

  Future<List<Comment>> getCommentsForPost(String postId) async {
    try {
      final url = getCommentsUrl(postId);
      final response = await SecureHttpClient.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return (jsonResponse as List)
            .map((comment) => Comment.fromJson(comment))
            .toList();
      } else {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error loading comments', error: e);
      rethrow;
    }
  }

  Future<Post> addComment(String postId, Comment comment, String userId) async {
    try {
      final url = addCommentUrl(postId);
      final response = await SecureHttpClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({...comment.toJson(), 'userId': userId}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final postData = jsonResponse['post'] as Map<String, dynamic>;
        AppLogger.info('Comment added successfully');
        return Post.fromJson(postData);
      } else {
        AppLogger.warning('Failed to add comment: ${response.body}');
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.error('Error adding comment', error: e);
      rethrow;
    }
  }

  Future<bool> likeComment(
    String postId,
    String commentId,
    String userId,
  ) async {
    try {
      final url = likeCommentUrl(postId, commentId, userId);
      final response = await SecureHttpClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'postId': postId,
          'commentId': commentId,
          'userId': userId,
        }),
      );

      final success = response.statusCode == 200;
      if (success) {
        AppLogger.info('Comment liked successfully');
      } else {
        AppLogger.warning('Failed to like comment: ${response.statusCode}');
      }
      return success;
    } catch (e) {
      AppLogger.error('Error liking comment', error: e);
      return false;
    }
  }

  /// Clear all caches - useful for logout or refresh
  void clearCache() {
    _teamsCache.clear();
    _postsCache.clear();
    _calendarCache.clear();
    AppLogger.info('Repository cache cleared');
  }
}
