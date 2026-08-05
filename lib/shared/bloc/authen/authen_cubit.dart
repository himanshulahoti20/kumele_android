import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/shared/bloc/authen/authen_state.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/authen/authen_repo.dart';
import 'package:kuemele/shared/utils/storage_util.dart';

export 'authen_state.dart';

class AuthenCubit extends Cubit<AuthenState> {
  AuthenCubit() : super(AuthenState.init);
  int count = 0;

  Future<void> loginGoogle({required String token}) async {
    safeEmit(AuthenState.loading);
    await AuthenRepo.firebaseLogin(token: token)
        .then((data) {
          final accessToken = data?.data?.accessToken;
          final refreshToken = data?.data?.refreshToken;
          StorageUtil.storeItem(StorageKey.USER_TOKEN, accessToken);
          if (refreshToken != null) {
            StorageUtil.storeItem(StorageKey.USER_REFRESH_TOKEN, refreshToken);
          }
          ApiService.setToken(
            newToken: accessToken,
            newRefreshToken: refreshToken,
          );
          return safeEmit(AuthenState.loginSuccess);
        })
        .onError<ApiException>((e, s) => safeEmit(
              AuthenState.errorMessage(
                  e.error ?? ApiErrorMessage.APP_BLOC_ERROR),
            ))
        .onError<Exception>((e, s) => safeEmit(
              AuthenState.errorMessage(ApiErrorMessage.APP_UNKNOWN_ERROR),
            ));
  }

  Future<void> login({required String email, required String password}) async {
    safeEmit(AuthenState.loading);
    await AuthenRepo.login(email: email, password: password)
        .then((result) {
          switch (result) {
            case LoginTwoFactorChallengeResult():
              return safeEmit(
                AuthenState.errorMessage('Two factor authentication required'),
              );
            case LoginSessionResult(:final session):
              final accessToken = session.accessToken;
              final refreshToken = session.refreshToken;
              StorageUtil.storeItem(StorageKey.USER_TOKEN, accessToken);
              if (refreshToken != null) {
                StorageUtil.storeItem(
                  StorageKey.USER_REFRESH_TOKEN,
                  refreshToken,
                );
              }
              ApiService.setToken(
                newToken: accessToken,
                newRefreshToken: refreshToken,
              );
              return safeEmit(AuthenState.loginSuccess);
          }
        })
        .onError<ApiException>((e, s) => safeEmit(
              AuthenState.errorMessage(
                  e.error ?? ApiErrorMessage.APP_BLOC_ERROR),
            ))
        .onError<Exception>((e, s) => safeEmit(
              AuthenState.errorMessage(ApiErrorMessage.APP_UNKNOWN_ERROR),
            ));
  }

  Future<void> signup({required UserModel body}) async {
    safeEmit(AuthenState.loading);
    await AuthenRepo.register(body: body)
        .then((data) async {
          final accessToken = data?.data?.accessToken;
          final refreshToken = data?.data?.refreshToken;
          StorageUtil.storeItem(StorageKey.USER_TOKEN, accessToken);
          if (refreshToken != null) {
            StorageUtil.storeItem(StorageKey.USER_REFRESH_TOKEN, refreshToken);
          }
          ApiService.setToken(
            newToken: accessToken,
            newRefreshToken: refreshToken,
          );
          return safeEmit(AuthenState.registerSuccess);
        })
        .onError<ApiException>((e, s) => safeEmit(
              AuthenState.errorMessage(
                  e.error ?? ApiErrorMessage.APP_BLOC_ERROR),
            ))
        .onError<Exception>((e, s) => safeEmit(
              AuthenState.errorMessage(ApiErrorMessage.APP_UNKNOWN_ERROR),
            ));
  }

  Future<void> verifyEmail({required String email, required String otp}) async {
    safeEmit(AuthenState.loading);
  }
}
