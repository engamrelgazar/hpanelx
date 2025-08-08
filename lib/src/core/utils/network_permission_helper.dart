import 'dart:io';
import 'package:flutter/material.dart';

class NetworkPermissionHelper {
  static Future<bool> isNetworkPermissionGranted() async {
    try {
      if (Platform.isIOS) {
        return await _checkNetworkConnectivity();
      } else if (Platform.isAndroid) {
        return true;
      }
      return true;
    } catch (e) {
      debugPrint('Error checking network permission: $e');
      return false;
    }
  }

  static Future<bool> requestNetworkPermission() async {
    try {
      if (Platform.isIOS) {
        final hasConnectivity = await _checkNetworkConnectivity();
        if (!hasConnectivity) {
          return false;
        }
        return true;
      } else if (Platform.isAndroid) {
        return true;
      }
      return true;
    } catch (e) {
      debugPrint('Error requesting network permission: $e');
      return false;
    }
  }

  static Future<bool> _checkNetworkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }

  static Future<bool> showNetworkPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Internet Connection Required'),
              content: const Text(
                'This app requires an internet connection to manage your hosting services, domains, and virtual machines. Please ensure you have a stable internet connection.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Continue'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  static Future<void> showNetworkSettingsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Network Settings'),
          content: const Text(
            'Please check your network settings and ensure you have an active internet connection. You can also try:\n\n'
            '• Turning WiFi off and on\n'
            '• Switching between WiFi and mobile data\n'
            '• Restarting your device\n'
            '• Checking if other apps can access the internet',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> initializeNetworkPermissions(BuildContext context) async {
    try {
      final hasPermission = await isNetworkPermissionGranted();

      if (!hasPermission) {
        if (!context.mounted) return;

        final shouldContinue = await showNetworkPermissionDialog(context);

        if (!shouldContinue) {
          if (!context.mounted) return;

          await showNetworkSettingsDialog(context);
        }
      }
    } catch (e) {
      debugPrint('Error initializing network permissions: $e');
    }
  }
}
