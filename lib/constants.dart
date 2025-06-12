/// Base URL for the backend server
const String baseUrl = 'http://localhost:8000/api';

// Auth endpoints
const String loginUrl = '$baseUrl/auth/login';
const String registerUrl = '$baseUrl/auth/register';
const String finishSetupUrl = '$baseUrl/auth/finish-setup';

// Team endpoints
const String createTeamUrl = '$baseUrl/teams';
const String teamsUrl = '$baseUrl/teams';
String teamDetailUrl(String id) => '$baseUrl/teams/$id';
String fetchTeamUrl(String id) => '$baseUrl/teams/$id';
String deleteTeamUrl(String teamId) => '$baseUrl/teams/$teamId';

// User endpoints
const String usersUrl = '$baseUrl/users';
String getUserUrl(String id) => '$baseUrl/users/$id';
String userDetailUrl(String id) => '$baseUrl/users/$id';
String updateUserUrl(String id) => '$baseUrl/users/$id/update';

// Notification endpoints
const String notificationsUrl = '$baseUrl/notifications';
String notificationDetailUrl(String id) => '$baseUrl/notifications/$id';
String fetchNotificationUrl(String id) => '$baseUrl/notifications/$id';
