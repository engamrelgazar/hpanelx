part of 'domain_checker_sheet_cubit.dart';

class DomainCheckerSheetState extends Equatable {
  final bool hasSearched;
  final bool isKeyboardVisible;
  final String domainText;

  const DomainCheckerSheetState({
    required this.hasSearched,
    required this.isKeyboardVisible,
    required this.domainText,
  });

  DomainCheckerSheetState copyWith({
    bool? hasSearched,
    bool? isKeyboardVisible,
    String? domainText,
  }) {
    return DomainCheckerSheetState(
      hasSearched: hasSearched ?? this.hasSearched,
      isKeyboardVisible: isKeyboardVisible ?? this.isKeyboardVisible,
      domainText: domainText ?? this.domainText,
    );
  }

  @override
  List<Object> get props => [hasSearched, isKeyboardVisible, domainText];
}
