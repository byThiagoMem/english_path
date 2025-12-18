import 'package:flutter/material.dart';

import '../infra.dart';

/// Custom primary button for the application.
///
/// A styled FilledButton with rounded borders, icon support,
/// loading state, and customizable colors.
///
/// Usage example:
/// ```dart
/// // Basic button
/// PrimaryButton(
///   text: 'Continue',
///   onPressed: () {
///     // Button action
///   },
/// )
///
/// // Button with icon and loading state
/// PrimaryButton(
///   text: 'Save',
///   icon: Icons.save,
///   isLoading: isSaving,
///   onPressed: () async {
///     await saveData();
///   },
/// )
/// ```
class PrimaryButton extends StatelessWidget {
  /// Text displayed on the button
  final String text;

  /// Callback executed when the button is pressed.
  /// If null, the button will be disabled
  final VoidCallback? onPressed;

  /// If true, displays a CircularProgressIndicator and disables the button
  final bool isLoading;

  /// Button background color. If null, uses theme's primaryColor
  final Color? backgroundColor;

  /// Text and icon color. Default: Colors.white
  final Color? textColor;

  /// Button width. If null, takes full available width
  final double? width;

  /// Button height. Default: 48
  final double height;

  /// Optional icon displayed to the left of the text
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.bodyMedium(
                      fontWeight: FontWeight.w600,
                      color: textColor ?? Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
