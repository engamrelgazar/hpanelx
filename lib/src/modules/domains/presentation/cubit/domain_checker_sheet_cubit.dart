import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'domain_checker_sheet_state.dart';

class DomainCheckerSheetCubit extends Cubit<DomainCheckerSheetState> {
  DomainCheckerSheetCubit()
    : super(
        const DomainCheckerSheetState(
          hasSearched: false,
          isKeyboardVisible: false,
          domainText: '',
        ),
      );

  void setKeyboardVisibility(bool isVisible) {
    emit(state.copyWith(isKeyboardVisible: isVisible));
  }

  void setHasSearched(bool hasSearched) {
    emit(state.copyWith(hasSearched: hasSearched));
  }

  void updateDomainText(String text) {
    emit(state.copyWith(domainText: text));
  }

  void clearDomainText() {
    emit(state.copyWith(domainText: ''));
  }
}
