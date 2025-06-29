import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final SharedPreferences prefs = GetIt.I<SharedPreferences>();

Future<void> saveLocationToPrefs(String location, String address) async {
  final prefs = GetIt.I<SharedPreferences>();
  const key = 'saved_locations';
  List<Map<String, String>> locations = [];

  final existing = prefs.getString(key);
  if (existing != null) {
    locations = List<Map<String, String>>.from(
      (json.decode(existing) as List).map(
        (e) => Map<String, String>.from(e as Map),
      ),
    );
  }

  // Remove any existing entry with the same location name
  locations.removeWhere((loc) => loc['location'] == location);

  // Add the new/updated location
  locations.add({'location': location, 'address': address});
  await prefs.setString(key, json.encode(locations));
}

Future<List<Map<String, String>>> getSavedLocations() async {
  final prefs = GetIt.I<SharedPreferences>();
  const key = 'saved_locations';
  final existing = prefs.getString(key);
  if (existing != null) {
    return List<Map<String, String>>.from(
      (json.decode(existing) as List).map(
        (e) => Map<String, String>.from(e as Map),
      ),
    );
  }
  return [];
}

Future<void> clearSavedLocations() async {
  final prefs = GetIt.I<SharedPreferences>();
  await prefs.remove('saved_locations');
}
