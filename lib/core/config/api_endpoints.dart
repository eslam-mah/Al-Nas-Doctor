class ApiEndpoints {
  ApiEndpoints._();
  static const String doctorLogin = '/routes/api.php?api=doctor_login';
  static const String doctorChangePassword =
      '/routes/api.php?api=doctor_change_password';
  static const String doctorLogout = '/routes/api.php?api=doctor_logout';
  static const String getPatients = '/routes/api.php?api=get_patients';
  static const String chatRequestsPending =
      '/routes/api.php?api=chat_requests_pending';
  static const String chatRequestAccept =
      '/routes/api.php?api=chat_request_accept';
  static const String chatList = '/routes/api.php?api=chat_list';
  static const String chatClose = '/routes/api.php?api=chat_close';
  static const String chatMessages = '/routes/api.php?api=chat_messages';
}
