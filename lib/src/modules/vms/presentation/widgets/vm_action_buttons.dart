import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/utils.dart';

class VmActionButtons extends StatelessWidget {
  final String state;
  final bool isLoading;
  final String? currentAction;
  final Function() onStart;
  final Function() onReboot;
  final Function() onShutdown;
  final bool isTablet;

  const VmActionButtons({
    super.key,
    required this.state,
    required this.isLoading,
    this.currentAction,
    required this.onStart,
    required this.onReboot,
    required this.onShutdown,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRunning = state.toLowerCase() == 'running';
    final bool isStopped = state.toLowerCase() == 'stopped';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: Icons.play_arrow,
          label: 'Start',
          color: Colors.green,
          isActive: isStopped,
          isLoading: isLoading && currentAction == 'start',
          onPressed: isStopped && !isLoading ? onStart : null,
          isTablet: isTablet,
          context: context,
        ),
        SizedBox(width: ResponsiveHelper.w(16, context)),
        _buildActionButton(
          icon: Icons.refresh,
          label: 'Reboot',
          color: Colors.blue,
          isActive: isRunning,
          isLoading: isLoading && currentAction == 'reboot',
          onPressed: isRunning && !isLoading ? onReboot : null,
          isTablet: isTablet,
          context: context,
        ),
        SizedBox(width: ResponsiveHelper.w(16, context)),
        _buildActionButton(
          icon: Icons.power_settings_new,
          label: 'Shutdown',
          color: Colors.red,
          isActive: isRunning,
          isLoading: isLoading && currentAction == 'shutdown',
          onPressed: isRunning && !isLoading ? onShutdown : null,
          isTablet: isTablet,
          context: context,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isActive,
    required bool isLoading,
    required Function()? onPressed,
    required bool isTablet,
    required BuildContext context,
  }) {
    final buttonColor = isActive ? color : Colors.grey;

    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor.withValues(alpha: 26),
            foregroundColor: buttonColor,
            padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
            shape: const CircleBorder(),
          ),
          child: isLoading
              ? SizedBox(
                  width: ResponsiveHelper.w(24, context),
                  height: ResponsiveHelper.h(24, context),
                  child: CircularProgressIndicator(
                    color: buttonColor,
                    strokeWidth: 2,
                  ),
                )
              : Icon(
                  icon,
                  size: isTablet
                      ? ResponsiveHelper.sp(28, context)
                      : ResponsiveHelper.sp(24, context),
                ),
        ),
        SizedBox(height: ResponsiveHelper.h(4, context)),
        Text(
          label,
          style: TextStyle(
            color: isActive ? buttonColor : Colors.grey,
            fontSize: isTablet
                ? ResponsiveHelper.sp(14, context)
                : ResponsiveHelper.sp(12, context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
