import 'package:intl/intl.dart';

class DomainModel {
  final int id;
  final String domain;
  final String type;
  final String status;
  final DateTime createdAt;
  final DateTime expiresAt;

  DomainModel({
    required this.id,
    required this.domain,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
  });

  factory DomainModel.fromJson(Map<String, dynamic> json) {
    return DomainModel(
      id: json['id'],
      domain: json['domain'],
      type: json['type'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }

  bool get isActive => status == 'active';

  // Get formatted dates for display
  String get formattedCreatedDate =>
      DateFormat('MMM d, yyyy').format(createdAt);
  String get formattedExpiryDate => DateFormat('MMM d, yyyy').format(expiresAt);

  // Calculate days until expiry
  int get daysUntilExpiry {
    final now = DateTime.now();
    return expiresAt.difference(now).inDays;
  }

  // Get expiry status
  String get expiryStatus {
    final days = daysUntilExpiry;
    if (days < 0) return 'Expired';
    if (days < 30) return 'Expiring soon';
    return 'Active';
  }
}
