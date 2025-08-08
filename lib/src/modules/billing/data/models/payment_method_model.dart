import 'package:equatable/equatable.dart';

class PaymentMethodModel extends Equatable {
  final int id;
  final String name;
  final String identifier;
  final String paymentMethod;
  final bool isDefault;
  final bool isExpired;
  final bool isSuspended;
  final String createdAt;
  final String? expiresAt;

  const PaymentMethodModel({
    required this.id,
    required this.name,
    required this.identifier,
    required this.paymentMethod,
    required this.isDefault,
    required this.isExpired,
    required this.isSuspended,
    required this.createdAt,
    this.expiresAt,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as int,
      name: json['name'] as String,
      identifier: json['identifier'] as String,
      paymentMethod: json['payment_method'] as String,
      isDefault: json['is_default'] as bool,
      isExpired: json['is_expired'] as bool,
      isSuspended: json['is_suspended'] as bool,
      createdAt: json['created_at'] as String,
      expiresAt: json['expires_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'identifier': identifier,
      'payment_method': paymentMethod,
      'is_default': isDefault,
      'is_expired': isExpired,
      'is_suspended': isSuspended,
      'created_at': createdAt,
      'expires_at': expiresAt,
    };
  }

  PaymentMethodModel copyWith({
    int? id,
    String? name,
    String? identifier,
    String? paymentMethod,
    bool? isDefault,
    bool? isExpired,
    bool? isSuspended,
    String? createdAt,
    String? expiresAt,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      identifier: identifier ?? this.identifier,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isDefault: isDefault ?? this.isDefault,
      isExpired: isExpired ?? this.isExpired,
      isSuspended: isSuspended ?? this.isSuspended,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  String get status {
    if (isSuspended) return 'suspended';
    if (isExpired) return 'expired';
    return 'active';
  }

  String? get last4 {
    if (paymentMethod == 'card' && identifier.contains('*')) {
      final parts = identifier.split('*');
      if (parts.length > 1) {
        return parts.last;
      }
    }
    return null;
  }

  String? get brand {
    if (paymentMethod == 'card') {
      final cardNumber = identifier.replaceAll('*', '');
      if (cardNumber.startsWith('4')) return 'visa';
      if (cardNumber.startsWith('5')) return 'mastercard';
      if (cardNumber.startsWith('3')) return 'amex';
    }
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        identifier,
        paymentMethod,
        isDefault,
        isExpired,
        isSuspended,
        createdAt,
        expiresAt,
      ];
}
