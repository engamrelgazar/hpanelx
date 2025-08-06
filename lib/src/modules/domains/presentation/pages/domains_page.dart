import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';
import 'package:hpanelx/src/core/widgets/app_header.dart';
import 'package:hpanelx/src/core/widgets/search_field.dart';
import 'package:hpanelx/src/modules/domains/presentation/bloc/domains_bloc.dart';
import 'package:hpanelx/src/modules/domains/presentation/widgets/domain_card.dart';
import 'package:hpanelx/src/modules/domains/presentation/widgets/domain_shimmer.dart';
import 'package:hpanelx/src/modules/domains/presentation/widgets/domain_checker_sheet.dart';

class DomainsPage extends StatefulWidget {
  const DomainsPage({super.key});

  @override
  State<DomainsPage> createState() => _DomainsPageState();
}

class _DomainsPageState extends State<DomainsPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    // Load domains when page is first opened
    context.read<DomainsBloc>().add(LoadDomainsEvent());

    // Add listener to search field after a short delay to ensure bloc is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.addListener(_onSearchChanged);
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Cancel previous timer
    _searchDebounce?.cancel();

    // Set new timer for debounced search
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      final String query = _searchController.text.toLowerCase();
      final currentState = context.read<DomainsBloc>().state;

      // Update search using Bloc
      if (currentState is DomainsLoaded) {
        context.read<DomainsBloc>().add(SearchDomainsEvent(
              query: query,
              allDomains: currentState.domains,
            ));
      } else if (currentState is DomainsSearchActive) {
        context.read<DomainsBloc>().add(SearchDomainsEvent(
              query: query,
              allDomains: currentState.allDomains,
            ));
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<DomainsBloc>().add(ClearSearchEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      appBar: AppHeader(
        title: 'Domains',
        showBackButton: Navigator.canPop(context),
        actions: [
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
          BlocBuilder<DomainsBloc, DomainsState>(
            builder: (context, state) {
              final isSearching = state is DomainsSearchActive;
              return StandardSearchField(
                controller: _searchController,
                hintText: 'Search domains...',
                isSearching: isSearching,
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
                } else if (state is DomainsSearchActive) {
                  return _buildSearchState(context, state, isTablet);
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
    return _buildDomainList(state.domains, isTablet);
  }

  Widget _buildSearchState(
    BuildContext context,
    DomainsSearchActive state,
    bool isTablet,
  ) {
    return _buildDomainList(state.filteredDomains, isTablet);
  }

  Widget _buildDomainList(List<dynamic> domains, bool isTablet) {
    if (domains.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.domain_disabled,
              size: ResponsiveHelper.responsiveIconSize(context, 80),
              color: Colors.grey.shade400,
            ),
            SizedBox(height: ResponsiveHelper.h(16, context)),
            Text(
              'No domains found',
              style: TextStyle(
                fontSize: ResponsiveHelper.sp(18, context),
                color: Colors.grey.shade600,
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
        return Padding(
          padding: EdgeInsets.only(bottom: ResponsiveHelper.h(12, context)),
          child: DomainCard(
            domain: domain,
            isTablet: isTablet,
          ),
        );
      },
    );
  }

  Widget _buildErrorState(DomainsError state, bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: ResponsiveHelper.responsiveIconSize(context, 80),
            color: Colors.red.shade400,
          ),
          SizedBox(height: ResponsiveHelper.h(16, context)),
          Text(
            'Error loading domains',
            style: TextStyle(
              fontSize: ResponsiveHelper.sp(18, context),
              color: Colors.red.shade600,
            ),
          ),
          SizedBox(height: ResponsiveHelper.h(8, context)),
          Text(
            state.message,
            style: TextStyle(
              fontSize: ResponsiveHelper.sp(14, context),
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveHelper.h(16, context)),
          ElevatedButton(
            onPressed: () {
              context.read<DomainsBloc>().add(LoadDomainsEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showDomainCheckerDialog(BuildContext context, bool isTablet) {
    final domainsBloc = context.read<DomainsBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (context) => BlocProvider.value(
        value: domainsBloc,
        child: DomainCheckerSheet(isTablet: isTablet),
      ),
    );
  }
}
