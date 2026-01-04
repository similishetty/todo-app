class AppException implements Exception{
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException{
  NetworkException(super.message);
}