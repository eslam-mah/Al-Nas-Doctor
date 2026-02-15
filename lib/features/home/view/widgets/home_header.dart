import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:alnas_doctor/core/services/http_service/user_session.dart';
import 'package:alnas_doctor/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'stat_card.dart';

class HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double collapsedHeight;
  final int totalPatients;
  final ValueChanged<String>? onSearchChanged;

  HomeHeaderDelegate({
    required this.expandedHeight,
    required this.collapsedHeight,
    this.onSearchChanged,
    this.totalPatients = 0,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Calculate progress from 0.0 (expanded) to 1.0 (collapsed)
    final double progress = shrinkOffset / (maxExtent - minExtent);
    // Clamp progress to 0.0 - 1.0
    final double opacity = (1.0 - progress).clamp(0.0, 1.0);
    final user = UserSession.instance.currentUser;

    return Container(
      decoration: BoxDecoration(
        color: AlNasTheme.blue100,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Content that stays visible (User Info & Search)
          Positioned(
            top: 50.h,
            left: 20.w,
            right: 20.w,
            child: Column(
              children: [
                // Top Row: User Info & Notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 45.w,
                          height: 45.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.local_hospital,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).welcomeBack,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${user?.userData?.fullName ?? ''} - ${user?.userData?.specialty ?? ''}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Search Bar
                Container(
                  height: 50.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(120.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextField(
                          onChanged: onSearchChanged,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: S.of(context).searchHint,
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats Row - Fades out as we scroll
          Positioned(
            bottom: 30.h,
            left: 20.w,
            right: 20.w,
            child: Opacity(
              opacity: opacity,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StatCard(
                      value: '$totalPatients',
                      label: S.of(context).total,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight;

  @override
  bool shouldRebuild(covariant HomeHeaderDelegate oldDelegate) {
    return oldDelegate.expandedHeight != expandedHeight ||
        oldDelegate.collapsedHeight != collapsedHeight ||
        oldDelegate.totalPatients != totalPatients;
  }
}
