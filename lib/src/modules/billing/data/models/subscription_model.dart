import 'package:equatable/equatable.dart';

class SubscriptionModel extends Equatable {
  final String id;
  final String name;
  final String status;
  final int billingPeriod;
  final String billingPeriodUnit;
  final String currencyCode;
  final int totalPrice;
  final int renewalPrice;
  final bool isAutoRenewed;
  final String createdAt;
  final String? expiresAt;
  final String? nextBillingAt;

  const SubscriptionModel({
    required this.id,
    required this.name,
    required this.status,
    required this.billingPeriod,
    required this.billingPeriodUnit,
    required this.currencyCode,
    required this.totalPrice,
    required this.renewalPrice,
    required this.isAutoRenewed,
    required this.createdAt,
    this.expiresAt,
    this.nextBillingAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      billingPeriod: json['billing_period'] as int,
      billingPeriodUnit: json['billing_period_unit'] as String,
      currencyCode: json['currency_code'] as String,
      totalPrice: json['total_price'] as int,
      renewalPrice: json['renewal_price'] as int,
      isAutoRenewed: json['is_auto_renewed'] as bool,
      createdAt: json['created_at'] as String,
      expiresAt: json['expires_at'] as String?,
      nextBillingAt: json['next_billing_at'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    status,
    billingPeriod,
    billingPeriodUnit,
    currencyCode,
    totalPrice,
    renewalPrice,
    isAutoRenewed,
    createdAt,
    expiresAt,
    nextBillingAt,
  ];
}
