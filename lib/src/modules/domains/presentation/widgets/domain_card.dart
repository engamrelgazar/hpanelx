import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:hpanelx/src/modules/domains/data/models/domain_model.dart';

class DomainCard extends StatelessWidget {
  final DomainModel domain;
  final bool isTablet;

  const DomainCard({super.key, required this.domain, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final double fontSize = isTablet
        ? ResponsiveHelper.sp(16, context)
        : ResponsiveHelper.sp(14, context);
    final double titleSize = isTablet
        ? ResponsiveHelper.sp(18, context)
        : ResponsiveHelper.sp(16, context);
    final double iconSize = isTablet
        ? ResponsiveHelper.sp(22, context)
        : ResponsiveHelper.sp(20, context);
    final double padding = isTablet
        ? ResponsiveHelper.w(20, context)
        : ResponsiveHelper.w(16, context);

    Color statusColor;
    IconData statusIcon;

    // Set status color and icon
    if (domain.status == 'active') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (domain.status == 'pending') {
      statusColor = Colors.orange;
      statusIcon = Icons.hourglass_top;
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.error;
    }

    // Calculate expiry status
    final expiryColor = domain.daysUntilExpiry < 30
        ? Colors.orange
        : domain.daysUntilExpiry < 0
            ? Colors.red
            : Colors.green;

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16, context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    domain.domain,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(8, context),
                    vertical: ResponsiveHelper.h(4, context),
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(26), // 0.1 opacity = 26 alpha
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.r(8, context),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: iconSize),
                      SizedBox(width: ResponsiveHelper.w(4, context)),
                      Text(
                        domain.status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: fontSize * 0.8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(16, context)),
            _buildInfoRow(
              context,
              'Creation Date',
              domain.formattedCreatedDate,
              Icons.calendar_today,
              fontSize,
              iconSize,
            ),
            SizedBox(height: ResponsiveHelper.h(8, context)),
            _buildInfoRow(
              context,
              'Expires In',
              '${domain.daysUntilExpiry} days (${domain.formattedExpiryDate})',
              Icons.timer,
              fontSize,
              iconSize,
              valueColor: expiryColor,
            ),
            SizedBox(height: ResponsiveHelper.h(8, context)),
            _buildInfoRow(
              context,
              'Type',
              domain.type.toUpperCase(),
              Icons.label,
              fontSize,
              iconSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    double fontSize,
    double iconSize, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon,
            size: iconSize,
            color: Theme.of(context).textTheme.bodyMedium?.color),
        SizedBox(width: ResponsiveHelper.w(8, context)),
        Text(
          '$label: ',
          style: TextStyle(
              fontSize: fontSize,
              color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
