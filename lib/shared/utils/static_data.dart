import 'package:kuemele/shared/services/api_service/api_config.dart';

/// Compatibility aliases for legacy callers. New code should use ApiConfig.
class StaticData {
  StaticData._();

  static const String baseUrl = ApiConfig.baseUrl;
  static const String signupUrl = '$baseUrl/auth/signup';
  static const String loginUrl = '$baseUrl/auth/login';
  static const String verifyEmailUrl = '$baseUrl/auth/verify-email';
  static const String resendOtpUrl = '$baseUrl/auth/resend-verification';
  static const String resetPasswordUrl = '$baseUrl/auth/reset-password';
  static const String forgotPasswordUrl = '$baseUrl/auth/forgot-password';
}
