import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:alnas_doctor/features/chat/data/models/message_model.dart';
import 'package:alnas_doctor/features/chat/view_model/chat_detail_cubit/chat_detail_cubit.dart';
import 'package:alnas_doctor/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ChatDetailPage extends StatefulWidget {
  static const String routeName = '/chat-detail';

  final int chatId;
  final int patientId;
  final int doctorId;
  final String patientName;

  const ChatDetailPage({
    super.key,
    required this.chatId,
    required this.patientId,
    required this.doctorId,
    required this.patientName,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<ChatDetailCubit>().initChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0, // reversed list: 0 is the bottom
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatDetailCubit>().sendMessage(text);
    _messageController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Column(
        children: [
          // ── Gradient Header ──
          _ChatHeader(
            patientName: widget.patientName,
            onBack: () => Navigator.of(context).pop(),
          ),

          // ── Connection Status Banner ──
          BlocBuilder<ChatDetailCubit, ChatDetailState>(
            buildWhen: (previous, current) {
              // Only rebuild for connection status changes
              return current is ChatDetailReconnecting ||
                  current is ChatDetailConnectionError ||
                  current is ChatDetailDisconnected ||
                  current is ChatDetailConnected;
            },
            builder: (context, state) {
              return _ConnectionBanner(state: state);
            },
          ),

          // ── Messages Area ──
          Expanded(
            child: BlocBuilder<ChatDetailCubit, ChatDetailState>(
              builder: (context, state) {
                final messages = _extractMessages(state);

                if (state is ChatDetailLoading && messages.isEmpty) {
                  return _buildLoadingState();
                }

                if (messages.isEmpty) {
                  return _buildEmptyState(context);
                }

                return _buildMessagesList(messages);
              },
            ),
          ),

          // ── Message Input ──
          _MessageInput(
            controller: _messageController,
            focusNode: _focusNode,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  List<MessageModel> _extractMessages(ChatDetailState state) {
    if (state is ChatDetailConnected) return state.messages;
    if (state is ChatDetailMessageReceived) return state.messages;
    if (state is ChatDetailMessageSent) return state.messages;
    if (state is ChatDetailDisconnected) return state.messages;
    if (state is ChatDetailReconnecting) return state.messages;
    if (state is ChatDetailConnectionError) return state.messages;
    return [];
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AlNasTheme.blue100.withValues(alpha: 0.12),
                  AlNasTheme.blue60.withValues(alpha: 0.06),
                ],
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 32.w,
                height: 32.w,
                child: CircularProgressIndicator(
                  strokeWidth: 3.w,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AlNasTheme.blue100,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            S.of(context).connectingToChat,
            style: TextStyle(
              fontSize: 15.sp,
              color: AlNasTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated chat icon
            Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0077B6).withValues(alpha: 0.10),
                    const Color(0xFF48CAE4).withValues(alpha: 0.06),
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.chat_rounded,
                    size: 50.sp,
                    color: const Color(0xFF00A3E6).withValues(alpha: 0.4),
                  ),
                  Positioned(
                    right: 22.w,
                    top: 22.w,
                    child: Container(
                      width: 18.w,
                      height: 18.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF48CAE4).withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              S.of(context).noMessagesYet,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: AlNasTheme.textDark,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              S.of(context).startConversation,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AlNasTheme.textMuted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList(List<MessageModel> messages) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true, // Messages grow from bottom to top
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      physics: const BouncingScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        // Since the list is reversed, index 0 = latest message
        final reversedIndex = messages.length - 1 - index;
        final message = messages[reversedIndex];
        final isMe = message.isSentByDoctor;

        // Decide when to show avatar and timestamp
        final bool isFirstInGroup =
            reversedIndex == 0 ||
            messages[reversedIndex - 1].senderType != message.senderType;
        final bool isLastInGroup =
            reversedIndex == messages.length - 1 ||
            messages[reversedIndex + 1].senderType != message.senderType;

        // Show date separator
        Widget? dateSeparator;
        if (reversedIndex == 0 ||
            !_isSameDay(
              messages[reversedIndex].createdAt,
              messages[reversedIndex - 1].createdAt,
            )) {
          dateSeparator = _DateSeparator(dateStr: message.createdAt ?? '');
        }

        return Column(
          children: [
            if (dateSeparator != null) dateSeparator,
            _MessageBubble(
              message: message,
              isMe: isMe,
              showAvatar: isLastInGroup && !isMe,
              showTime: isLastInGroup,
              isFirstInGroup: isFirstInGroup,
              isLastInGroup: isLastInGroup,
              patientName: widget.patientName,
            ),
          ],
        );
      },
    );
  }

  bool _isSameDay(String? date1, String? date2) {
    if (date1 == null || date2 == null) return false;
    try {
      final d1 = DateTime.parse(date1);
      final d2 = DateTime.parse(date2);
      return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
    } catch (_) {
      return false;
    }
  }
}

// ══════════════════════════════════════════════════════════════════
// DATE SEPARATOR
// ══════════════════════════════════════════════════════════════════
class _DateSeparator extends StatelessWidget {
  final String dateStr;

  const _DateSeparator({required this.dateStr});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Expanded(child: Divider(color: AlNasTheme.grey20, thickness: 0.5)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AlNasTheme.grey05,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                _formatDate(dateStr),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AlNasTheme.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(child: Divider(color: AlNasTheme.grey20, thickness: 0.5)),
        ],
      ),
    );
  }

  String _formatDate(String dateTimeStr) {
    try {
      final date = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        return 'Today';
      }
      final yesterday = now.subtract(const Duration(days: 1));
      if (date.year == yesterday.year &&
          date.month == yesterday.month &&
          date.day == yesterday.day) {
        return 'Yesterday';
      }
      return DateFormat.yMMMd().format(date);
    } catch (_) {
      return dateTimeStr;
    }
  }
}

