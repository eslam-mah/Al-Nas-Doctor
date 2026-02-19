import 'package:alnas_doctor/core/config/alnas_theme.dart';
import 'package:alnas_doctor/features/authentication/view_model/logout_cubit/logout_cubit.dart';
import 'package:alnas_doctor/features/chat/view/views/messages_view.dart';
import 'package:alnas_doctor/features/chat/view_model/accept_pending_request_cubit/accept_request_cubit.dart';
import 'package:alnas_doctor/features/chat/view_model/close_chat_cubit/close_chat_cubit.dart';
import 'package:alnas_doctor/features/chat/view_model/get_chat_list_cubit/get_chat_list_cubit.dart';
import 'package:alnas_doctor/features/chat/view_model/get_pending_requests_cubit/get_pending_requests_cubit.dart';
import 'package:alnas_doctor/features/profile/view/views/profile_page.dart';
import 'package:alnas_doctor/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'patients_view.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/home';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  final List<Widget> _views = [
    const PatientsView(),
    const Center(child: Text('Schedule View')), // Placeholder
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetChatListCubit()..getChatList()),
        BlocProvider(
          create: (context) => GetPendingRequestsCubit()..getPendingRequests(),
        ),
        BlocProvider(create: (context) => AcceptRequestCubit()),
        BlocProvider(create: (context) => CloseChatCubit()),
      ],
      child: const MessagesView(),
    ), // Placeholder
    BlocProvider(
      create: (context) => LogoutCubit(),
      child: const ProfilePage(),
    ), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AlNasTheme.background,
      body: SafeArea(
        top: false, // Let the header handle the top area
        child: _views[_currentIndex],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor:
              AlNasTheme.blue100, // Matches "Patients" active state
          unselectedItemColor: AlNasTheme.textMuted,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12.sp,
          ),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_alt_outlined),
              activeIcon: const Icon(Icons.people_alt),
              label: S.of(context).patients,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              activeIcon: const Icon(Icons.calendar_today),
              label: S.of(context).schedule,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat_bubble_outline),
              activeIcon: const Icon(Icons.chat_bubble),
              label: S.of(context).messages,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outlined),
              activeIcon: const Icon(Icons.person),
              label: S.of(context).profile,
            ),
          ],
        ),
      ),
    );
  }
}
