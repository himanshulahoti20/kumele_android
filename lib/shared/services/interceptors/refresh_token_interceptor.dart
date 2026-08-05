import 'package:dio/dio.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/utils/logout_helper.dart';

class RefreshInterceptor extends QueuedInterceptor {
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final dioResponse = err.response;
    final requestOptions = err.requestOptions;
    final isUnauthorized = dioResponse?.statusCode == ApiStatusCode.Unauthorized;
    final isRefreshCall = requestOptions.path.contains('/auth/refresh');
    final hasRetried = requestOptions.extra['retried'] == true;

    if (isUnauthorized && !isRefreshCall && !hasRetried && ApiService.hasToken()) {
      final refreshed = await ApiService.refreshAccessToken();
      if (refreshed) {
        requestOptions.extra['retried'] = true;
        try {
          final response = await ApiService.retryRequest(requestOptions);
          handler.resolve(response);
          return;
        } catch (_) {}
      }
    }

    if (isUnauthorized) {
      LogoutHelper.handleLogout(context: InjectionHelper.navKey.currentContext);
      handler.reject(err);
    } else {
      handler.next(err);
    }
  }
}
