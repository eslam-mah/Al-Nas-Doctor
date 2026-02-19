import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:alnas_doctor/features/chat/data/models/request_model.dart';
import 'package:alnas_doctor/features/chat/view_model/accept_pending_request_cubit/accept_request_cubit.dart';
import 'package:alnas_doctor/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestItem extends StatelessWidget {
  final RequestData request;

  const RequestItem({super.key, required this.request});

  // ── Status helpers ──────────────────────────────────────────────
  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return const Color(0xFF00C853);
      case 'rejected':
        return const Color(0xFFFF1744);
      case 'pending':
        return const Color(0xFFFFAB00);
      default:
        return AlNasTheme.grey40;
    }
  }

  IconData _statusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      case 'pending':
        return Icons.schedule_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _statusLabel(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      case 'pending':
        return 'Pending';
      default:
        return status ?? 'Unknown';
    }
  }

  List<Color> _accentGradient(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return [const Color(0xFF00C853), const Color(0xFF69F0AE)];
      case 'rejected':
        return [const Color(0xFFFF1744), const Color(0xFFFF8A80)];
      case 'pending':
        return [const Color(0xFFFFAB00), const Color(0xFFFFE57F)];
      default:
        return [AlNasTheme.blue100, AlNasTheme.blue60];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _accentGradient(request.status);
    final sColor = _statusColor(request.status);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: sColor.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // ── Gradient left accent bar ──
              Container(
                width: 5.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: colors,
                  ),
                ),
              ),

              // ── Card content ──
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  child: Column(
                    children: [
                      // ── Top row: Avatar + Name + Date ──
                      Row(
                        children: [
                          // Avatar with gradient ring
                          Container(
                            padding: EdgeInsets.all(2.5.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: colors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 22.r,
                              backgroundColor: Colors.white,
                              child: Text(
                                request.patientName
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    "P",
                                style: TextStyle(
                                  color: sColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Name + specialty
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.patientName ??
                                      "Patient #${request.patientId}",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AlNasTheme.textDark,
                                    letterSpacing: 0.1,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.medical_services_outlined,
                                      size: 13.sp,
                                      color: AlNasTheme.textMuted,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      request.specialty ?? "General",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: AlNasTheme.textMuted,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Date
                          if (request.createdAt != null)
                            Text(
                              _formatDate(request.createdAt!),
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AlNasTheme.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // ── Bottom row: Status Badge + Accept button ──
                      Row(
                        children: [
                          // Status chip
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: sColor.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: sColor.withValues(alpha: 0.25),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _statusIcon(request.status),
                                  size: 14.sp,
                                  color: sColor,
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  _statusLabel(request.status),
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                    color: sColor,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // Accept button – gradient style
                          SizedBox(
                            height: 36.h,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (request.id != null) {
                                  context
                                      .read<AcceptRequestCubit>()
                                      .acceptRequest(requestId: request.id!);
                                }
                              },
                              icon: Icon(Icons.check_rounded, size: 18.sp),
                              label: Text(
                                S.of(context).accept,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00C853),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return dateStr;
    }
  }
}
