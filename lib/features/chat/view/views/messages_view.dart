import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:alnas_doctor/features/chat/view/widgets/chat_list_item.dart';
import 'package:alnas_doctor/features/chat/view/widgets/request_item.dart';
import 'package:alnas_doctor/features/chat/view_model/accept_pending_request_cubit/accept_request_cubit.dart';
import 'package:alnas_doctor/features/chat/view_model/get_chat_list_cubit/get_chat_list_cubit.dart';
import 'package:alnas_doctor/features/chat/view_model/get_pending_requests_cubit/get_pending_requests_cubit.dart';
import 'package:alnas_doctor/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            // ── Custom gradient header ──
            _MessagesHeader(),
            // ── Tab content ──
            const Expanded(
              child: TabBarView(
                children: [_PendingRequestsList(), _ChatList()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// GRADIENT HEADER with custom tab bar
// ══════════════════════════════════════════════════════════════════
class _MessagesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0077B6), // deep ocean blue
            Color(0xFF00A3E6), // primary blue
            Color(0xFF48CAE4), // lighter teal
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0077B6).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Title row ──
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: Row(
                children: [
                  // Decorative icon
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      Icons.forum_rounded,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).messages,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        S.of(context).manageYourConversation,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 18.h),

            // ── Custom pill tab bar ──
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: const Color(0xFF0077B6),
                unselectedLabelColor: Colors.white.withValues(alpha: 0.85),
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                splashFactory: NoSplash.splashFactory,
                tabs: [
                  Tab(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pending_actions_rounded, size: 18.sp),
                        SizedBox(width: 6.w),
                        Text(S.of(context).chatRequests),
                      ],
                    ),
                  ),
                  Tab(
                    height: 40.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_rounded, size: 18.sp),
                        SizedBox(width: 6.w),
                        Text(S.of(context).chats),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// PENDING REQUESTS TAB
// ══════════════════════════════════════════════════════════════════
class _PendingRequestsList extends StatelessWidget {
  const _PendingRequestsList();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AcceptRequestCubit, AcceptRequestState>(
      listener: (context, state) {
        if (state is AcceptRequestSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text('Request Accepted Successfully'),
                ],
              ),
              backgroundColor: const Color(0xFF00C853),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
          context.read<GetPendingRequestsCubit>().getPendingRequests();
        } else if (state is AcceptRequestFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.errorMessage.message ?? 'Error accepting request',
                    ),
                  ),
                ],
              ),
              backgroundColor: AlNasTheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      child: BlocBuilder<GetPendingRequestsCubit, GetPendingRequestsState>(
        builder: (context, state) {
          if (state is GetPendingRequestsLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 48.w,
                    height: 48.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.w,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF00A3E6),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading requests...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AlNasTheme.textMuted,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is GetPendingRequestsFailure) {
            return _ErrorState(
              message: state.errorMessage,
              icon: Icons.wifi_off_rounded,
            );
          } else if (state is GetPendingRequestsSuccess) {
            final requests = state.requests.requests ?? [];
            if (requests.isEmpty) {
              return _EmptyState(
                icon: Icons.mark_email_read_rounded,
                title: S.of(context).noChatRequests,
                subtitle: 'New requests will appear here',
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              physics: const BouncingScrollPhysics(),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return RequestItem(request: requests[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// CHAT LIST TAB
// ══════════════════════════════════════════════════════════════════
class _ChatList extends StatelessWidget {
  const _ChatList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetChatListCubit, GetChatListState>(
      builder: (context, state) {
        if (state is GetChatListLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 48.w,
                  height: 48.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.w,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF00A3E6),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Loading chats...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AlNasTheme.textMuted,
                  ),
                ),
              ],
            ),
          );
        } else if (state is GetChatListFailure) {
          return _ErrorState(
            message: state.errorMessage,
            icon: Icons.wifi_off_rounded,
          );
        } else if (state is GetChatListSuccess) {
          final chats = state.chatModel;
          if (chats.isEmpty) {
            return _EmptyState(
              icon: Icons.chat_bubble_outline_rounded,
              title: S.of(context).noChats,
              subtitle: 'Start chatting with your patients',
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            physics: const BouncingScrollPhysics(),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return ChatListItem(chat: chats[index]);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// SHARED UI: Empty State
// ══════════════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gradient circle with icon
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF00A3E6).withValues(alpha: 0.12),
                    const Color(0xFF48CAE4).withValues(alpha: 0.06),
                  ],
                ),
              ),
              child: Icon(
                icon,
                size: 48.sp,
                color: const Color(0xFF00A3E6).withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AlNasTheme.textDark,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AlNasTheme.textMuted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// SHARED UI: Error State
// ══════════════════════════════════════════════════════════════════
class _ErrorState extends StatelessWidget {
  final String message;
  final IconData icon;

  const _ErrorState({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AlNasTheme.error.withValues(alpha: 0.08),
              ),
              child: Icon(
                icon,
                size: 40.sp,
                color: AlNasTheme.error.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AlNasTheme.error,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
