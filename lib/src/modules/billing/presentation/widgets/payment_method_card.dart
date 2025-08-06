import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:hpanelx/src/modules/billing/data/models/payment_method_model.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodModel paymentMethod;
  final bool isTablet;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;
  final bool isDeleting;
  final bool isSettingDefault;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
    required this.isTablet,
    this.onDelete,
    this.onSetDefault,
    this.isDeleting = false,
    this.isSettingDefault = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12, context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with card info and actions
            Row(
              children: [
                // Card icon
                Container(
                  padding: EdgeInsets.all(ResponsiveHelper.w(8, context)),
                  decoration: BoxDecoration(
                    color: _getCardColor(paymentMethod.brand)
                        .withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(ResponsiveHelper.r(8, context)),
                  ),
                  child: Icon(
                    _getCardIcon(paymentMethod.paymentMethod),
                    color: _getCardColor(paymentMethod.brand),
                    size: ResponsiveHelper.responsiveIconSize(context, 24),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(12, context)),

                // Card details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _getDisplayName(),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(16, context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (paymentMethod.isDefault) ...[
                            SizedBox(width: ResponsiveHelper.w(8, context)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.w(8, context),
                                vertical: ResponsiveHelper.h(2, context),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.r(4, context)),
                              ),
                              child: Text(
                                'Default',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.sp(10, context),
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.h(4, context)),
                      Text(
                        _getSubtitle(),
                        style: TextStyle(
                          fontSize: ResponsiveHelper.sp(14, context),
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Set Default button (only show if not already default)
                    if (!paymentMethod.isDefault && onSetDefault != null)
                      IconButton(
                        onPressed: isSettingDefault ? null : onSetDefault,
                        icon: isSettingDefault
                            ? SizedBox(
                                width: ResponsiveHelper.w(20, context),
                                height: ResponsiveHelper.h(20, context),
                                child: const CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                            : Icon(
                                Icons.star_border,
                                color: Colors.amber,
                                size: ResponsiveHelper.responsiveIconSize(
                                    context, 20),
                              ),
                        tooltip: 'Set as Default',
                      ),

                    // Delete button
                    if (onDelete != null)
                      IconButton(
                        onPressed: isDeleting ? null : onDelete,
                        icon: isDeleting
                            ? SizedBox(
                                width: ResponsiveHelper.w(20, context),
                                height: ResponsiveHelper.h(20, context),
                                child: const CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                            : Icon(
                                Icons.delete_outline,
                                color: Theme.of(context).colorScheme.error,
                                size: ResponsiveHelper.responsiveIconSize(
                                    context, 20),
                              ),
                        tooltip: 'Delete',
                      ),
                  ],
                ),
              ],
            ),

            // Status
            SizedBox(height: ResponsiveHelper.h(12, context)),
            Row(
              children: [
                Container(
                  width: ResponsiveHelper.w(8, context),
                  height: ResponsiveHelper.h(8, context),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.w(8, context)),
                Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(12, context),
                    color: _getStatusColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  'Added ${_formatDate(paymentMethod.createdAt)}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(12, context),
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayName() {
    if (paymentMethod.paymentMethod.toLowerCase() == 'card') {
      return '${paymentMethod.brand?.toUpperCase() ?? 'Card'} •••• ${paymentMethod.last4 ?? '****'}';
    }
    return paymentMethod.name;
  }

  String _getSubtitle() {
    if (paymentMethod.paymentMethod.toLowerCase() == 'card') {
      return paymentMethod.identifier;
    }
    return paymentMethod.identifier;
  }

  IconData _getCardIcon(String type) {
    switch (type.toLowerCase()) {
      case 'card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.account_balance_wallet;
      case 'bank':
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }

  Color _getCardColor(String? brand) {
    if (brand == null) return Colors.blue;

    switch (brand.toLowerCase()) {
      case 'visa':
        return Colors.blue;
      case 'mastercard':
        return Colors.orange;
      case 'amex':
      case 'american express':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  Color _getStatusColor() {
    switch (paymentMethod.status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'expired':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    return paymentMethod.status.toUpperCase();
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays < 1) {
        return 'Today';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        return '${(difference.inDays / 7).floor()} weeks ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
