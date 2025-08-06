import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class VmDetailShimmer extends StatelessWidget {
  final bool isTablet;

  const VmDetailShimmer({super.key, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status card
          _buildShimmerCard(
            height: ResponsiveHelper.h(140, context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status indicator
                Container(
                  width: ResponsiveHelper.w(120, context),
                  height: ResponsiveHelper.h(28, context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.r(16, context),
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(20, context)),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(context),
                    SizedBox(width: ResponsiveHelper.w(16, context)),
                    _buildActionButton(context),
                    SizedBox(width: ResponsiveHelper.w(16, context)),
                    _buildActionButton(context),
                  ],
                ),
              ],
            ),
            context: context,
          ),
          SizedBox(height: ResponsiveHelper.h(24, context)),

          // VM Information section
          _buildInfoSection('VM Information', 4, context: context),
          SizedBox(height: ResponsiveHelper.h(16, context)),

          // Hardware section
          _buildInfoSection('Hardware Specifications', 4, context: context),
          SizedBox(height: ResponsiveHelper.h(16, context)),

          // Network section
          _buildInfoSection('Network Information', 2, context: context),
          SizedBox(height: ResponsiveHelper.h(16, context)),

          // IP Addresses section
          _buildInfoSection(
            'IP Addresses',
            3,
            height: ResponsiveHelper.h(180, context),
            context: context,
          ),
          SizedBox(height: ResponsiveHelper.h(16, context)),

          // OS Template section
          _buildInfoSection('OS Template', 2, context: context),
          SizedBox(height: ResponsiveHelper.h(24, context)),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    String title,
    int itemCount, {
    double? height,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title outside the card
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: ResponsiveHelper.w(180, context),
            height: ResponsiveHelper.h(24, context),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.r(4, context),
              ),
            ),
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(8, context)),
        _buildShimmerCard(
          height: height,
          child: Column(
            children: List.generate(
              itemCount,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index < itemCount - 1
                      ? ResponsiveHelper.h(12, context)
                      : 0,
                ),
                child: _buildInfoItem(context),
              ),
            ),
          ),
          context: context,
        ),
      ],
    );
  }

  Widget _buildShimmerCard({
    double? height,
    required Widget child,
    required BuildContext context,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
      ),
      child: Container(
        width: double.infinity,
        height: height,
        padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: child,
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context) {
    return Row(
      children: [
        Container(
          width: ResponsiveHelper.w(100, context),
          height: isTablet
              ? ResponsiveHelper.h(16, context)
              : ResponsiveHelper.h(14, context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(4, context)),
          ),
        ),
        SizedBox(width: ResponsiveHelper.w(16, context)),
        Expanded(
          child: Container(
            height: isTablet
                ? ResponsiveHelper.h(16, context)
                : ResponsiveHelper.h(14, context),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.r(4, context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Container(
      width: ResponsiveHelper.w(70, context),
      height: ResponsiveHelper.h(32, context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(8, context)),
      ),
    );
  }
}
