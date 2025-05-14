# ResponsiveHelper Migration Guide

This guide helps you migrate from `flutter_screenutil` to our custom `ResponsiveHelper` for better responsiveness across different device sizes.

## Why Migrate?

- Better support for tablets and desktops
- More intuitive API for responsive design
- Consistent behavior across different screen sizes
- No need for initialization with specific design size

## Migration Steps

### 1. Import the ResponsiveHelper

Replace:
```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
```

With:
```dart
import 'package:hpanelx/src/core/utils/utils.dart';
```

### 2. Replace ScreenUtil Extensions

| ScreenUtil | ResponsiveHelper |
|------------|------------------|
| `10.w` | `ResponsiveHelper.w(10, context)` |
| `10.h` | `ResponsiveHelper.h(10, context)` |
| `10.r` | `ResponsiveHelper.r(10, context)` |
| `10.sp` | `ResponsiveHelper.sp(10, context)` or `ResponsiveHelper.responsiveFontSize(context, 10)` |

### 3. Replace ScreenUtilInit

Replace:
```dart
ScreenUtilInit(
  designSize: const Size(390, 844),
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (context, child) => YourWidget(),
)
```

With:
```dart
ResponsiveWrapper(
  child: YourWidget(),
)
```

### 4. Use ResponsiveBuilder for Different Layouts

```dart
ResponsiveBuilder(
  builder: (context, isMobile, isTablet, isDesktop) {
    if (isDesktop) {
      return DesktopLayout();
    } else if (isTablet) {
      return TabletLayout();
    } else {
      return MobileLayout();
    }
  },
)
```

### 5. Use Responsive Values

```dart
// Get different values based on screen size
final padding = ResponsiveHelper.responsiveValue(
  context: context,
  mobile: 8.0,
  tablet: 16.0,
  desktop: 24.0,
);

// Or use predefined responsive values
final padding = ResponsiveHelper.responsivePadding(context);
final spacing = ResponsiveHelper.responsiveSpacing(context);
```

### 6. Check Device Type

```dart
if (ResponsiveHelper.isMobile(context)) {
  // Mobile-specific code
} else if (ResponsiveHelper.isTablet(context)) {
  // Tablet-specific code
} else if (ResponsiveHelper.isDesktop(context)) {
  // Desktop-specific code
}
```

## Example Migration

### Before:
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12.r),
  ),
  child: Text(
    'Hello World',
    style: TextStyle(fontSize: 14.sp),
  ),
)
```

### After:
```dart
Container(
  padding: EdgeInsets.symmetric(
    horizontal: ResponsiveHelper.w(16, context),
    vertical: ResponsiveHelper.h(8, context),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(ResponsiveHelper.r(12, context)),
  ),
  child: Text(
    'Hello World',
    style: TextStyle(fontSize: ResponsiveHelper.sp(14, context)),
  ),
)
``` 