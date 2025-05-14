# HPanelX Tests

This directory contains the tests for the HPanelX Flutter application.

## Testing Approach

The application follows a comprehensive testing approach with the following types of tests:

1. **Unit Tests** - Test individual components in isolation
2. **Widget Tests** - Test UI components
3. **Integration Tests** - Test the integration between different components
4. **End-to-End Tests** - Test the application as a whole

## Test Structure

The tests follow the same structure as the application code:

```
test/
├── core/                      # Tests for core components
│   ├── api/                   # Tests for API client and utilities
│   ├── di/                    # Tests for dependency injection
│   ├── utils/                 # Tests for utilities
│   └── widgets/               # Tests for shared widgets
│
└── modules/                   # Tests for feature modules
    ├── billing/               # Tests for billing module
    ├── domains/               # Tests for domains module
    ├── home/                  # Tests for home module
    ├── startup/               # Tests for startup module
    └── vms/                   # Tests for virtual machines module
```

## Running Tests

To run all tests:

```bash
flutter test
```

To run a specific test:

```bash
flutter test test/path/to/test.dart
```

## Test Coverage

To generate a test coverage report:

```bash
flutter test --coverage
```

The coverage report will be generated in the `coverage/` directory.

## Mocking

The tests use the following approaches for mocking:

1. **Manual Mocks** - For simple mocks
2. **Mockito** - For more complex mocks

## Best Practices

1. **Test One Thing at a Time** - Each test should focus on testing one specific behavior
2. **Use Descriptive Test Names** - Test names should clearly describe what is being tested
3. **Follow the AAA Pattern** - Arrange, Act, Assert
4. **Keep Tests Independent** - Tests should not depend on each other
5. **Mock External Dependencies** - Use mocks for external dependencies
6. **Test Edge Cases** - Test boundary conditions and error cases
7. **Keep Tests Fast** - Tests should run quickly
8. **Keep Tests Maintainable** - Tests should be easy to maintain 