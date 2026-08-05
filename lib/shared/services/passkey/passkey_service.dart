import 'dart:io';

import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/authen/authen_repo.dart';

class PasskeyService {
  PasskeyService({PasskeyAuthenticator? authenticator})
      : _authenticator = authenticator ?? PasskeyAuthenticator();

  final PasskeyAuthenticator _authenticator;

  Future<AuthSession> login({required String email}) async {
    try {
      final optionsJson = await AuthenRepo.passkeyLoginStart(email: email);
      final request = AuthenticateRequestType.fromJsonString(optionsJson);
      final authenticatorResponse = await _authenticator.authenticate(request);
      final session = await AuthenRepo.passkeyLoginFinish(
        email: email,
        response: authenticatorResponse.toJson(),
      );
      if (session == null) {
        throw ApiException(
          error: 'Passkey login finish returned empty session',
        );
      }
      return session;
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(error: ExceptionMessages.from(error));
    }
  }

  Future<void> register({String? deviceName}) async {
    try {
      final optionsJson = await AuthenRepo.passkeyRegisterStart(
        deviceName: deviceName ?? _defaultDeviceName,
      );
      final request = RegisterRequestType.fromJsonString(optionsJson);
      final authenticatorResponse = await _authenticator.register(request);
      await AuthenRepo.passkeyRegisterFinish(
        response: authenticatorResponse.toJson(),
      );
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(error: ExceptionMessages.from(error));
    }
  }

  String get _defaultDeviceName {
    if (!Platform.isAndroid) {
      return 'Kumele device';
    }
    return 'Android ${Platform.operatingSystemVersion}';
  }
}
