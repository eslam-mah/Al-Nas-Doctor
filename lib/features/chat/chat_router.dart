import 'package:alnas_doctor/features/chat/view/views/chat_detail_page.dart';
import 'package:alnas_doctor/features/chat/view_model/chat_detail_cubit/chat_detail_cubit.dart';
import 'package:alnas_doctor/features/chat/view_model/close_chat_cubit/close_chat_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatRouter {
  static final List<GoRoute> goRoutes = [
    GoRoute(
      path: ChatDetailPage.routeName,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ChatDetailCubit(
                chatId: extra['chat_id'] as int,
                patientId: extra['patient_id'] as int,
                doctorId: extra['doctor_id'] as int,
                patientName: extra['patient_name'] as String,
              ),
            ),
            BlocProvider(create: (context) => CloseChatCubit()),
          ],
          child: ChatDetailPage(
            chatId: extra['chat_id'] as int,
            patientId: extra['patient_id'] as int,
            doctorId: extra['doctor_id'] as int,
            patientName: extra['patient_name'] as String,
          ),
        );
      },
    ),
  ];
}
