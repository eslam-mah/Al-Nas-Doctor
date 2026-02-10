import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDownWidget extends StatelessWidget {
  const CustomDropDownWidget({
    super.key,
    required this.selectedValue,
    required this.values,
    required this.onChanged,
    required this.borderColor,
    required this.hint,
  });

  final String? selectedValue;
  final List<String> values;
  final Function(String?) onChanged;
  final Color borderColor;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ), // Padding inside the box
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: borderColor, width: 1), // The grey border
        borderRadius: BorderRadius.circular(8.0),
        color: AlNasTheme.backgroundLight, // The rounded corners
      ),
      child: DropdownButtonHideUnderline(
        // Hides the default line
        child: DropdownButton<String>(
          isExpanded: true, // Forces the arrow to the far right
          hint: Text(
            hint,
            style: TextStyle(color: borderColor, fontSize: 16.sp),
          ), // The placeholder text
          value: selectedValue,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: borderColor,
          ), // Arrow styling
          items: values.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
