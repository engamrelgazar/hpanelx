import 'package:flutter/material.dart';
import 'package:hpanelx/src/core/utils/responsive_helper.dart';

class StandardSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isSearching;
  final VoidCallback onClear;
  final Function(String)? onSubmitted;
  final bool autofocus;

  const StandardSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isSearching,
    required this.onClear,
    this.onSubmitted,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ResponsiveHelper.w(16, context),
        ResponsiveHelper.h(16, context),
        ResponsiveHelper.w(16, context),
        ResponsiveHelper.h(8, context),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              isSearching
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: onClear,
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.r(12, context),
            ),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.r(12, context),
            ),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.r(12, context),
            ),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.h(12, context),
          ),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
