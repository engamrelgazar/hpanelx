import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Function()? onBackPressed;
  final bool centerTitle;
  final double bottomRadius;
  final Widget? bottom;
  final double elevation;

  const AppHeader({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle = true,
    this.bottomRadius = 0,
    this.bottom,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize:
              isTablet
                  ? ResponsiveHelper.sp(24, context)
                  : ResponsiveHelper.sp(20, context),
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
              : null,
      actions: actions,
      bottom:
          bottom != null
              ? PreferredSize(
                preferredSize: Size.fromHeight(
                  bottom is PreferredSizeWidget
                      ? (bottom as PreferredSizeWidget).preferredSize.height
                      : 56,
                ),
                child: bottom!,
              )
              : null,
      shape:
          bottomRadius > 0
              ? RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(bottomRadius),
                  bottomRight: Radius.circular(bottomRadius),
                ),
              )
              : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    bottom != null
        ? kToolbarHeight +
            (bottom is PreferredSizeWidget
                ? (bottom as PreferredSizeWidget).preferredSize.height
                : 56)
        : kToolbarHeight,
  );
}

// Widget لإضافة حقل البحث تحت AppBar
class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final VoidCallback? onClear;
  final bool isSearching;

  const SearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onClear,
    this.isSearching = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16, context)),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(ResponsiveHelper.r(24, context)),
          bottomRight: Radius.circular(ResponsiveHelper.r(24, context)),
        ),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withAlpha(180)),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon:
              isSearching
                  ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: onClear,
                  )
                  : null,
          filled: true,
          fillColor: Colors.white.withAlpha(50),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.r(12, context),
            ),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.h(12, context),
          ),
        ),
      ),
    );
  }
}
