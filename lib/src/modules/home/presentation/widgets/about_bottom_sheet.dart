import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutBottomSheet extends StatelessWidget {
  const AboutBottomSheet({super.key});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            // App Logo
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.dashboard_rounded,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            // App Name
            Text(
              'HPanelX',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // App Version
            Text(
              'Version 1.0.1',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color),
            ),
            const SizedBox(height: 24),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'HPanelX is a modern hosting control panel that helps you manage your servers, domains, and virtual machines with ease.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 32),
            // Developer Info
            Text(
              'Developed by',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            // Developer Name
            Text(
              'MarketAix',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // Social Links
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialButton(
                  icon: Icons.language,
                  onPressed: () => _launchURL('https://marketaix.com/'),
                ),
                const SizedBox(width: 16),
                _SocialButton(
                  icon: Icons.facebook,
                  onPressed: () => _launchURL(
                      'https://www.facebook.com/profile.php?id=61568838646748'),
                ),
                const SizedBox(width: 16),
                _SocialButton(
                  icon: Icons.link,
                  onPressed: () => _launchURL(
                      'https://www.linkedin.com/company/marketaix-agency'),
                ),
                const SizedBox(width: 16),
                _SocialButton(
                  iconWidget: FaIcon(
                    FontAwesomeIcons.whatsapp,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  onPressed: () => _launchURL('http://wa.me/201500667828'),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final VoidCallback onPressed;

  const _SocialButton({
    this.icon,
    this.iconWidget,
    required this.onPressed,
  }) : assert(icon != null || iconWidget != null);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: iconWidget ??
              Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        ),
      ),
    );
  }
}
