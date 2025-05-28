import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/core/utils/utils.dart';
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'package:hpanelx/src/core/widgets/success_dialog.dart';
import 'package:hpanelx/src/modules/vms/data/models/ip_model.dart';
import 'package:hpanelx/src/modules/vms/data/models/vm_model.dart';
import 'package:hpanelx/src/modules/vms/presentation/cubit/vms_cubit.dart';
import 'package:hpanelx/src/modules/vms/presentation/widgets/vm_action_buttons.dart';
import 'package:hpanelx/src/modules/vms/presentation/widgets/vm_detail_shimmer.dart';

class VmDetailPage extends StatefulWidget {
  final int vmId;

  const VmDetailPage({super.key, required this.vmId});

  @override
  State<VmDetailPage> createState() => _VmDetailPageState();
}

class _VmDetailPageState extends State<VmDetailPage> {
  @override
  void initState() {
    super.initState();
    // Load VM details when page initializes
    context.read<VmsCubit>().getVirtualMachineById(widget.vmId);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return BlocListener<VmsCubit, VmsState>(
      listenWhen: (previous, current) => current is VmActionSuccess,
      listener: (context, state) {
        if (state is VmActionSuccess) {
          _showSuccessDialog(context, state.action);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<VmsCubit, VmsState>(
            builder: (context, state) {
              if (state is VmDetailLoaded) {
                return Text(state.vm.hostname);
              }
              return const Text('Virtual Machine Details');
            },
          ),
          elevation: 0,
        ),
        body: BlocBuilder<VmsCubit, VmsState>(
          builder: (context, state) {
            if (state is VmsLoading) {
              return VmDetailShimmer(isTablet: isTablet);
            } else if (state is VmsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppTheme.errorColor,
                      size:
                          isTablet
                              ? ResponsiveHelper.sp(64, context)
                              : ResponsiveHelper.sp(48, context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(16, context)),
                    Text(
                      'Error loading VM details',
                      style: TextStyle(
                        fontSize:
                            isTablet
                                ? ResponsiveHelper.sp(18, context)
                                : ResponsiveHelper.sp(16, context),
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
                        state.message,
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
                      onPressed: () {
                        context.read<VmsCubit>().getVirtualMachineById(
                          widget.vmId,
                        );
                      },
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
            } else if (state is VmDetailLoaded) {
              return _buildVmDetails(context, state.vm, isTablet);
            } else if (state is VmActionInProgress ||
                state is VmActionSuccess) {
              // Handle VM action states while maintaining the VM details view
              String? action;
              bool isLoading = false;
              VmModel? vm;

              if (state is VmActionInProgress) {
                action = state.action;
                isLoading = true;
              } else if (state is VmActionSuccess) {
                action = state.action;
                isLoading = false;
              }

              // Try to get VM from previous state
              final prevState = context.read<VmsCubit>().state;
              if (prevState is VmDetailLoaded) {
                vm = prevState.vm;
              }

              if (vm != null) {
                return _buildVmDetailWithAction(
                  context,
                  vm,
                  isTablet,
                  isLoading,
                  action,
                );
              } else {
                // If VM is not available, show shimmer loading
                return VmDetailShimmer(isTablet: isTablet);
              }
            }

            // Initial state or unexpected state
            return VmDetailShimmer(isTablet: isTablet);
          },
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String action) {
    String title;
    String message;

    switch (action) {
      case 'reboot':
        title = 'Restart Successful';
        message =
            'Virtual machine restart was successfully initiated. It may take a moment to complete the operation.';
        break;
      case 'shutdown':
        title = 'Shutdown Successful';
        message =
            'Virtual machine shutdown was successfully initiated. It may take a moment to complete the operation.';
        break;
      case 'start':
        title = 'Start Successful';
        message =
            'Virtual machine start was successfully initiated. It may take a moment to complete the operation.';
        break;
      default:
        title = 'Operation Successful';
        message = 'The operation was completed successfully.';
    }

    SuccessDialog.show(
      context: context,
      title: title,
      message: message,
      buttonText: 'OK',
    );
  }

  Widget _buildVmDetails(BuildContext context, VmModel vm, bool isTablet) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // VM Status and Actions
          _buildStatusSection(context, vm, isTablet),

          SizedBox(height: ResponsiveHelper.h(24, context)),

          // VM Information
          _buildInfoSection('VM Information', [
            _buildInfoItem('Hostname', vm.hostname, isTablet),
            _buildInfoItem('Plan', vm.plan, isTablet),
            _buildInfoItem('Status', vm.state, isTablet),
            _buildInfoItem(
              'Creation Date',
              _formatDate(vm.createdAt),
              isTablet,
            ),
          ], isTablet),

          SizedBox(height: ResponsiveHelper.h(16, context)),

          // Hardware Specifications
          _buildInfoSection('Hardware Specifications', [
            _buildInfoItem('CPU', '${vm.cpus} Cores', isTablet),
            _buildInfoItem('RAM', _formatMemory(vm.memory), isTablet),
            _buildInfoItem('Storage', _formatStorage(vm.disk), isTablet),
            _buildInfoItem(
              'Bandwidth',
              _formatBandwidth(vm.bandwidth),
              isTablet,
            ),
          ], isTablet),

          SizedBox(height: ResponsiveHelper.h(16, context)),

          // Network Information
          _buildInfoSection('Network Information', [
            _buildInfoItem('Name Server 1', vm.ns1, isTablet),
            _buildInfoItem('Name Server 2', vm.ns2, isTablet),
          ], isTablet),

          SizedBox(height: ResponsiveHelper.h(16, context)),

          // IP Addresses
          _buildIpAddressesSection(vm, isTablet),

          SizedBox(height: ResponsiveHelper.h(16, context)),

          // Template Information
          _buildInfoSection('OS Template', [
            _buildInfoItem('Template', vm.template.name, isTablet),
            _buildInfoItem(
              'Description',
              vm.template.description,
              isTablet,
              maxLines: 5,
            ),
          ], isTablet),

          SizedBox(height: ResponsiveHelper.h(24, context)),
        ],
      ),
    );
  }

  Widget _buildVmDetailWithAction(
    BuildContext context,
    VmModel vm,
    bool isTablet,
    bool isLoading,
    String? action,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // VM Status with loading indicator for actions
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.r(12, context),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.w(16, context),
                          vertical: ResponsiveHelper.h(8, context),
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            vm.state,
                          ).withValues(alpha: 26),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.r(16, context),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getStatusIcon(vm.state),
                              color: _getStatusColor(vm.state),
                              size:
                                  isTablet
                                      ? ResponsiveHelper.sp(24, context)
                                      : ResponsiveHelper.sp(20, context),
                            ),
                            SizedBox(width: ResponsiveHelper.w(8, context)),
                            Text(
                              vm.state.toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(vm.state),
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    isTablet
                                        ? ResponsiveHelper.sp(16, context)
                                        : ResponsiveHelper.sp(14, context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.h(24, context)),
                  VmActionButtons(
                    state: vm.state,
                    isLoading: isLoading,
                    currentAction: action,
                    onStart:
                        () =>
                            context.read<VmsCubit>().startVirtualMachine(vm.id),
                    onReboot:
                        () => context.read<VmsCubit>().rebootVirtualMachine(
                          vm.id,
                        ),
                    onShutdown:
                        () => context.read<VmsCubit>().shutdownVirtualMachine(
                          vm.id,
                        ),
                    isTablet: isTablet,
                  ),
                  if (isLoading) ...[
                    SizedBox(height: ResponsiveHelper.h(16, context)),
                    Text(
                      _getActionText(action ?? ''),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize:
                            isTablet
                                ? ResponsiveHelper.sp(16, context)
                                : ResponsiveHelper.sp(14, context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(24, context)),

          // Display the same VM details as in _buildVmDetails but without rebuilding action buttons
          _buildInfoSection('VM Information', [
            _buildInfoItem('Hostname', vm.hostname, isTablet),
            _buildInfoItem('Plan', vm.plan, isTablet),
            _buildInfoItem('Status', vm.state, isTablet),
            _buildInfoItem(
              'Creation Date',
              _formatDate(vm.createdAt),
              isTablet,
            ),
          ], isTablet),

          SizedBox(height: ResponsiveHelper.h(16, context)),

          // Hardware Specifications
          _buildInfoSection('Hardware Specifications', [
            _buildInfoItem('CPU', '${vm.cpus} Cores', isTablet),
            _buildInfoItem('RAM', _formatMemory(vm.memory), isTablet),
            _buildInfoItem('Storage', _formatStorage(vm.disk), isTablet),
            _buildInfoItem(
              'Bandwidth',
              _formatBandwidth(vm.bandwidth),
              isTablet,
            ),
          ], isTablet),

          SizedBox(height: ResponsiveHelper.h(16, context)),

          // IP Addresses section
          _buildIpAddressesSection(vm, isTablet),

          SizedBox(height: ResponsiveHelper.h(24, context)),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, VmModel vm, bool isTablet) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(16, context),
                    vertical: ResponsiveHelper.h(8, context),
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(vm.state).withValues(alpha: 26),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.r(16, context),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(vm.state),
                        color: _getStatusColor(vm.state),
                        size:
                            isTablet
                                ? ResponsiveHelper.sp(24, context)
                                : ResponsiveHelper.sp(20, context),
                      ),
                      SizedBox(width: ResponsiveHelper.w(8, context)),
                      Text(
                        vm.state.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(vm.state),
                          fontWeight: FontWeight.bold,
                          fontSize:
                              isTablet
                                  ? ResponsiveHelper.sp(16, context)
                                  : ResponsiveHelper.sp(14, context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(24, context)),
            VmActionButtons(
              state: vm.state,
              isLoading: false,
              onStart:
                  () => context.read<VmsCubit>().startVirtualMachine(vm.id),
              onReboot:
                  () => context.read<VmsCubit>().rebootVirtualMachine(vm.id),
              onShutdown:
                  () => context.read<VmsCubit>().shutdownVirtualMachine(vm.id),
              isTablet: isTablet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> items, bool isTablet) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize:
                    isTablet
                        ? ResponsiveHelper.sp(20, context)
                        : ResponsiveHelper.sp(18, context),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
            ),
            Divider(height: ResponsiveHelper.h(24, context)),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    bool isTablet, {
    int maxLines = 2,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12, context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ResponsiveHelper.w(120, context),
            child: Text(
              label,
              style: TextStyle(
                fontSize:
                    isTablet
                        ? ResponsiveHelper.sp(16, context)
                        : ResponsiveHelper.sp(14, context),
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.w(16, context)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize:
                    isTablet
                        ? ResponsiveHelper.sp(16, context)
                        : ResponsiveHelper.sp(14, context),
                color: AppTheme.darkColor,
              ),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIpAddressesSection(VmModel vm, bool isTablet) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'IP Addresses',
              style: TextStyle(
                fontSize:
                    isTablet
                        ? ResponsiveHelper.sp(20, context)
                        : ResponsiveHelper.sp(18, context),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor
              ),
            ),
            Divider(height: ResponsiveHelper.h(24, context)),
            // IPv4 Addresses
            if (vm.ipv4.isNotEmpty) ...[
              Text(
                'IPv4',
                style: TextStyle(
                  fontSize:
                      isTablet
                          ? ResponsiveHelper.sp(16, context)
                          : ResponsiveHelper.sp(14, context),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(8, context)),
              ...vm.ipv4.map((ip) => _buildIpAddressItem(ip, isTablet)),
              SizedBox(height: ResponsiveHelper.h(16, context)),
            ],
            // IPv6 Addresses
            if (vm.ipv6.isNotEmpty) ...[
              Text(
                'IPv6',
                style: TextStyle(
                  fontSize:
                      isTablet
                          ? ResponsiveHelper.sp(16, context)
                          : ResponsiveHelper.sp(14, context),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(8, context)),
              ...vm.ipv6.map((ip) => _buildIpAddressItem(ip, isTablet)),
            ],
            if (vm.ipv4.isEmpty && vm.ipv6.isEmpty)
              Text(
                'No IP addresses assigned',
                style: TextStyle(
                  fontSize:
                      isTablet
                          ? ResponsiveHelper.sp(16, context)
                          : ResponsiveHelper.sp(14, context),
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIpAddressItem(IpModel ip, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.h(8, context)),
      child: Row(
        children: [
          Icon(
            Icons.lan,
            size:
                isTablet
                    ? ResponsiveHelper.sp(20, context)
                    : ResponsiveHelper.sp(18, context),
            color: Colors.blue,
          ),
          SizedBox(width: ResponsiveHelper.w(8, context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ip.address,
                  style: TextStyle(
                    fontSize:
                        isTablet
                            ? ResponsiveHelper.sp(16, context)
                            : ResponsiveHelper.sp(14, context),
                    color: AppTheme.darkColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (ip.ptr.isNotEmpty)
                  Text(
                    'PTR: ${ip.ptr}',
                    style: TextStyle(
                      fontSize:
                          isTablet
                              ? ResponsiveHelper.sp(14, context)
                              : ResponsiveHelper.sp(12, context),
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              // Copy IP address to clipboard
              // You can implement this functionality
            },
            iconSize:
                isTablet
                    ? ResponsiveHelper.sp(20, context)
                    : ResponsiveHelper.sp(18, context),
            color: Theme.of(context).primaryColor,
            tooltip: 'Copy IP address',
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'running':
        return Colors.green;
      case 'stopped':
        return Colors.red;
      case 'restarting':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'running':
        return Icons.play_arrow;
      case 'stopped':
        return Icons.stop;
      case 'restarting':
        return Icons.refresh;
      default:
        return Icons.help_outline;
    }
  }

  String _getActionText(String action) {
    switch (action) {
      case 'start':
        return 'Starting virtual machine...';
      case 'reboot':
        return 'Rebooting virtual machine...';
      case 'shutdown':
        return 'Shutting down virtual machine...';
      default:
        return 'Performing action...';
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoDate;
    }
  }

  String _formatMemory(int memoryMB) {
    if (memoryMB >= 1024) {
      double memoryGB = memoryMB / 1024;
      return '${memoryGB.toStringAsFixed(0)} GB';
    }
    return '$memoryMB MB';
  }

  String _formatStorage(int storageMB) {
    if (storageMB >= 1024 * 1024) {
      double storageTB = storageMB / (1024 * 1024);
      return '${storageTB.toStringAsFixed(1)} TB';
    } else if (storageMB >= 1024) {
      double storageGB = storageMB / 1024;
      return '${storageGB.toStringAsFixed(0)} GB';
    }
    return '$storageMB MB';
  }

  String _formatBandwidth(int bandwidthKB) {
    if (bandwidthKB >= 1024 * 1024 * 1024) {
      double bandwidthPB = bandwidthKB / (1024 * 1024 * 1024);
      return '${bandwidthPB.toStringAsFixed(1)} PB';
    } else if (bandwidthKB >= 1024 * 1024) {
      double bandwidthTB = bandwidthKB / (1024 * 1024);
      return '${bandwidthTB.toStringAsFixed(1)} TB';
    } else if (bandwidthKB >= 1024) {
      double bandwidthGB = bandwidthKB / 1024;
      return '${bandwidthGB.toStringAsFixed(0)} GB';
    }
    return '$bandwidthKB KB';
  }
}
