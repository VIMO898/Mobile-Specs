// ignore_for_file: public_member_api_docs, sort_constructors_first
class CustomException implements Exception {
  final String? code;
  final String message;
  const CustomException({
    this.code,
    required this.message,
  });
  @override
  String toString() {
    return 'CustomException: {code: $code, message: $message}';
  }
}
