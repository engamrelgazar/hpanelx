import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/utils.dart';
import 'package:hpanelx/src/core/widgets/widgets.dart';
import 'package:hpanelx/src/modules/vms/data/models/vm_model.dart';

class VmCard extends StatelessWidget {
  final VmModel vm;
  final VoidCallback onTap;
  final bool isTablet;

  const VmCard({
    super.key,
    required this.vm,
    required this.onTap,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16, context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      vm.hostname,
                      style: TextStyle(
                        fontSize:
                            isTablet
                                ? ResponsiveHelper.sp(18, context)
                                : ResponsiveHelper.sp(16, context),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusBadge(
                    status: vm.state,
                    isTablet: isTablet,
                    statusConfigs: {
                      'running': StatusConfig(
                        badgeColor: Colors.green.withValues(
                          alpha: (Colors.green.a * 0.1).toDouble(),
                          red: Colors.green.r.toDouble(),
                          green: Colors.green.g.toDouble(),
                          blue: Colors.green.b.toDouble(),
                        ),
                        textColor: Colors.green[700]!,
                        icon: Icons.play_arrow,
                      ),
                      'stopped': StatusConfig(
                        badgeColor: Colors.red.withValues(
                          alpha: (Colors.red.a * 0.1).toDouble(),
                          red: Colors.red.r.toDouble(),
                          green: Colors.red.g.toDouble(),
                          blue: Colors.red.b.toDouble(),
                        ),
                        textColor: Colors.red[700]!,
                        icon: Icons.stop,
                      ),
                      'restarting': StatusConfig(
                        badgeColor: Colors.orange.withValues(
                          alpha: (Colors.orange.a * 0.1).toDouble(),
                          red: Colors.orange.r.toDouble(),
                          green: Colors.orange.g.toDouble(),
                          blue: Colors.orange.b.toDouble(),
                        ),
                        textColor: Colors.orange[700]!,
                        icon: Icons.refresh,
                      ),
                    },
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(12, context)),
              InfoItem(
                icon: Icons.dns,
                text: vm.plan,
                label: 'Plan',
                isTablet: isTablet,
                textStyle: TextStyle(
                  fontSize:
                      isTablet
                          ? ResponsiveHelper.sp(16, context)
                          : ResponsiveHelper.sp(14, context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(8, context)),
              InfoItem(
                icon: Icons.language,
                text: vm.ipv4.isNotEmpty ? vm.ipv4.first.address : 'No IPv4',
                label: 'IP Address',
                isTablet: isTablet,
                iconColor: Colors.blue,
                textStyle: TextStyle(
                  fontSize:
                      isTablet
                          ? ResponsiveHelper.sp(15, context)
                          : ResponsiveHelper.sp(13, context),
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(8, context)),
              _buildSpecsRow(context, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecsRow(BuildContext context, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SpecItem(
          icon: Icons.memory,
          label: 'CPU',
          value: '${vm.cpus} Cores',
          isTablet: isTablet,
        ),
        SpecItem(
          icon: Icons.sd_storage,
          label: 'RAM',
          value: _formatMemory(vm.memory),
          isTablet: isTablet,
        ),
        SpecItem(
          icon: Icons.storage,
          label: 'Disk',
          value: _formatStorage(vm.disk),
          isTablet: isTablet,
        ),
      ],
    );
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
}
