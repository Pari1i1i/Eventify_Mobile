import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class LocalCacheService {
  final SharedPreferences _prefs;

  LocalCacheService(this._prefs);

  static Future<LocalCacheService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalCacheService(prefs);
  }

  // Save/Get custom API Base URL
  Future<void> saveBaseUrl(String url) async {
    await _prefs.setString(ApiConstants.customBaseUrlKey, url);
  }

  String getBaseUrl() {
    return _prefs.getString(ApiConstants.customBaseUrlKey) ?? ApiConstants.defaultBaseUrl;
  }

  // Save/Get User JSON
  Future<void> saveUserData(Map<String, dynamic> userMap) async {
    await _prefs.setString(ApiConstants.userKey, jsonEncode(userMap));
  }

  Map<String, dynamic>? getUserData() {
    final raw = _prefs.getString(ApiConstants.userKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> clearUserData() async {
    await _prefs.remove(ApiConstants.userKey);
  }

  // Ticket Offline Caching
  Future<void> cacheTickets(List<Map<String, dynamic>> tickets) async {
    await _prefs.setString(ApiConstants.cachedTicketsKey, jsonEncode(tickets));
  }

  List<Map<String, dynamic>> getCachedTickets() {
    final raw = _prefs.getString(ApiConstants.cachedTicketsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  // Event Offline Caching
  Future<void> cacheEvents(List<Map<String, dynamic>> events) async {
    await _prefs.setString(ApiConstants.cachedEventsKey, jsonEncode(events));
  }

  List<Map<String, dynamic>> getCachedEvents() {
    final raw = _prefs.getString(ApiConstants.cachedEventsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> clearAllCache() async {
    await _prefs.remove(ApiConstants.userKey);
    await _prefs.remove(ApiConstants.cachedTicketsKey);
    await _prefs.remove(ApiConstants.cachedEventsKey);
  }
}
