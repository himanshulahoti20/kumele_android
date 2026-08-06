import 'package:kuemele/shared/models/history_statistics_models.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';

class StatisticsRepo {
  static Future<MonthlyStats> getMonthlyStats({required int year}) async {
    final response = await ApiService.callRequest(
      RequestMethod.GET,
      '/users/me/stats/monthly',
      'UsersController_getMyStatsMonthly_v1',
      params: {'year': year},
    );
    return ApiService.handleResponse<MonthlyStats>(
      () => MonthlyStats.fromJson(ApiService.extractMap(response)),
    )!;
  }

  static Future<RewardStatus?> getRewardStatus(String userId) async {
    final response = await ApiService.callRequest(
      RequestMethod.GET,
      '/users/$userId/rewards',
      'UsersController_getRewardStatus_v1',
    );
    return ApiService.handleResponse<RewardStatus?>(
      () => RewardStatus.fromJson(ApiService.extractMap(response)),
    );
  }
}
