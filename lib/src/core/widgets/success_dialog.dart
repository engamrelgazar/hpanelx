import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:lottie/lottie.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final bool showAnimation;
  final String? animationAsset;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.showAnimation = true,
    this.animationAsset,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onButtonPressed,
    bool showAnimation = true,
    String? animationAsset,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => SuccessDialog(
            title: title,
            message: message,
            buttonText: buttonText ?? 'OK',
            onButtonPressed: onButtonPressed ?? () => Navigator.pop(context),
            showAnimation: showAnimation,
            animationAsset: animationAsset,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(16, context)),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(20, context)),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(ResponsiveHelper.r(16, context)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showAnimation) ...[
              Lottie.asset(
                animationAsset ?? 'assets/animations/success.json',
                width: ResponsiveHelper.w(isTablet ? 120 : 100, context),
                height: ResponsiveHelper.h(isTablet ? 120 : 100, context),
                repeat: false,
              ),
              SizedBox(height: ResponsiveHelper.h(12, context)),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(isTablet ? 22 : 20, context),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveHelper.h(16, context)),
            Text(
              message,
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(isTablet ? 16 : 14, context),
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveHelper.h(24, context)),
            ElevatedButton(
              onPressed: onButtonPressed ?? () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.r(8, context),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(32, context),
                  vertical: ResponsiveHelper.h(12, context),
                ),
              ),
              child: Text(
                buttonText ?? 'OK',
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(isTablet ? 16 : 14, context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
