import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/core/theme/theme_cubit.dart';
import 'package:hpanelx/src/modules/home/presentation/widgets/about_bottom_sheet.dart';
import 'package:hpanelx/src/modules/startup/presentation/bloc/startup_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showAboutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AboutBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.dashboard_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  'HPanelX',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hosting Control Panel',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(204), // 0.8 opacity
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dns_outlined),
            title: const Text('Domains'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/domains');
            },
          ),
          ListTile(
            leading: const Icon(Icons.computer_outlined),
            title: const Text('Virtual Machines'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/vms');
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('Billing'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/billing/subscriptions');
            },
          ),
          ListTile(
            leading: const Icon(Icons.credit_card_outlined),
            title: const Text('Payment Methods'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/billing/payment-methods');
            },
          ),
          const Divider(),
          BlocBuilder<ThemeCubit, AppThemeMode>(
            builder: (context, themeMode) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return ListTile(
                leading: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                title: Text(isDark ? 'Light Mode' : 'Dark Mode'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              _showAboutBottomSheet(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              context.read<StartupBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
    );
  }
}
