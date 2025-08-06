import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:hpanelx/src/core/widgets/app_header.dart';
import 'package:hpanelx/src/modules/billing/presentation/cubit/payment_methods_cubit.dart';
import 'package:hpanelx/src/modules/billing/presentation/widgets/payment_method_card.dart';
import 'package:hpanelx/src/modules/billing/data/models/payment_method_model.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentMethodsCubit>().getPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: 'Payment Methods',
            actions: [
              IconButton(
                onPressed: () => _refreshPaymentMethods(),
                icon: Icon(
                  Icons.refresh,
                  size: ResponsiveHelper.responsiveIconSize(context, 24),
                ),
              ),
            ],
          ),
          Expanded(
            child: BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
              listener: (context, state) {
                if (state is PaymentMethodDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment method deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is PaymentMethodDefaultSet) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Default payment method updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is PaymentMethodsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is PaymentMethodsLoading) {
                  return _buildLoadingState(isTablet);
                } else if (state is PaymentMethodsLoaded) {
                  return _buildLoadedState(
                      context, state.paymentMethods, isTablet);
                } else if (state is PaymentMethodsError) {
                  return _buildErrorState(context, state.message, isTablet);
                } else {
                  return _buildLoadingState(isTablet);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: ResponsiveHelper.h(16, context)),
          Text(
            'Loading payment methods...',
            style: TextStyle(
              fontSize: ResponsiveHelper.sp(16, context),
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context,
      List<PaymentMethodModel> paymentMethods, bool isTablet) {
    if (paymentMethods.isEmpty) {
      return _buildEmptyState(isTablet);
    }

    return RefreshIndicator(
      onRefresh: _refreshPaymentMethods,
      child: ListView.builder(
        padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
        itemCount: paymentMethods.length,
        itemBuilder: (context, index) {
          final paymentMethod = paymentMethods[index];
          return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
            builder: (context, state) {
              final isDeleting = state is PaymentMethodDeleting &&
                  state.paymentMethodId == paymentMethod.id;
              final isSettingDefault = state is PaymentMethodSettingDefault &&
                  state.paymentMethodId == paymentMethod.id;

              return PaymentMethodCard(
                paymentMethod: paymentMethod,
                isTablet: isTablet,
                isDeleting: isDeleting,
                isSettingDefault: isSettingDefault,
                onDelete: () =>
                    _confirmDeletePaymentMethod(context, paymentMethod),
                onSetDefault: paymentMethod.isDefault
                    ? null
                    : () => _setDefaultPaymentMethod(context, paymentMethod),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_off,
            size: ResponsiveHelper.responsiveIconSize(context, 80),
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          SizedBox(height: ResponsiveHelper.h(16, context)),
          Text(
            'No Payment Methods',
            style: TextStyle(
              fontSize: ResponsiveHelper.sp(20, context),
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(8, context)),
          Text(
            'Add a payment method to get started',
            style: TextStyle(
              fontSize: ResponsiveHelper.sp(14, context),
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: ResponsiveHelper.responsiveIconSize(context, 80),
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: ResponsiveHelper.h(16, context)),
          Text(
            'Error loading payment methods',
            style: TextStyle(
              fontSize: ResponsiveHelper.sp(18, context),
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(8, context)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveHelper.sp(14, context),
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(24, context)),
          ElevatedButton.icon(
            onPressed: _refreshPaymentMethods,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshPaymentMethods() async {
    await context.read<PaymentMethodsCubit>().refreshPaymentMethods();
  }

  void _confirmDeletePaymentMethod(
      BuildContext context, PaymentMethodModel paymentMethod) {
    // Get the cubit reference before opening the dialog
    final paymentMethodsCubit = context.read<PaymentMethodsCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: Text(
          'Are you sure you want to delete this payment method?\n\n'
          '${paymentMethod.paymentMethod.toUpperCase()}: ${paymentMethod.last4 != null ? '•••• ${paymentMethod.last4}' : paymentMethod.name}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Use the captured cubit reference instead of reading from context
              paymentMethodsCubit.deletePaymentMethod(paymentMethod.id);
            },
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _setDefaultPaymentMethod(
      BuildContext context, PaymentMethodModel paymentMethod) {
    context
        .read<PaymentMethodsCubit>()
        .setDefaultPaymentMethod(paymentMethod.id);
  }
}