// ══════════════════════════════════════════════════════════════════
// CHAT HEADER
// ══════════════════════════════════════════════════════════════════
class _ChatHeader extends StatelessWidget {
  final String patientName;
  final VoidCallback onBack;

  const _ChatHeader({required this.patientName, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0077B6), Color(0xFF00A3E6), Color(0xFF48CAE4)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0077B6).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(4.w, 8.h, 16.w, 14.h),
          child: Row(
            children: [
              // Back button
              IconButton(
                onPressed: onBack,
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
              // Patient avatar
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Text(
                    patientName.isNotEmpty ? patientName[0].toUpperCase() : 'P',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Patient info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    BlocBuilder<ChatDetailCubit, ChatDetailState>(
                      buildWhen: (previous, current) {
                        // Only rebuild for connection changes
                        return current is ChatDetailConnected ||
                            current is ChatDetailReconnecting ||
                            current is ChatDetailDisconnected ||
                            current is ChatDetailConnectionError ||
                            current is ChatDetailLoading;
                      },
                      builder: (context, state) {
                        String statusText = S.of(context).connecting;
                        Color dotColor = Colors.white.withValues(alpha: 0.5);

                        if (state is ChatDetailConnected ||
                            state is ChatDetailMessageReceived ||
                            state is ChatDetailMessageSent) {
                          statusText = S.of(context).online;
                          dotColor = const Color(0xFF69F0AE);
                        } else if (state is ChatDetailReconnecting) {
                          statusText = S.of(context).reconnecting;
                          dotColor = const Color(0xFFFFE57F);
                        } else if (state is ChatDetailDisconnected ||
                            state is ChatDetailConnectionError) {
                          statusText = S.of(context).offline;
                          dotColor = const Color(0xFFFF8A80);
                        }

                        return Row(
                          children: [
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: dotColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: dotColor.withValues(alpha: 0.6),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              statusText,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// CONNECTION BANNER
// ══════════════════════════════════════════════════════════════════
class _ConnectionBanner extends StatelessWidget {
  final ChatDetailState state;

  const _ConnectionBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is ChatDetailReconnecting) {
      return _buildBanner(
        icon: Icons.sync_rounded,
        text: S.of(context).reconnectingToChat,
        color: AlNasTheme.yellow100,
        bgColor: AlNasTheme.yellow20,
      );
    }

    if (state is ChatDetailConnectionError) {
      return _buildBanner(
        icon: Icons.wifi_off_rounded,
        text: S.of(context).connectionLost,
        color: AlNasTheme.red100,
        bgColor: AlNasTheme.red20,
        action: TextButton(
          onPressed: () => context.read<ChatDetailCubit>().retryConnection(),
          child: Text(
            S.of(context).retry,
            style: TextStyle(
              color: AlNasTheme.red100,
              fontWeight: FontWeight.w700,
              fontSize: 13.sp,
            ),
          ),
        ),
      );
    }

    if (state is ChatDetailDisconnected && _extractMessages(state).isNotEmpty) {
      return _buildBanner(
        icon: Icons.cloud_off_rounded,
        text: S.of(context).disconnected,
        color: AlNasTheme.grey60,
        bgColor: AlNasTheme.grey05,
        action: TextButton(
          onPressed: () => context.read<ChatDetailCubit>().retryConnection(),
          child: Text(
            S.of(context).reconnect,
            style: TextStyle(
              color: AlNasTheme.blue100,
              fontWeight: FontWeight.w700,
              fontSize: 13.sp,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  List<MessageModel> _extractMessages(ChatDetailState state) {
    if (state is ChatDetailDisconnected) return state.messages;
    return [];
  }

  Widget _buildBanner({
    required IconData icon,
    required String text,
    required Color color,
    required Color bgColor,
    Widget? action,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: bgColor,
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: color),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (action != null) action,
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
// MESSAGE BUBBLE
// ══════════════════════════════════════════════════════════════════
class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final bool showAvatar;
  final bool showTime;
  final bool isFirstInGroup;
  final bool isLastInGroup;
  final String patientName;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.showAvatar,
    required this.showTime,
    required this.isFirstInGroup,
    required this.isLastInGroup,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    // Tighter spacing within groups, more spacing between groups
    final bottomPadding = isLastInGroup ? 14.h : 2.h;

    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomPadding,
        left: isMe ? 56.w : 0,
        right: isMe ? 0 : 56.w,
      ),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Patient avatar (left side, only on last message in group)
          if (!isMe && showAvatar)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: CircleAvatar(
                radius: 14.r,
                backgroundColor: const Color(
                  0xFF0077B6,
                ).withValues(alpha: 0.12),
                child: Text(
                  patientName.isNotEmpty ? patientName[0].toUpperCase() : 'P',
                  style: TextStyle(
                    color: const Color(0xFF0077B6),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          else if (!isMe)
            SizedBox(width: 36.w), // space for avatar alignment
          // Message content
          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // The bubble
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 9.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: isMe
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF0077B6), Color(0xFF00A3E6)],
                          )
                        : null,
                    color: isMe ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        isMe || !isFirstInGroup ? 16.r : 16.r,
                      ),
                      topRight: Radius.circular(
                        !isMe || !isFirstInGroup ? 16.r : 16.r,
                      ),
                      bottomLeft: Radius.circular(
                        isMe
                            ? 16.r
                            : isLastInGroup
                            ? 4.r
                            : 16.r,
                      ),
                      bottomRight: Radius.circular(
                        isMe
                            ? isLastInGroup
                                  ? 4.r
                                  : 16.r
                            : 16.r,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isMe
                            ? const Color(0xFF0077B6).withValues(alpha: 0.15)
                            : Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.message ?? '',
                    style: TextStyle(
                      color: isMe ? Colors.white : AlNasTheme.textDark,
                      fontSize: 15.sp,
                      height: 1.4,
                    ),
                  ),
                ),

                // Timestamp (only on last message in group)
                if (showTime && message.createdAt != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, left: 4.w, right: 4.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.createdAt!),
                          style: TextStyle(
                            color: AlNasTheme.textMuted,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (isMe) ...[
                          SizedBox(width: 3.w),
                          Icon(
                            Icons.done_all_rounded,
                            size: 14.sp,
                            color: const Color(0xFF48CAE4),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String dateTimeStr) {
    try {
      final date = DateTime.parse(dateTimeStr);
      return DateFormat.jm().format(date);
    } catch (_) {
      return dateTimeStr;
    }
  }
}

// ══════════════════════════════════════════════════════════════════
// MESSAGE INPUT BAR
// ══════════════════════════════════════════════════════════════════
class _MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;

  const _MessageInput({
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  @override
  State<_MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.w, 10.h, 8.w, 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Text field
              Expanded(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 120.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: _hasText
                          ? AlNasTheme.blue100.withValues(alpha: 0.25)
                          : const Color(0xFFE8ECF0),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    maxLines: 5,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AlNasTheme.textDark,
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      hintText: S.of(context).typeAMessage,
                      hintStyle: TextStyle(
                        color: AlNasTheme.textMuted.withValues(alpha: 0.5),
                        fontSize: 15.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      filled: false,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              // Send button with smooth animation
              AnimatedScale(
                scale: _hasText ? 1.0 : 0.85,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: GestureDetector(
                  onTap: _hasText ? widget.onSend : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _hasText
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF0077B6), Color(0xFF00A3E6)],
                            )
                          : null,
                      color: _hasText ? null : const Color(0xFFE8ECF0),
                      boxShadow: _hasText
                          ? [
                              BoxShadow(
                                color: const Color(
                                  0xFF0077B6,
                                ).withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      color: _hasText ? Colors.white : AlNasTheme.grey40,
                      size: 22.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
