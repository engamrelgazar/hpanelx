import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:hpanelx/src/modules/domains/data/models/domain_availability_model.dart';
import 'package:hpanelx/src/modules/domains/presentation/cubit/domain_checker_cubit.dart';
import 'package:hpanelx/src/modules/domains/presentation/cubit/domain_checker_sheet_cubit.dart';

class DomainCheckerSheet extends StatefulWidget {
  const DomainCheckerSheet({super.key});

  @override
  State<DomainCheckerSheet> createState() => _DomainCheckerSheetState();
}

class _DomainCheckerSheetState extends State<DomainCheckerSheet> {
  final TextEditingController _domainController = TextEditingController();
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
  void initState() {
    super.initState();
    context.read<DomainCheckerSheetCubit>().updateDomainText('');
  }

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

    context.read<DomainCheckerCubit>().checkDomainAvailability(domainsToCheck);
    context.read<DomainCheckerSheetCubit>().setHasSearched(true);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboardVisible = viewInsets.bottom > 0;

    // Update keyboard visibility in cubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DomainCheckerSheetCubit>().setKeyboardVisibility(
        isKeyboardVisible,
      );
    });

    return BlocBuilder<DomainCheckerSheetCubit, DomainCheckerSheetState>(
      builder: (context, uiState) {
        return BlocBuilder<DomainCheckerCubit, DomainCheckerState>(
          builder: (context, state) {
            return Padding(
              padding: viewInsets,
              child: Container(
                height: _calculateSheetHeight(
                  state,
                  uiState.isKeyboardVisible,
                  isTablet,
                  screenSize,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ResponsiveHelper.r(24, context)),
                    topRight: Radius.circular(ResponsiveHelper.r(24, context)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: (Colors.black.a * 0.1).toDouble(),
                        red: Colors.black.r.toDouble(),
                        green: Colors.black.g.toDouble(),
                        blue: Colors.black.b.toDouble(),
                      ),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: ResponsiveHelper.w(40, context),
                        height: ResponsiveHelper.h(5, context),
                        margin: EdgeInsets.only(
                          top: ResponsiveHelper.h(8, context),
                          bottom: ResponsiveHelper.h(16, context),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.r(10, context),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(16, context),
                      ),
                      child: Text(
                        'Domain Availability Checker',
                        style: TextStyle(
                          fontSize:
                              isTablet
                                  ? ResponsiveHelper.sp(24, context)
                                  : ResponsiveHelper.sp(20, context),
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkColor,
                        ),
                      ),
                    ),

                    SizedBox(height: ResponsiveHelper.h(16, context)),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(16, context),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _domainController,
                              decoration: InputDecoration(
                                hintText:
                                    'Enter domain name only (e.g. example)',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.r(12, context),
                                  ),
                                ),
                                helperText: 'Do not include .com, .net, etc.',
                                helperStyle: TextStyle(
                                  fontSize:
                                      isTablet
                                          ? ResponsiveHelper.sp(12, context)
                                          : ResponsiveHelper.sp(10, context),
                                  color: Colors.grey[600],
                                ),
                                suffixIcon:
                                    uiState.domainText.isNotEmpty
                                        ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            _domainController.clear();
                                            context
                                                .read<DomainCheckerSheetCubit>()
                                                .clearDomainText();
                                          },
                                        )
                                        : null,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                  RegExp(r'[.\s]'),
                                ),
                              ],
                              onChanged: (value) {
                                context
                                    .read<DomainCheckerSheetCubit>()
                                    .updateDomainText(value);
                              },
                              onSubmitted: (_) => _checkDomainAvailability(),
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.w(8, context)),
                          ElevatedButton(
                            onPressed: _checkDomainAvailability,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveHelper.h(16, context),
                                horizontal: ResponsiveHelper.w(16, context),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.r(12, context),
                                ),
                              ),
                            ),
                            child: const Icon(Icons.search),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: ResponsiveHelper.h(16, context)),

                    // Results section
                    if (state is DomainCheckerLoading)
                      _buildLoadingState(context, isTablet)
                    else if (state is DomainCheckerError)
                      _buildErrorState(context, state.message, isTablet)
                    else if (state is DomainCheckerLoaded &&
                        uiState.hasSearched)
                      _buildResultsState(context, state.results, isTablet)
                    else if (uiState.hasSearched)
                      _buildNoResultsState(context, isTablet)
                    else
                      _buildInitialState(context, isTablet),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  double _calculateSheetHeight(
    DomainCheckerState state,
    bool isKeyboardVisible,
    bool isTablet,
    Size screenSize,
  ) {
    if (isKeyboardVisible) {
      return screenSize.height * 0.95;
    }

    if (state is DomainCheckerLoaded) {
      final int resultCount = state.results.length;
      if (resultCount > 0) {
        // Max height for many results
        return screenSize.height * 0.7;
      }
    }

    // Default height for initial state or loading
    return screenSize.height * 0.45;
  }

  Widget _buildInitialState(BuildContext context, bool isTablet) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: ResponsiveHelper.sp(64, context),
              color: Colors.grey[400],
            ),
            SizedBox(height: ResponsiveHelper.h(16, context)),
            Text(
              'Enter a domain name to check availability',
              style: TextStyle(
                fontSize:
                    isTablet
                        ? ResponsiveHelper.sp(18, context)
                        : ResponsiveHelper.sp(16, context),
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, bool isTablet) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: ResponsiveHelper.w(48, context),
              height: ResponsiveHelper.h(48, context),
              child: const CircularProgressIndicator(),
            ),
            SizedBox(height: ResponsiveHelper.h(16, context)),
            Text(
              'Checking domain availability...',
              style: TextStyle(
                fontSize:
                    isTablet
                        ? ResponsiveHelper.sp(18, context)
                        : ResponsiveHelper.sp(16, context),
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, bool isTablet) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: ResponsiveHelper.sp(64, context),
              color: Colors.red[400],
            ),
            SizedBox(height: ResponsiveHelper.h(16, context)),
            Text(
              'Error checking domains',
              style: TextStyle(
                fontSize:
                    isTablet
                        ? ResponsiveHelper.sp(18, context)
                        : ResponsiveHelper.sp(16, context),
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(8, context)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(24, context),
              ),
              child: Text(
                message,
                style: TextStyle(
                  fontSize:
                      isTablet
                          ? ResponsiveHelper.sp(16, context)
                          : ResponsiveHelper.sp(14, context),
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(16, context)),
            ElevatedButton(
              onPressed: _checkDomainAvailability,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context, bool isTablet) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: ResponsiveHelper.sp(64, context),
              color: Colors.grey[400],
            ),
            SizedBox(height: ResponsiveHelper.h(16, context)),
            Text(
              'No domains found',
              style: TextStyle(
                fontSize:
                    isTablet
                        ? ResponsiveHelper.sp(18, context)
                        : ResponsiveHelper.sp(16, context),
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(8, context)),
            Text(
              'Try searching for a different domain',
              style: TextStyle(
                fontSize:
                    isTablet
                        ? ResponsiveHelper.sp(16, context)
                        : ResponsiveHelper.sp(14, context),
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsState(
    BuildContext context,
    List<DomainAvailabilityModel> results,
    bool isTablet,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(16, context),
            ),
            child: Text(
              'Domain Availability Results',
              style: TextStyle(
                fontSize:
                    isTablet
                        ? ResponsiveHelper.sp(18, context)
                        : ResponsiveHelper.sp(16, context),
                fontWeight: FontWeight.bold,
                color: AppTheme.darkColor,
              ),
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(8, context)),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(16, context),
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final domain = results[index];
                return _buildDomainResultCard(context, domain, isTablet);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainResultCard(
    BuildContext context,
    DomainAvailabilityModel domain,
    bool isTablet,
  ) {
    final bool isAvailable = domain.isAvailable;
    final Color statusColor = isAvailable ? Colors.green : Colors.red;
    final String statusText = isAvailable ? 'Available' : 'Taken';
    final IconData statusIcon = isAvailable ? Icons.check_circle : Icons.cancel;

    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(8, context)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(8, context)),
        side: BorderSide(
          color:
              isAvailable
                  ? Colors.green.withValues(
                    alpha: (Colors.green.a * 0.3).toDouble(),
                    red: Colors.green.r.toDouble(),
                    green: Colors.green.g.toDouble(),
                    blue: Colors.green.b.toDouble(),
                  )
                  : Colors.grey.withValues(
                    alpha: (Colors.grey.a * 0.3).toDouble(),
                    red: Colors.grey.r.toDouble(),
                    green: Colors.grey.g.toDouble(),
                    blue: Colors.grey.b.toDouble(),
                  ),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(16, context),
          vertical: ResponsiveHelper.h(8, context),
        ),
        title: Text(
          domain.domain,
          style: TextStyle(
            fontSize:
                isTablet
                    ? ResponsiveHelper.sp(16, context)
                    : ResponsiveHelper.sp(14, context),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle:
            isAvailable
                ? Text(
                  'Price: \$${domain.price?.toStringAsFixed(2)}/year',
                  style: TextStyle(
                    fontSize:
                        isTablet
                            ? ResponsiveHelper.sp(14, context)
                            : ResponsiveHelper.sp(12, context),
                    color: Colors.grey[700],
                  ),
                )
                : null,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(8, context),
                vertical: ResponsiveHelper.h(4, context),
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(
                  alpha: (statusColor.a * 0.1).toDouble(),
                  red: statusColor.r.toDouble(),
                  green: statusColor.g.toDouble(),
                  blue: statusColor.b.toDouble(),
                ),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.r(4, context),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    statusIcon,
                    color: statusColor,
                    size: ResponsiveHelper.sp(16, context),
                  ),
                  SizedBox(width: ResponsiveHelper.w(4, context)),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize:
                          isTablet
                              ? ResponsiveHelper.sp(14, context)
                              : ResponsiveHelper.sp(12, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (isAvailable) ...[
              SizedBox(height: ResponsiveHelper.h(4, context)),
              ElevatedButton(
                onPressed: () {
                  // Add to cart or register domain logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(8, context),
                    vertical: ResponsiveHelper.h(4, context),
                  ),
                  minimumSize: Size(
                    ResponsiveHelper.w(80, context),
                    ResponsiveHelper.h(24, context),
                  ),
                  textStyle: TextStyle(
                    fontSize:
                        isTablet
                            ? ResponsiveHelper.sp(12, context)
                            : ResponsiveHelper.sp(10, context),
                  ),
                ),
                child: const Text('Register'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
