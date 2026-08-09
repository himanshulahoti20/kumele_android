import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/services/api_service/generated/generated_api_catalog_lookup.dart';

class TicketsRepo extends ApiService {
  static Future<TicketItem?> createEventTicket(String eventId) async {
    final api = GeneratedApiOperations.createEventTicket;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': eventId},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<TicketItem?>(
      () => TicketItem.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<TicketItem?> getTicket(String ticketId) async {
    final api = GeneratedApiOperations.getTicket;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': ticketId},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<TicketItem?>(
      () => TicketItem.fromJson(ApiService.extractMap(response)),
    );
  }

  static Future<bool> cancelTicket(String ticketId) async {
    final api = GeneratedApiOperations.cancelTicket;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': ticketId},
    );
    await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
    );
    return ApiService.handleResponse<bool>(() => true) ?? false;
  }

  static Future<TicketItem?> validateTicket({
    required String ticketId,
    required String ticketCode,
  }) async {
    final api = GeneratedApiOperations.validateTicket;
    final path = GeneratedApiOperations.resolvePath(
      api,
      pathValues: {'id': ticketId},
    );
    final response = await ApiService.callRequest(
      api.method.toRequestMethod(),
      path,
      api.operationId,
      body: {'ticketCode': ticketCode},
    );
    return ApiService.handleResponse<TicketItem?>(
      () => TicketItem.fromJson(ApiService.extractMap(response)),
    );
  }
}
