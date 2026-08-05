import 'dart:convert';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';

class PasskeyOptionsParser {
  PasskeyOptionsParser._();

  static String toJsonString(dynamic response) {
    final options = _extractOptions(response);
    if (options == null || !options.containsKey('challenge')) {
      throw ApiException(error: 'Invalid passkey options from server');
    }
    return jsonEncode(options);
  }

  static Map<String, dynamic>? _extractOptions(dynamic response) {
    if (response is! Map<String, dynamic>) {
      return null;
    }

    final data = ApiService.extractMap(response);
    if (data.containsKey('challenge')) {
      return data;
    }

    final publicKey = data['publicKey'];
    if (publicKey is Map<String, dynamic> &&
        publicKey.containsKey('challenge')) {
      return publicKey;
    }

    final options = data['options'];
    if (options is Map<String, dynamic> && options.containsKey('challenge')) {
      return options;
    }

    if (response.containsKey('challenge')) {
      return response;
    }

    return null;
  }
}
