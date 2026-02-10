class ApiEndpoints {
  ApiEndpoints._();

  static const String createRequest = '/public/index.php?api=create_request';
  static const String uploadFiles = '/public/index.php?api=upload_files';
  static const String track = '/public/index.php?api=track';
  static const String getPendingRequest =
      '/routes/api.php?api=get_pending_items';
  static const String updateRequest = '/routes/api.php?api=update_request';
  static const String registerFcmToken = '/routes/api.php?api=register_token';
}
