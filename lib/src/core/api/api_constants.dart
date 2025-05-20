import 'package:flutter/foundation.dart';

/// Environment configurations
enum Environment {
  development,
  staging,
  production,
}

/// Constants for API endpoints and configuration
class ApiConstants {
  // Current environment
  static Environment environment = Environment.development;

  // Base URLs for different environments
  static const Map<Environment, String> _baseUrls = {
    Environment.development: 'https://dev.api.hostinger.com',
    Environment.staging: 'https://staging.api.hostinger.com',
    Environment.production: 'https://developers.hostinger.com',
  };

  /// Get the appropriate base URL for the current environment
  static String get baseUrl => _baseUrls[environment]!;

  // API Endpoints
  static const String domainsEndpoint = '/api/domains/v1/portfolio';
  static const String serversEndpoint = '/api/vps/v1/virtual-machines';
  static const String domainAvailabilityEndpoint =
      '/api/domains/v1/availability';
  static const String whoisEndpoint = '/api/domains/v1/whois';
  static const String subscriptionsEndpoint = '/api/billing/v1/subscriptions';

  // Request timeouts in seconds
  static const int connectTimeout = 15;
  static const int receiveTimeout = 15;

  /// Set the current environment
  static void setEnvironment(Environment env) {
    environment = env;
    if (kDebugMode) {
      print('API Environment set to: ${environment.name}');
    }
  }

  /// Full endpoint URLs
  static String get domainsUrl => '$baseUrl$domainsEndpoint';
  static String get serversUrl => '$baseUrl$serversEndpoint';
  static String get domainAvailabilityUrl =>
      '$baseUrl$domainAvailabilityEndpoint';
  static String get whoisUrl => '$baseUrl$whoisEndpoint';
  static String get subscriptionsUrl => '$baseUrl$subscriptionsEndpoint';
}
