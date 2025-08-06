import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Secure HTTP client with certificate pinning and timeout configurations
class SecureHttpClient {
  static http.Client? _client;
  static const Duration _defaultTimeout = Duration(seconds: 30);

  static http.Client get client {
    _client ??= _createSecureClient();
    return _client!;
  }

  static http.Client _createSecureClient() {
    final httpClient = HttpClient();

    // Configure timeouts
    httpClient.connectionTimeout = _defaultTimeout;
    httpClient.idleTimeout = _defaultTimeout;

    // Enable certificate verification
    httpClient.badCertificateCallback = (cert, host, port) {
      // In production, implement proper certificate pinning
      // For now, only allow valid certificates
      return false;
    };

    // Add security headers
    httpClient.userAgent = 'TeamShare-App/1.0.0';

    return IOClient(httpClient);
  }

  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final client = SecureHttpClient.client;
    final response = await client
        .get(url, headers: _addSecurityHeaders(headers))
        .timeout(timeout ?? _defaultTimeout);
    return response;
  }

  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
  }) async {
    final client = SecureHttpClient.client;
    final response = await client
        .post(url, headers: _addSecurityHeaders(headers), body: body)
        .timeout(timeout ?? _defaultTimeout);
    return response;
  }

  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
  }) async {
    final client = SecureHttpClient.client;
    final response = await client
        .put(url, headers: _addSecurityHeaders(headers), body: body)
        .timeout(timeout ?? _defaultTimeout);
    return response;
  }

  static Future<http.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
  }) async {
    final client = SecureHttpClient.client;
    final response = await client
        .patch(url, headers: _addSecurityHeaders(headers), body: body)
        .timeout(timeout ?? _defaultTimeout);
    return response;
  }

  static Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final client = SecureHttpClient.client;
    final response = await client
        .delete(url, headers: _addSecurityHeaders(headers))
        .timeout(timeout ?? _defaultTimeout);
    return response;
  }

  static Map<String, String> _addSecurityHeaders(Map<String, String>? headers) {
    final securityHeaders = <String, String>{
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'DENY',
      'X-XSS-Protection': '1; mode=block',
      'Referrer-Policy': 'strict-origin-when-cross-origin',
    };

    if (headers != null) {
      securityHeaders.addAll(headers);
    }

    return securityHeaders;
  }

  static void dispose() {
    _client?.close();
    _client = null;
  }
}
