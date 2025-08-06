import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:hpanelx/src/modules/billing/presentation/cubit/billing_cubit.dart';
import 'package:hpanelx/src/modules/billing/presentation/widgets/subscription_card.dart';
import 'package:hpanelx/src/modules/billing/presentation/widgets/subscription_shimmer.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  @override
  void initState() {
    super.initState();
    _loadSubscriptions();
  }

  void _loadSubscriptions() {
    context.read<BillingCubit>().getSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.credit_card),
            onPressed: () => context.push('/billing/payment-methods'),
            tooltip: 'Payment Methods',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSubscriptions,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<BillingCubit, BillingState>(
        builder: (context, state) {
          if (state is BillingLoading) {
            return _buildLoadingState(isTablet);
          } else if (state is BillingError) {
            return _buildErrorView(state.message, isTablet);
          } else if (state is BillingLoaded) {
            if (state.subscriptions.isEmpty) {
              return _buildEmptyView(isTablet);
            }
            return _buildSubscriptionsList(state, isTablet);
          }

          // Initial state or unexpected state
          return _buildLoadingState(isTablet);
        },
      ),
    );
  }

  Widget _buildLoadingState(bool isTablet) {
    return ListView.builder(
      padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
      itemCount: 8, // Show 8 placeholders
      itemBuilder: (context, index) => SubscriptionShimmer(isTablet: isTablet),
    );
  }

  Widget _buildSubscriptionsList(BillingLoaded state, bool isTablet) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadSubscriptions();
      },
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
        itemCount: state.subscriptions.length,
        itemBuilder: (context, index) {
          final subscription = state.subscriptions[index];
          return SubscriptionCard(
            subscription: subscription,
            onTap: () {
              // Navigate to subscription details if needed
              // For now, just show a snackbar with the subscription ID
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Subscription ID: ${subscription.id}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            isTablet: isTablet,
          );
        },
      ),
    );
  }

  Widget _buildEmptyView(bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: isTablet
                ? ResponsiveHelper.sp(80, context)
                : ResponsiveHelper.sp(64, context),
            color: Colors.grey[400],
          ),
          SizedBox(height: ResponsiveHelper.h(16, context)),
          Text(
            'No subscriptions found',
            style: TextStyle(
              fontSize: isTablet
                  ? ResponsiveHelper.sp(20, context)
                  : ResponsiveHelper.sp(18, context),
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(8, context)),
          Text(
            'Your subscriptions will appear here',
            style: TextStyle(
              fontSize: isTablet
                  ? ResponsiveHelper.sp(16, context)
                  : ResponsiveHelper.sp(14, context),
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(24, context)),
          ElevatedButton.icon(
            onPressed: _loadSubscriptions,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(24, context),
                vertical: ResponsiveHelper.h(12, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message, bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.errorColor,
            size: isTablet
                ? ResponsiveHelper.sp(80, context)
                : ResponsiveHelper.sp(64, context),
          ),
          SizedBox(height: ResponsiveHelper.h(16, context)),
          Text(
            'Failed to load subscriptions',
            style: TextStyle(
              fontSize: isTablet
                  ? ResponsiveHelper.sp(20, context)
                  : ResponsiveHelper.sp(18, context),
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(8, context)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(32, context),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet
                    ? ResponsiveHelper.sp(16, context)
                    : ResponsiveHelper.sp(14, context),
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(24, context)),
          ElevatedButton.icon(
            onPressed: _loadSubscriptions,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(24, context),
                vertical: ResponsiveHelper.h(12, context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
