import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:hpanelx/src/modules/domains/data/models/domain_availability_model.dart';
import 'package:hpanelx/src/modules/domains/presentation/bloc/domains_bloc.dart';

class DomainCheckerSheet extends StatefulWidget {
  final bool isTablet;

  const DomainCheckerSheet({super.key, required this.isTablet});

  @override
  State<DomainCheckerSheet> createState() => _DomainCheckerSheetState();
}

class _DomainCheckerSheetState extends State<DomainCheckerSheet> {
  final TextEditingController _domainController = TextEditingController();
  bool _hasSearched = false;

  final List<String> _domainExtensions = [
    'com',
    'net',
    'org',
    'io',
    'info',
    'biz',
    'co',
    'me',
    'online',
    'xyz',
    'site',
    'store',
    'website',
    'tech',
    'app',
    'shop',
    'club',
  ];

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  void _checkDomainAvailability() {
    FocusScope.of(context).unfocus();

    if (_domainController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a domain name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String baseDomain = _domainController.text.trim();

    if (baseDomain.contains('.') || baseDomain.contains(' ')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter domain name without dots or spaces'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (baseDomain.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid domain name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    List<String> domainsToCheck =
        _domainExtensions.map((ext) => '$baseDomain.$ext').toList();

    context
        .read<DomainsBloc>()
        .add(CheckDomainAvailabilityEvent(domains: domainsToCheck));
    setState(() {
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ResponsiveHelper.r(20, context)),
              topRight: Radius.circular(ResponsiveHelper.r(20, context)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ResponsiveHelper.r(20, context)),
              topRight: Radius.circular(ResponsiveHelper.r(20, context)),
            ),
            child: Column(
              children: [
                // Handle bar with drag indicator
                Container(
                  margin: EdgeInsets.only(top: ResponsiveHelper.h(12, context)),
                  width: ResponsiveHelper.w(40, context),
                  height: ResponsiveHelper.h(4, context),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius:
                        BorderRadius.circular(ResponsiveHelper.r(2, context)),
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.all(ResponsiveHelper.w(24, context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with close button
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: ResponsiveHelper.responsiveIconSize(
                                  context, 24),
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: ResponsiveHelper.w(12, context)),
                            Expanded(
                              child: Text(
                                'Domain Availability Checker',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.sp(20, context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(
                                Icons.close,
                                size: ResponsiveHelper.responsiveIconSize(
                                    context, 24),
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.h(8, context)),
                        Text(
                          'Check if your desired domain names are available',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(14, context),
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.h(24, context)),

                        // Domain input
                        TextField(
                          controller: _domainController,
                          decoration: InputDecoration(
                            labelText: 'Domain Name',
                            hintText: 'Enter domain name (e.g., mywebsite)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.r(12, context)),
                            ),
                            prefixIcon: const Icon(Icons.domain),
                          ),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => _checkDomainAvailability(),
                        ),
                        SizedBox(height: ResponsiveHelper.h(16, context)),

                        // Check button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _checkDomainAvailability,
                            icon: const Icon(Icons.search),
                            label: const Text('Check Availability'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveHelper.h(16, context),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.r(12, context)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.h(24, context)),

                        // Results
                        if (_hasSearched)
                          BlocBuilder<DomainsBloc, DomainsState>(
                            builder: (context, state) {
                              DomainAvailabilityStatus? availabilityStatus;
                              List<DomainAvailabilityModel>?
                                  availabilityResults;
                              String? availabilityError;

                              if (state is DomainsLoaded) {
                                availabilityStatus = state.availabilityStatus;
                                availabilityResults = state.availabilityResults;
                                availabilityError = state.availabilityError;
                              } else if (state is DomainsSearchActive) {
                                availabilityStatus = state.availabilityStatus;
                                availabilityResults = state.availabilityResults;
                                availabilityError = state.availabilityError;
                              }

                              if (availabilityStatus ==
                                  DomainAvailabilityStatus.loading) {
                                return _buildLoadingState();
                              } else if (availabilityStatus ==
                                      DomainAvailabilityStatus.loaded &&
                                  availabilityResults != null) {
                                return _buildResultsState(availabilityResults);
                              } else if (availabilityStatus ==
                                      DomainAvailabilityStatus.error &&
                                  availabilityError != null) {
                                return _buildErrorState(availabilityError);
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: ResponsiveHelper.h(16, context)),
          Text(
            'Checking domain availability...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveHelper.sp(16, context),
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsState(List<DomainAvailabilityModel> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Results',
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(18, context),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(16, context)),
        ...results.map((result) => _buildResultCard(result)),
      ],
    );
  }

  Widget _buildResultCard(DomainAvailabilityModel result) {
    final isAvailable = result.isAvailable;

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12, context)),
      padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.green.shade50 : Colors.red.shade50,
        border: Border.all(
          color: isAvailable ? Colors.green.shade200 : Colors.red.shade200,
        ),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
      ),
      child: Row(
        children: [
          Icon(
            isAvailable ? Icons.check_circle : Icons.cancel,
            color: isAvailable ? Colors.green : Colors.red,
            size: ResponsiveHelper.responsiveIconSize(context, 20),
          ),
          SizedBox(width: ResponsiveHelper.w(12, context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.domain,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(16, context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  isAvailable ? 'Available' : 'Not Available',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(14, context),
                    color: isAvailable
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          border: Border.all(color: Colors.red.shade200),
          borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: ResponsiveHelper.responsiveIconSize(context, 20),
            ),
            SizedBox(width: ResponsiveHelper.w(12, context)),
            Flexible(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(14, context),
                  color: Colors.red.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
