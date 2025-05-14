import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:shimmer/shimmer.dart';

class VmShimmerLoading extends StatelessWidget {
  final bool isTablet;

  const VmShimmerLoading({super.key, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
      itemCount: 6, // Show 6 shimmer cards
      itemBuilder: (context, index) {
        return _buildVmShimmerCard(context);
      },
    );
  }

  Widget _buildVmShimmerCard(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16, context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hostname and Status Badge
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height:
                          isTablet
                              ? ResponsiveHelper.h(18, context)
                              : ResponsiveHelper.h(16, context),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.r(4, context),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(12, context)),
                  // Status badge
                  Container(
                    width: ResponsiveHelper.w(80, context),
                    height:
                        isTablet
                            ? ResponsiveHelper.h(22, context)
                            : ResponsiveHelper.h(20, context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.r(16, context),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(12, context)),

              // Plan
              _buildInfoRow(
                ResponsiveHelper.w(isTablet ? 150 : 130, context),
                context,
              ),
              SizedBox(height: ResponsiveHelper.h(8, context)),

              // IP Address
              _buildInfoRow(
                ResponsiveHelper.w(isTablet ? 180 : 160, context),
                context,
              ),
              SizedBox(height: ResponsiveHelper.h(8, context)),

              // Specs row
              _buildSpecsRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(double width, BuildContext context) {
    return Row(
      children: [
        // Icon
        Container(
          width:
              isTablet
                  ? ResponsiveHelper.w(18, context)
                  : ResponsiveHelper.w(16, context),
          height:
              isTablet
                  ? ResponsiveHelper.h(18, context)
                  : ResponsiveHelper.h(16, context),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: ResponsiveHelper.w(6, context)),
        // Text
        Container(
          width: width,
          height:
              isTablet
                  ? ResponsiveHelper.h(16, context)
                  : ResponsiveHelper.h(14, context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(4, context)),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSpecItem(context),
        _buildSpecItem(context),
        _buildSpecItem(context),
      ],
    );
  }

  Widget _buildSpecItem(BuildContext context) {
    return Column(
      children: [
        // Icon
        Container(
          width:
              isTablet
                  ? ResponsiveHelper.w(20, context)
                  : ResponsiveHelper.w(18, context),
          height:
              isTablet
                  ? ResponsiveHelper.h(20, context)
                  : ResponsiveHelper.h(18, context),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(4, context)),
        // Label
        Container(
          width:
              isTablet
                  ? ResponsiveHelper.w(30, context)
                  : ResponsiveHelper.w(26, context),
          height:
              isTablet
                  ? ResponsiveHelper.h(12, context)
                  : ResponsiveHelper.h(10, context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(2, context)),
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(2, context)),
        // Value
        Container(
          width:
              isTablet
                  ? ResponsiveHelper.w(40, context)
                  : ResponsiveHelper.w(36, context),
          height:
              isTablet
                  ? ResponsiveHelper.h(14, context)
                  : ResponsiveHelper.h(12, context),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(2, context)),
          ),
        ),
      ],
    );
  }
}
