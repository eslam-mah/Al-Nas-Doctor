import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:alnas_doctor/features/chat/data/models/chat_model.dart';
import 'package:alnas_doctor/features/chat/view/views/chat_detail_page.dart';
import 'package:alnas_doctor/features/chat/view_model/close_chat_cubit/close_chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatListItem extends StatelessWidget {
  final ChatData chat;

  const ChatListItem({super.key, required this.chat});

  // ── Status helpers ──────────────────────────────────────────────
  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return const Color(0xFF00C853); // vibrant green
      case 'closed':
        return const Color(0xFFFF1744); // vibrant red
      case 'pending':
        return const Color(0xFFFFAB00); // vibrant amber
      default:
        return AlNasTheme.grey40;
    }
  }

  IconData _statusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Icons.check_circle_rounded;
      case 'closed':
        return Icons.cancel_rounded;
      case 'pending':
        return Icons.schedule_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _statusLabel(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'closed':
        return 'Closed';
      case 'pending':
        return 'Pending';
      default:
        return status ?? 'Unknown';
    }
  }

  List<Color> _accentGradient(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return [const Color(0xFF00C853), const Color(0xFF69F0AE)];
      case 'closed':
        return [const Color(0xFFFF1744), const Color(0xFFFF8A80)];
      case 'pending':
        return [const Color(0xFFFFAB00), const Color(0xFFFFE57F)];
      default:
        return [AlNasTheme.blue100, AlNasTheme.blue60];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _accentGradient(chat.status);
    final sColor = _statusColor(chat.status);

    return InkWell(
      onTap: () {
        context.push(
          ChatDetailPage.routeName,
          extra: {
            'chat_id': chat.id!,
            'patient_id': chat.patientId!,
            'doctor_id': chat.doctorId!,
            'patient_name': chat.patientName ?? 'Patient',
            'is_closed': chat.status == 'closed',
          },
        );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
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
                        // ── Top row: Avatar + Name + Time ──
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
                                  chat.patientName
                                          ?.toString()
                                          .substring(0, 1)
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

                            // Name + last message
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chat.patientName ?? "Unknown Patient",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AlNasTheme.textDark,
                                      letterSpacing: 0.1,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (chat.lastMessage != null) ...[
                                    SizedBox(height: 3.h),
                                    Text(
                                      chat.lastMessage!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: AlNasTheme.textMuted,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Time
                            if (chat.lastMessageTime != null)
                              Text(
                                _formatTime(chat.lastMessageTime!),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AlNasTheme.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        // ── Bottom row: Status badge + action buttons ──
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
                                    _statusIcon(chat.status),
                                    size: 14.sp,
                                    color: sColor,
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    _statusLabel(chat.status),
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
                            if (chat.status != 'closed') ...[
                              // ── Open Chat button ──
                              _ActionButton(
                                icon: Icons.chat_bubble_rounded,
                                color: AlNasTheme.blue100,
                                tooltip: 'Open Chat',
                                onTap: () {
                                  context.push(
                                    ChatDetailPage.routeName,
                                    extra: {
                                      'chat_id': chat.id!,
                                      'patient_id': chat.patientId!,
                                      'doctor_id': chat.doctorId!,
                                      'patient_name':
                                          chat.patientName ?? 'Patient',
                                      'is_closed': chat.status == 'closed',
                                    },
                                  );
                                },
                              ),
                              // SizedBox(width: 8.w),

                              // _ActionButton(
                              //   icon: Icons.close_rounded,
                              //   color: AlNasTheme.red100,
                              //   tooltip: 'Close Chat',
                              //   onTap: () {
                              //     context.read<CloseChatCubit>().closeChat(
                              //       chatId: chat.id!,
                              //     );
                              //   },
                              // ),
                            ],
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
      ),
    );
  }

  String _formatTime(String dateTimeStr) {
    try {
      final date = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        return DateFormat.jm().format(date);
      } else {
        return DateFormat.yMMMd().format(date);
      }
    } catch (_) {
      return dateTimeStr;
    }
  }
}

// ── Reusable action button ──────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          splashColor: color.withValues(alpha: 0.15),
          highlightColor: color.withValues(alpha: 0.08),
          child: Ink(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: color.withValues(alpha: 0.75),
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}
