import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:hpanelx/src/core/widgets/widgets.dart';
import 'package:hpanelx/src/modules/billing/data/models/subscription_model.dart';
import 'package:intl/intl.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionModel subscription;
  final VoidCallback onTap;
  final bool isTablet;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.onTap,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16, context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      subscription.name,
                      style: TextStyle(
                        fontSize:
                            isTablet
                                ? ResponsiveHelper.sp(18, context)
                                : ResponsiveHelper.sp(16, context),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusBadge(status: subscription.status, isTablet: isTablet),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(16, context)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoItem(
                          icon: Icons.attach_money,
                          text: _formatPrice(
                            subscription.totalPrice,
                            subscription.currencyCode,
                          ),
                          label: 'Total Price',
                          isTablet: isTablet,
                        ),
                        SizedBox(height: ResponsiveHelper.h(8, context)),
                        InfoItem(
                          icon: Icons.autorenew,
                          text:
                              subscription.isAutoRenewed
                                  ? 'Auto-renewal on'
                                  : 'Auto-renewal off',
                          label: 'Renewal',
                          isTablet: isTablet,
                          iconColor:
                              subscription.isAutoRenewed
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(12, context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoItem(
                          icon: Icons.refresh,
                          text: _formatBillingPeriod(
                            subscription.billingPeriod,
                            subscription.billingPeriodUnit,
                          ),
                          label: 'Billing Period',
                          isTablet: isTablet,
                        ),
                        SizedBox(height: ResponsiveHelper.h(8, context)),
                        if (subscription.nextBillingAt != null)
                          InfoItem(
                            icon: Icons.calendar_today,
                            text: _formatDate(subscription.nextBillingAt!),
                            label: 'Next Billing',
                            isTablet: isTablet,
                          )
                        else if (subscription.expiresAt != null)
                          InfoItem(
                            icon: Icons.event_busy,
                            text: _formatDate(subscription.expiresAt!),
                            label: 'Expires',
                            isTablet: isTablet,
                            iconColor: Colors.orange,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(int price, String currencyCode) {
    final double amount = price / 100;
    NumberFormat formatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(currencyCode),
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      default:
        return currencyCode;
    }
  }

  String _formatBillingPeriod(int period, String unit) {
    final unitSingular = unit.toLowerCase();
    final unitPlural =
        unitSingular.endsWith('s') ? unitSingular : '${unitSingular}s';
    return period == 1
        ? '$period ${_capitalize(unitSingular)}'
        : '$period ${_capitalize(unitPlural)}';
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return isoDate;
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
