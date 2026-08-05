import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kuemele/features/debug_tools/debug_model.dart';
import 'package:kuemele/shared/utils/utils.dart';

class DebugLogger {
  // ------------------------- For log and debug tool -------------------------
  // Các log cần wrap bởi try catch để chắc chắn không ảnh hưởng flow chính nếu có lỗi
  // trong lúc convert/parse/transform nhưng thông tin log này

  static var listLoggedAllRequest = <RequestLog>[];
  static var listLoggedRequestApi = <RequestLog>[];
  static var listLogged = <RequestLog>[];
  static var listError = <RequestLog>[];

  static void clearAllLoggedRequest() {
    listLoggedRequestApi.clear();
    listLogged.clear();
    listError.clear();
    listLoggedAllRequest.clear();
  }

  static void clearListLoggedRequest({required RequestLogType type}) {
    switch (type) {
      case RequestLogType.api:
        listLoggedRequestApi.clear();
        break;
      case RequestLogType.log:
        listLogged.clear();
      case RequestLogType.error:
        listError.clear();
        break;
    }
    listLoggedAllRequest.clear();
  }

  static void logRequest({
    required RequestLogType type,
    required String name,
    required String url,
    required String curl,
    required String requestTime,
    dynamic responseBody,
    int? statusCode,
    String? statusMessage,
  }) {
    if (!kDebugMode) return;
    String responseContent = '';
    try {
      responseContent = const JsonEncoder.withIndent('  ').convert(responseBody);
    } catch (e) {
      responseContent = responseBody.toString();
    }
    final data = RequestLog(
      type: type,
      name: name,
      curl: CurlModel(
        title: url,
        content: curl,
        time: requestTime,
      ),
      response: ResponseModel(
        title: url,
        content: responseContent,
        time: Utils.convertDateTimeToPatternTime(DateTime.now(), 'hh:mm:ss+SSS a'),
        statusCode: statusCode,
        statusMessage: statusMessage,
      ),
    );
    listLoggedAllRequest.add(data);
    switch (type) {
      case RequestLogType.api:
        listLoggedRequestApi.add(data);
        break;
      case RequestLogType.log:
        listLogged.add(data);
      case RequestLogType.error:
        listError.add(data);
        break;
    }
  }

  static void log({
    required String name,
    required String log,
  }) {
    if (!kDebugMode) return;
    final data = RequestLog(
      type: RequestLogType.log,
      name: name,
      log: log,
      time: Utils.convertDateTimeToPatternTime(DateTime.now(), 'hh:mm:ss+SSS a'),
    );
    listLogged.add(data);
  }

  static void errorLog({
    required String name,
    required String log,
  }) {
    if (!kDebugMode) return;
    final data = RequestLog(
      type: RequestLogType.error,
      name: name,
      log: log,
      time: Utils.convertDateTimeToPatternTime(DateTime.now(), 'hh:mm:ss+SSS a'),
    );
    listError.add(data);
  }
}
