class ApiConstants {
  // Base URL - Should be configured based on environment
  static const String baseUrl =
      'https://developers.hostinger.com'; // Example base URL

  // API Endpoints
  static const String domainsEndpoint = '/api/domains/v1/portfolio';
  static const String serversEndpoint = '/api/vps/v1/virtual-machines';
  static const String domainAvailabilityEndpoint =
      '/api/domains/v1/availability';
  static const String whoisEndpoint = '/api/domains/v1/whois';

  // Full URLs
  static String get domainsUrl => '$baseUrl$domainsEndpoint';
  static String get serversUrl => '$baseUrl$serversEndpoint';
  static String get domainAvailabilityUrl =>
      '$baseUrl$domainAvailabilityEndpoint';
  static String get whoisUrl => '$baseUrl$whoisEndpoint';
}
