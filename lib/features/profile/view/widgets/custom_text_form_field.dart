import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  /// The controller for the text field
  final TextEditingController? controller;

  /// The hint text to display when the field is empty
  final String? hintText;

  /// The label text to display above the field
  final String? labelText;

  /// The prefix icon to display before the text
  final IconData? prefixIcon;

  /// Custom prefix widget (overrides prefixIcon)
  final Widget? prefix;

  /// The suffix icon to display after the text
  final IconData? suffixIcon;

  /// Custom suffix widget (overrides suffixIcon)
  final Widget? suffix;

  /// Callback when suffix icon is tapped
  final VoidCallback? onSuffixTap;

  /// The keyboard type for the text field
  final TextInputType? keyboardType;

  /// Whether to obscure the text (for passwords)
  final bool obscureText;

  /// The validator function for form validation
  final String? Function(String?)? validator;

  /// Callback when the text changes
  final void Function(String)? onChanged;

  /// Callback when the field is submitted
  final void Function(String)? onFieldSubmitted;

  /// Callback when the field is tapped
  final VoidCallback? onTap;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether the field is read-only
  final bool readOnly;

  /// The maximum number of lines
  final int maxLines;

  /// The minimum number of lines
  final int? minLines;

  /// The maximum length of text
  final int? maxLength;

  /// The text input action (e.g., next, done)
  final TextInputAction? textInputAction;

  /// The focus node for the field
  final FocusNode? focusNode;

  /// Auto-validation mode
  final AutovalidateMode? autovalidateMode;

  /// Input formatters for text manipulation
  final List<TextInputFormatter>? inputFormatters;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  /// Initial value of the field
  final String? initialValue;

  /// Content padding
  final EdgeInsetsGeometry? contentPadding;

  /// Border radius
  final double? borderRadius;

  /// Filled background
  final bool filled;

  /// Fill color
  final Color? fillColor;

  /// Border color
  final Color? borderColor;

  /// Focused border color
  final Color? focusedBorderColor;

  /// Error border color
  final Color? errorBorderColor;

  /// Text style
  final TextStyle? textStyle;

  /// Hint style
  final TextStyle? hintStyle;

  /// Error style
  final TextStyle? errorStyle;

  /// Whether to enable autocorrect
  final bool autocorrect;

  /// Whether to enable suggestions
  final bool enableSuggestions;

  /// Text alignment
  final TextAlign textAlign;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.onSuffixTap,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.textInputAction,
    this.focusNode,
    this.autovalidateMode,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.initialValue,
    this.contentPadding,
    this.borderRadius,
    this.filled = false,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textStyle,
    this.hintStyle,
    this.errorStyle,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBorderRadius = borderRadius ?? 10.r;
    final defaultHintColor = AlNasTheme.textDark;

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 16.sp, color: defaultHintColor),
        hintStyle:
            hintStyle ?? TextStyle(fontSize: 16.sp, color: defaultHintColor),
        errorStyle: errorStyle,
        filled: filled,
        fillColor: fillColor,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: borderColor != null
              ? BorderSide(color: borderColor!)
              : const BorderSide(),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: borderColor != null
              ? BorderSide(color: borderColor!)
              : BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: BorderSide(
            color: focusedBorderColor ?? AlNasTheme.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: BorderSide(color: errorBorderColor ?? Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red,
            width: 2,
          ),
        ),
        prefixIcon:
            prefix ??
            (prefixIcon != null
                ? Icon(prefixIcon, color: defaultHintColor)
                : null),
        suffixIcon:
            suffix ??
            (suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(suffixIcon, color: defaultHintColor),
                  )
                : null),
      ),
      style:
          textStyle ?? TextStyle(fontSize: 16.sp, color: AlNasTheme.textDark),
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      textInputAction: textInputAction,
      autovalidateMode: autovalidateMode,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      textAlign: textAlign,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
    );
  }
}
