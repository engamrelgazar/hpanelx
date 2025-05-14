import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:shimmer/shimmer.dart';

class SubscriptionShimmer extends StatelessWidget {
  final bool isTablet;

  const SubscriptionShimmer({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
      itemCount: 8, // Show 8 shimmer cards
      itemBuilder: (context, index) {
        return _buildSubscriptionShimmerCard(context);
      },
    );
  }

  Widget _buildSubscriptionShimmerCard(BuildContext context) {
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
              // Service name and status
              Row(
                children: [
                  Expanded(
                    flex: 3,
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
              SizedBox(height: ResponsiveHelper.h(16, context)),

              // Billing info
              Row(
                children: [
                  // Price
                  _buildInfoRow(
                    context,
                    isTablet
                        ? ResponsiveHelper.w(80, context)
                        : ResponsiveHelper.w(70, context),
                  ),
                  SizedBox(width: ResponsiveHelper.w(8, context)),
                  // Billing period
                  _buildInfoRow(
                    context,
                    isTablet
                        ? ResponsiveHelper.w(100, context)
                        : ResponsiveHelper.w(90, context),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(10, context)),

              // Dates info
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      context,
                      isTablet
                          ? ResponsiveHelper.w(150, context)
                          : ResponsiveHelper.w(130, context),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(8, context)),
                  Expanded(
                    child: _buildInfoRow(
                      context,
                      isTablet
                          ? ResponsiveHelper.w(150, context)
                          : ResponsiveHelper.w(130, context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, double width) {
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
}
