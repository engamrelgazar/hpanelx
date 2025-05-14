class DomainModel {
  final int id;
  final String domain;
  final String type;
  final String status;
  final String createdAt;
  final String expiresAt;

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
      createdAt: json['created_at'],
      expiresAt: json['expires_at'],
    );
  }

  bool get isActive => status == 'active';
}
