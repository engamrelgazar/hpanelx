class DomainAvailabilityModel {
  final String domain;
  final bool isAvailable;
  final bool isAlternative;
  final String? restriction;
  final double? price;
  final String? currency;

  DomainAvailabilityModel({
    required this.domain,
    required this.isAvailable,
    required this.isAlternative,
    this.restriction,
    this.price,
    this.currency,
  });

  factory DomainAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return DomainAvailabilityModel(
      domain: json['domain'] ?? '',
      isAvailable: json['is_available'] ?? false,
      isAlternative: json['is_alternative'] ?? false,
      restriction: json['restriction'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      currency: json['currency'],
    );
  }
}
