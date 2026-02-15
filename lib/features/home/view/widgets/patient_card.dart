import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum PatientStatus { highRisk, warning, stable }

class PatientCard extends StatelessWidget {
  final String name;
  final String id;
  final String type;
  final String reading;
  final String unit;
  final PatientStatus status;
  final String statusText;
  final String? imagePath;

  const PatientCard({
    super.key,
    required this.name,
    required this.id,
    required this.type,
    required this.reading,
    required this.unit,
    required this.status,
    required this.statusText,
    this.imagePath,
  });

  Color _getStatusColor() {
    switch (status) {
      case PatientStatus.highRisk:
        return const Color(0xFFFF5252);
      case PatientStatus.warning:
        return const Color(0xFFFFAB40);
      case PatientStatus.stable:
        return const Color(0xFF4CAF50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20.r),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AlNasTheme.textDark.withValues(alpha: 0.1),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 28.r,
                        backgroundColor: AlNasTheme.blue20,
                        child: imagePath != null
                            ? ClipOval(
                                child: Image.asset(
                                  imagePath!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                name.substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  color: AlNasTheme.blue100,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                ),
                              ),
                      ),
                      SizedBox(width: 12.w),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AlNasTheme.textDark,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'ID: #$id',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AlNasTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Reading & Status
                      SizedBox(width: 16.w), // Space for the status line
                    ],
                  ),
                ),

                // Status indicator line
                Positioned(
                  right: 0,
                  top: 16.h,
                  bottom: 16.h,
                  child: Container(
                    width: 10.w,
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(10.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
