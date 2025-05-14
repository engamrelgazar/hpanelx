import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hpanelx/src/modules/domains/data/models/domain_model.dart';

// حالات البحث
abstract class DomainSearchState extends Equatable {
  const DomainSearchState();

  @override
  List<Object?> get props => [];
}

// حالة البحث الأولية (لا يوجد بحث)
class DomainSearchInitial extends DomainSearchState {}

// حالة البحث النشط
class DomainSearchActive extends DomainSearchState {
  final String query;
  final List<DomainModel> filteredDomains;

  const DomainSearchActive({
    required this.query,
    required this.filteredDomains,
  });

  @override
  List<Object?> get props => [query, filteredDomains];
}

// Cubit لإدارة حالة البحث
class DomainSearchCubit extends Cubit<DomainSearchState> {
  DomainSearchCubit() : super(DomainSearchInitial());

  // تحديث نتائج البحث
  void search(String query, List<DomainModel> allDomains) {
    if (query.isEmpty) {
      emit(DomainSearchInitial());
      return;
    }

    final lowerCaseQuery = query.toLowerCase();
    final filteredDomains =
        allDomains
            .where(
              (domain) => domain.domain.toLowerCase().contains(lowerCaseQuery),
            )
            .toList();

    emit(DomainSearchActive(query: query, filteredDomains: filteredDomains));
  }

  // مسح البحث
  void clearSearch() {
    emit(DomainSearchInitial());
  }

  // التحقق مما إذا كان البحث نشطًا
  bool get isSearching => state is DomainSearchActive;

  // الحصول على نتائج البحث المصفاة
  List<DomainModel> get filteredDomains {
    if (state is DomainSearchActive) {
      return (state as DomainSearchActive).filteredDomains;
    }
    return [];
  }
}
