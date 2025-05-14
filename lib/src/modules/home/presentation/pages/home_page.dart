import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'package:hpanelx/src/modules/home/presentation/bloc/home_bloc.dart';
import 'package:hpanelx/src/modules/home/presentation/widgets/shimmer_loading.dart';
import 'package:hpanelx/src/modules/startup/presentation/bloc/startup_bloc.dart';
import 'package:hpanelx/src/core/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load data when page is first opened
    context.read<HomeBloc>().add(LoadHomeDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for more responsive calculations
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return BlocListener<StartupBloc, StartupState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.replace('/token'); // Navigate to token input page
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(20, context),
                vertical: ResponsiveHelper.h(16, context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Centered Header
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Welcome to HPanelX',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(
                              isTablet ? 32 : 28,
                              context,
                            ),
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: ResponsiveHelper.h(8, context)),
                        Text(
                          'Manage your hosting services',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(
                              isTablet ? 16 : 14,
                              context,
                            ),
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.h(32, context)),

                  // Main Sections - use adaptive layouts for different screen sizes
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (isDesktop) {
                        // Desktop layout - grid of cards with 3 columns
                        return GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 5.0,
                          mainAxisSpacing: ResponsiveHelper.h(12, context),
                          crossAxisSpacing: ResponsiveHelper.w(12, context),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildSectionCard(
                              title: 'VPS Machines',
                              icon: Icons.dns_rounded,
                              color: AppTheme.primaryColor,
                              description:
                                  'Manage your virtual private servers',
                              onTap: () {
                                // Navigate to VPS/Machines section
                                context.push('/vms');
                              },
                              isTablet: true,
                            ),
                            _buildSectionCard(
                              title: 'Domains',
                              icon: Icons.language_rounded,
                              color: AppTheme.secondaryColor,
                              description: 'Manage your domain names and DNS',
                              onTap: () {
                                // Navigate to Domains section
                                context.push('/domains');
                              },
                              isTablet: true,
                            ),
                            _buildSectionCard(
                              title: 'Billing',
                              icon: Icons.payment_rounded,
                              color: AppTheme.accentColor,
                              description: 'View invoices and payment methods',
                              onTap: () {
                                // Navigate to Billing section
                                context.push('/billing/subscriptions');
                              },
                              isTablet: true,
                            ),
                          ],
                        );
                      } else if (isTablet) {
                        // Tablet layout - grid of cards with 2 columns
                        return GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 5.0,
                          mainAxisSpacing: ResponsiveHelper.h(12, context),
                          crossAxisSpacing: ResponsiveHelper.w(12, context),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildSectionCard(
                              title: 'VPS Machines',
                              icon: Icons.dns_rounded,
                              color: AppTheme.primaryColor,
                              description:
                                  'Manage your virtual private servers',
                              onTap: () {
                                // Navigate to VPS/Machines section
                                context.push('/vms');
                              },
                              isTablet: true,
                            ),
                            _buildSectionCard(
                              title: 'Domains',
                              icon: Icons.language_rounded,
                              color: AppTheme.secondaryColor,
                              description: 'Manage your domain names and DNS',
                              onTap: () {
                                // Navigate to Domains section
                                context.push('/domains');
                              },
                              isTablet: true,
                            ),
                            _buildSectionCard(
                              title: 'Billing',
                              icon: Icons.payment_rounded,
                              color: AppTheme.accentColor,
                              description: 'View invoices and payment methods',
                              onTap: () {
                                // Navigate to Billing section
                                context.push('/billing/subscriptions');
                              },
                              isTablet: true,
                            ),
                          ],
                        );
                      } else {
                        // Phone layout - stacked cards
                        return Column(
                          children: [
                            SizedBox(
                              height: ResponsiveHelper.h(80, context),
                              child: _buildSectionCard(
                                title: 'VPS Machines',
                                icon: Icons.dns_rounded,
                                color: AppTheme.primaryColor,
                                description:
                                    'Manage your virtual private servers',
                                onTap: () {
                                  // Navigate to VPS/Machines section
                                  context.push('/vms');
                                },
                                isTablet: false,
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.h(16, context)),
                            SizedBox(
                              height: ResponsiveHelper.h(80, context),
                              child: _buildSectionCard(
                                title: 'Domains',
                                icon: Icons.language_rounded,
                                color: AppTheme.secondaryColor,
                                description:
                                    'Manage your domain names and DNS settings',
                                onTap: () {
                                  // Navigate to Domains section
                                  context.push('/domains');
                                },
                                isTablet: false,
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.h(16, context)),
                            SizedBox(
                              height: ResponsiveHelper.h(80, context),
                              child: _buildSectionCard(
                                title: 'Billing',
                                icon: Icons.payment_rounded,
                                color: AppTheme.accentColor,
                                description:
                                    'View invoices and manage payment methods',
                                onTap: () {
                                  // Navigate to Billing section
                                  context.push('/billing/subscriptions');
                                },
                                isTablet: false,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),

                  SizedBox(height: ResponsiveHelper.h(32, context)),

                  // Quick Stats Header
                  Text(
                    'Account Overview',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.sp(
                        isTablet ? 20 : 18,
                        context,
                      ),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkColor,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.h(16, context)),

                  // Stats cards with BLoC
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      // Check the state and render accordingly
                      if (state is HomeLoading) {
                        return _buildLoadingStats(
                          isTablet,
                          ResponsiveHelper.w(20, context),
                        );
                      } else if (state is HomeLoaded) {
                        return _buildLoadedStats(
                          context,
                          isTablet,
                          state.activeServersCount,
                          state.activeDomainsCount,
                        );
                      } else if (state is HomeError) {
                        return _buildErrorStats(
                          context,
                          isTablet,
                          state.message,
                        );
                      } else {
                        // Initial state or any other state
                        return _buildLoadingStats(
                          isTablet,
                          ResponsiveHelper.w(20, context),
                        );
                      }
                    },
                  ),

                  // Logout button at the bottom
                  SizedBox(height: ResponsiveHelper.h(52, context)),

                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.r(16, context),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _showLogoutConfirmation(context, isTablet),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.r(16, context),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(ResponsiveHelper.w(5, context)),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(
                                ResponsiveHelper.w(8, context),
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.errorColor.withAlpha(26),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.r(12, context),
                                ),
                              ),
                              child: Icon(
                                Icons.logout_rounded,
                                color: AppTheme.errorColor,
                                size: ResponsiveHelper.sp(28, context),
                              ),
                            ),
                            SizedBox(width: ResponsiveHelper.w(16, context)),
                            Expanded(
                              child: Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.sp(16, context),
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.errorColor,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppTheme.errorColor.withAlpha(200),
                              size: ResponsiveHelper.sp(
                                isTablet ? 18 : 16,
                                context,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget for loading state
  Widget _buildLoadingStats(bool isTablet, double width) {
    // For very small screens (width < 360), use a single column
    final isVerySmallScreen = MediaQuery.of(context).size.width < 360;

    return GridView.count(
      crossAxisCount: isVerySmallScreen ? 1 : 2,
      childAspectRatio: isTablet ? 6.0 : 5.0,
      mainAxisSpacing: ResponsiveHelper.h(12, context),
      crossAxisSpacing: ResponsiveHelper.w(12, context),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ShimmerCard(
          height: ResponsiveHelper.h(60, context),
          width: width,
          borderRadius: ResponsiveHelper.r(12, context),
        ),
        ShimmerCard(
          height: ResponsiveHelper.h(60, context),
          width: width,
          borderRadius: ResponsiveHelper.r(12, context),
        ),
      ],
    );
  }

  // Widget for error state
  Widget _buildErrorStats(
    BuildContext context,
    bool isTablet,
    String errorMessage,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(16, context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: AppTheme.errorColor,
                size: ResponsiveHelper.responsiveIconSize(
                  context,
                  isTablet ? 48 : 40,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(8, context)),
              Text(
                'Failed to load data',
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(isTablet ? 18 : 16, context),
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkColor,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(4, context)),
              Text(
                errorMessage,
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(isTablet ? 14 : 12, context),
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveHelper.h(16, context)),
              ElevatedButton(
                onPressed: () {
                  context.read<HomeBloc>().add(LoadHomeDataEvent());
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.r(8, context),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(16, context),
                    vertical: ResponsiveHelper.h(8, context),
                  ),
                ),
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(isTablet ? 16 : 14, context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for loaded state
  Widget _buildLoadedStats(
    BuildContext context,
    bool isTablet,
    int serversCount,
    int domainsCount,
  ) {
    // For very small screens (width < 360), use a single column
    final isVerySmallScreen = MediaQuery.of(context).size.width < 400;

    return GridView.count(
      crossAxisCount: isVerySmallScreen ? 1 : 2,
      childAspectRatio: isTablet ? 6.0 : 5.0,
      mainAxisSpacing: ResponsiveHelper.h(12, context),
      crossAxisSpacing: ResponsiveHelper.w(12, context),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          title: 'Active Servers',
          value: serversCount.toString(),
          icon: Icons.dns_rounded,
          color: AppTheme.primaryColor,
          isTablet: isTablet,
        ),
        _buildStatCard(
          title: 'Active Domains',
          value: domainsCount.toString(),
          icon: Icons.language_rounded,
          color: AppTheme.secondaryColor,
          isTablet: isTablet,
        ),
      ],
    );
  }

  // Show confirmation dialog before logout
  void _showLogoutConfirmation(BuildContext context, bool isTablet) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.r(16, context),
              ),
            ),
            title: Text(
              'Logout Confirmation',
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(isTablet ? 20 : 18, context),
                fontWeight: FontWeight.bold,
                color: AppTheme.darkColor,
              ),
            ),
            content: Text(
              'Are you sure you want to logout?',
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(isTablet ? 16 : 14, context),
                color: Colors.grey[700],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(isTablet ? 16 : 14, context),
                    color: Colors.grey[700],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<StartupBloc>().add(LogoutEvent());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.r(8, context),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(16, context),
                    vertical: ResponsiveHelper.h(8, context),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(14, context),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required VoidCallback onTap,
    required bool isTablet,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(10, context),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(6, context)),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.r(6, context),
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: ResponsiveHelper.responsiveIconSize(
                    context,
                    isTablet ? 16 : 14,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(8, context)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(
                          isTablet ? 13 : 12,
                          context,
                        ),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(
                          isTablet ? 11 : 10,
                          context,
                        ),
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color.withAlpha(200),
                size: ResponsiveHelper.responsiveIconSize(
                  context,
                  isTablet ? 12 : 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isTablet,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(10, context),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(6, context)),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.r(6, context),
                  ),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: ResponsiveHelper.responsiveIconSize(
                    context,
                    isTablet ? 16 : 14,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(8, context)),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(
                          isTablet ? 11 : 10,
                          context,
                        ),
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(
                          isTablet ? 15 : 14,
                          context,
                        ),
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
