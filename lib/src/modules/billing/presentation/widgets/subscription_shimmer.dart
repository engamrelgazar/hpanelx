import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:shimmer/shimmer.dart';

class SubscriptionShimmer extends StatelessWidget {
  final bool isTablet;

  const SubscriptionShimmer({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final double padding = isTablet
        ? ResponsiveHelper.w(20, context)
        : ResponsiveHelper.w(16, context);
    final double titleHeight = isTablet
        ? ResponsiveHelper.h(24, context)
        : ResponsiveHelper.h(20, context);
    final double lineHeight = isTablet
        ? ResponsiveHelper.h(16, context)
        : ResponsiveHelper.h(14, context);
    final double lineWidth = isTablet
        ? ResponsiveHelper.w(120, context)
        : ResponsiveHelper.w(100, context);
    final double statusWidth = isTablet
        ? ResponsiveHelper.w(80, context)
        : ResponsiveHelper.w(70, context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16, context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: ResponsiveHelper.w(200, context),
                    height: titleHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.r(4, context),
                      ),
                    ),
                  ),
                  Container(
                    width: statusWidth,
                    height: titleHeight * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.r(8, context),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.h(16, context)),
              _buildShimmerLine(context, lineWidth * 1.4, lineHeight),
              SizedBox(height: ResponsiveHelper.h(8, context)),
              _buildShimmerLine(context, lineWidth * 1.6, lineHeight),
              SizedBox(height: ResponsiveHelper.h(8, context)),
              _buildShimmerLine(context, lineWidth * 1.2, lineHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLine(BuildContext context, double width, double height) {
    return Row(
      children: [
        Container(
          width: ResponsiveHelper.w(20, context),
          height: ResponsiveHelper.h(20, context),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: ResponsiveHelper.w(8, context)),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(4, context)),
          ),
        ),
      ],
    );
  }
}
