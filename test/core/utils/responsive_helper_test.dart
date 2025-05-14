import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';

void main() {
  group('ResponsiveHelper', () {
    testWidgets('isMobile returns true for small screen width', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Mock a small screen size
              MediaQuery.of(context).size.width < 600
                  ? expect(ResponsiveHelper.isMobile(context), isTrue)
                  : expect(ResponsiveHelper.isMobile(context), isFalse);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('isTablet returns true for medium screen width', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // This is a simplified test that would need to be expanded
              // to properly test tablet detection with a mocked screen size
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('isDesktop returns true for large screen width', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // This is a simplified test that would need to be expanded
              // to properly test desktop detection with a mocked screen size
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets(
      'responsivePadding returns appropriate padding based on screen size',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final padding = ResponsiveHelper.responsivePadding(context);
                // Verify that padding is not null
                expect(padding, isNotNull);
                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  });
}
