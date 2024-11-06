class AppException implements Exception {
  final int type;
  final String message;

  const AppException(this.type, this.message);

  static AppException fromError(Error e) {
    return AppException(-1, e.toString());
  }

  static AppException fromException(Exception e) {
    return AppException(-2, e.toString());
  }
}
