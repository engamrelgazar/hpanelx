import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/core/utils/utils.dart';
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'package:hpanelx/src/modules/vms/presentation/cubit/vms_cubit.dart';
import 'package:hpanelx/src/modules/vms/presentation/pages/vm_detail_page.dart';
import 'package:hpanelx/src/modules/vms/presentation/widgets/vm_card.dart';
import 'package:hpanelx/src/modules/vms/presentation/widgets/vm_shimmer.dart';

class VmsPage extends StatefulWidget {
  const VmsPage({super.key});

  @override
  State<VmsPage> createState() => _VmsPageState();
}

class _VmsPageState extends State<VmsPage> {
  @override
  void initState() {
    super.initState();
    _loadVirtualMachines();
  }

  void _loadVirtualMachines() {
    context.read<VmsCubit>().getVirtualMachines();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Machines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadVirtualMachines,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<VmsCubit, VmsState>(
        builder: (context, state) {
          if (state is VmsLoading) {
            return VmShimmerLoading(isTablet: isTablet);
          } else if (state is VmsError) {
            return _buildErrorView(state.message, isTablet);
          } else if (state is VmsLoaded) {
            if (state.vms.isEmpty) {
              return _buildEmptyView(isTablet);
            }
            return _buildVmsList(state, isTablet);
          }

          // Initial state or unexpected state
          return VmShimmerLoading(isTablet: isTablet);
        },
      ),
    );
  }

  Widget _buildVmsList(VmsLoaded state, bool isTablet) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadVirtualMachines();
      },
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
        itemCount: state.vms.length,
        itemBuilder: (context, index) {
          final vm = state.vms[index];
          return VmCard(
            vm: vm,
            onTap: () {
              // Get a reference to the cubit before navigation
              final vmsCubit = context.read<VmsCubit>();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider<VmsCubit>.value(
                        value: vmsCubit,
                        child: VmDetailPage(vmId: vm.id),
                      ),
                ),
              ).then((_) {
                // Refresh the list when returning from detail page
                _loadVirtualMachines();
              });
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
            Icons.cloud_off,
            size:
                isTablet
                    ? ResponsiveHelper.sp(80, context)
                    : ResponsiveHelper.sp(64, context),
            color: Colors.grey[400],
          ),
          SizedBox(height: ResponsiveHelper.h(16, context)),
          Text(
            'No virtual machines found',
            style: TextStyle(
              fontSize:
                  isTablet
                      ? ResponsiveHelper.sp(20, context)
                      : ResponsiveHelper.sp(18, context),
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(8, context)),
          Text(
            'Your virtual machines will appear here',
            style: TextStyle(
              fontSize:
                  isTablet
                      ? ResponsiveHelper.sp(16, context)
                      : ResponsiveHelper.sp(14, context),
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(24, context)),
          ElevatedButton.icon(
            onPressed: _loadVirtualMachines,
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
            size:
                isTablet
                    ? ResponsiveHelper.sp(80, context)
                    : ResponsiveHelper.sp(64, context),
          ),
          SizedBox(height: ResponsiveHelper.h(16, context)),
          Text(
            'Failed to load virtual machines',
            style: TextStyle(
              fontSize:
                  isTablet
                      ? ResponsiveHelper.sp(20, context)
                      : ResponsiveHelper.sp(18, context),
              fontWeight: FontWeight.bold,
              color: AppTheme.errorColor,
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
                fontSize:
                    isTablet
                        ? ResponsiveHelper.sp(16, context)
                        : ResponsiveHelper.sp(14, context),
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(24, context)),
          ElevatedButton.icon(
            onPressed: _loadVirtualMachines,
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
