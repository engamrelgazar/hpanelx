import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/core/theme/app_theme.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:hpanelx/src/core/widgets/app_header.dart';
import 'package:hpanelx/src/core/widgets/search_field.dart';
import 'package:hpanelx/src/core/di/injection_container.dart';
import 'package:hpanelx/src/modules/domains/presentation/bloc/domains_bloc.dart';
import 'package:hpanelx/src/modules/domains/presentation/widgets/domain_card.dart';
import 'package:hpanelx/src/modules/domains/presentation/widgets/domain_shimmer.dart';
import 'package:hpanelx/src/modules/domains/presentation/widgets/domain_checker_sheet.dart';
import 'package:hpanelx/src/modules/domains/presentation/cubit/domain_checker_cubit.dart';
import 'package:hpanelx/src/modules/domains/presentation/cubit/domain_checker_sheet_cubit.dart';
import 'package:hpanelx/src/modules/domains/presentation/cubit/domain_search_cubit.dart';

class DomainsPage extends StatefulWidget {
  const DomainsPage({super.key});

  @override
  State<DomainsPage> createState() => _DomainsPageState();
}

class _DomainsPageState extends State<DomainsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load domains when page is first opened
    context.read<DomainsBloc>().add(LoadDomainsEvent());

    // Add listener to search field
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final String query = _searchController.text.toLowerCase();

    // Update search using Cubit
    if (context.read<DomainsBloc>().state is DomainsLoaded) {
      final state = context.read<DomainsBloc>().state as DomainsLoaded;
      context.read<DomainSearchCubit>().search(query, state.domains);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<DomainSearchCubit>().clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return BlocProvider(
      create: (context) => sl<DomainSearchCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppHeader(
              title: 'Domains',
              showBackButton: Navigator.canPop(context),
              actions: [
                // أيقونة Domain Checker
                IconButton(
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  tooltip: 'Domain Checker',
                  onPressed: () {
                    _showDomainCheckerDialog(context, isTablet);
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                // Search bar
                BlocBuilder<DomainSearchCubit, DomainSearchState>(
                  builder: (context, searchState) {
                    return StandardSearchField(
                      controller: _searchController,
                      hintText: 'Search domains...',
                      isSearching:
                          context.read<DomainSearchCubit>().isSearching,
                      onClear: _clearSearch,
                    );
                  },
                ),

                // Domain list
                Expanded(
                  child: BlocBuilder<DomainsBloc, DomainsState>(
                    builder: (context, state) {
                      if (state is DomainsLoading) {
                        return _buildLoadingState(isTablet);
                      } else if (state is DomainsLoaded) {
                        return _buildLoadedState(context, state, isTablet);
                      } else if (state is DomainsError) {
                        return _buildErrorState(state, isTablet);
                      } else {
                        return _buildLoadingState(isTablet);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(bool isTablet) {
    return ListView.builder(
      padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
      itemCount: 8, // Show 8 placeholders
      itemBuilder: (context, index) => DomainShimmer(isTablet: isTablet),
    );
  }

  Widget _buildLoadedState(
    BuildContext context,
    DomainsLoaded state,
    bool isTablet,
  ) {
    return BlocBuilder<DomainSearchCubit, DomainSearchState>(
      builder: (context, searchState) {
        final isSearching = context.read<DomainSearchCubit>().isSearching;
        final domains =
            isSearching
                ? context.read<DomainSearchCubit>().filteredDomains
                : state.domains;

        if (domains.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSearching ? Icons.search_off : Icons.domain_disabled,
                  size: ResponsiveHelper.sp(64, context),
                  color: Colors.grey,
                ),
                SizedBox(height: ResponsiveHelper.h(16, context)),
                Text(
                  isSearching
                      ? 'No domains match your search'
                      : 'No domains found',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.sp(18, context),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
          itemCount: domains.length,
          itemBuilder: (context, index) {
            final domain = domains[index];
            return DomainCard(domain: domain, isTablet: isTablet);
          },
        );
      },
    );
  }

  Widget _buildErrorState(DomainsError state, bool isTablet) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: ResponsiveHelper.sp(64, context),
              color: AppTheme.errorColor,
            ),
            SizedBox(height: ResponsiveHelper.h(16, context)),
            Text(
              'Failed to load domains',
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(20, context),
                fontWeight: FontWeight.bold,
                color: AppTheme.darkColor,
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(8, context)),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(16, context),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: ResponsiveHelper.h(24, context)),
            ElevatedButton.icon(
              onPressed: () {
                context.read<DomainsBloc>().add(LoadDomainsEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
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
      ),
    );
  }

  // إضافة Dialog لفحص النطاقات
  void _showDomainCheckerDialog(BuildContext context, bool isTablet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<DomainCheckerCubit>()),
              BlocProvider(create: (context) => sl<DomainCheckerSheetCubit>()),
            ],
            child: const DomainCheckerSheet(),
          ),
    );
  }
}
