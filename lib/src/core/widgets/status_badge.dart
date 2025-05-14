import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isTablet;
  final Map<String, StatusConfig>? statusConfigs;

  const StatusBadge({
    super.key,
    required this.status,
    required this.isTablet,
    this.statusConfigs,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(10, context),
        vertical: ResponsiveHelper.h(4, context),
      ),
      decoration: BoxDecoration(
        color: config.badgeColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(16, context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size:
                isTablet
                    ? ResponsiveHelper.responsiveIconSize(context, 16)
                    : ResponsiveHelper.responsiveIconSize(context, 14),
            color: config.textColor,
          ),
          SizedBox(width: ResponsiveHelper.w(4, context)),
          Text(
            _formatStatus(status),
            style: TextStyle(
              color: config.textColor,
              fontSize:
                  isTablet
                      ? ResponsiveHelper.responsiveFontSize(context, 14)
                      : ResponsiveHelper.responsiveFontSize(context, 12),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  StatusConfig _getStatusConfig() {
    if (statusConfigs != null &&
        statusConfigs!.containsKey(status.toLowerCase())) {
      return statusConfigs![status.toLowerCase()]!;
    }

    // Default configurations for common statuses
    switch (status.toLowerCase()) {
      case 'active':
      case 'running':
        return StatusConfig(
          badgeColor: Colors.green.withValues(
            alpha: (Colors.green.a * 0.1).toDouble(),
            red: Colors.green.r.toDouble(),
            green: Colors.green.g.toDouble(),
            blue: Colors.green.b.toDouble(),
          ),
          textColor: Colors.green[700]!,
          icon: Icons.check_circle,
        );
      case 'non_renewing':
      case 'pending':
      case 'restarting':
        return StatusConfig(
          badgeColor: Colors.orange.withValues(
            alpha: (Colors.orange.a * 0.1).toDouble(),
            red: Colors.orange.r.toDouble(),
            green: Colors.orange.g.toDouble(),
            blue: Colors.orange.b.toDouble(),
          ),
          textColor: Colors.orange[700]!,
          icon: Icons.update_disabled,
        );
      case 'cancelled':
      case 'stopped':
        return StatusConfig(
          badgeColor: Colors.red.withValues(
            alpha: (Colors.red.a * 0.1).toDouble(),
            red: Colors.red.r.toDouble(),
            green: Colors.red.g.toDouble(),
            blue: Colors.red.b.toDouble(),
          ),
          textColor: Colors.red[700]!,
          icon: Icons.cancel,
        );
      case 'suspended':
        return StatusConfig(
          badgeColor: Colors.grey.withValues(
            alpha: (Colors.grey.a * 0.1).toDouble(),
            red: Colors.grey.r.toDouble(),
            green: Colors.grey.g.toDouble(),
            blue: Colors.grey.b.toDouble(),
          ),
          textColor: Colors.grey[700]!,
          icon: Icons.pause_circle_filled,
        );
      default:
        return StatusConfig(
          badgeColor: Colors.blue.withValues(
            alpha: (Colors.blue.a * 0.1).toDouble(),
            red: Colors.blue.r.toDouble(),
            green: Colors.blue.g.toDouble(),
            blue: Colors.blue.b.toDouble(),
          ),
          textColor: Colors.blue[700]!,
          icon: Icons.info,
        );
    }
  }

  String _formatStatus(String status) {
    if (status.toLowerCase() == 'non_renewing') {
      return 'Non-Renewing';
    }

    return status
        .split('_')
        .map(
          (word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '',
        )
        .join(' ');
  }
}

class StatusConfig {
  final Color badgeColor;
  final Color textColor;
  final IconData icon;

  StatusConfig({
    required this.badgeColor,
    required this.textColor,
    required this.icon,
  });
}
