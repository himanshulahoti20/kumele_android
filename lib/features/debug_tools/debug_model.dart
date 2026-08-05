import 'package:flutter_animate/flutter_animate.dart';
import 'package:kuemele/shared/utils/utils.dart';

enum RequestLogType {
  api,
  log,
  error;

  String get name => switch (this) {
        RequestLogType.api => 'API Debug',
        RequestLogType.log => 'Log Debug',
        RequestLogType.error => 'Error Debug',
      };
}

class RequestLog {
  RequestLogType type;
  String name;
  String? log;
  String? time;
  CurlModel? curl;
  ResponseModel? response;

  RequestLog({
    required this.type,
    required this.name,
    this.log,
    this.time,
    this.curl,
    this.response,
  });

  int get duration => Utils.getDateTimeFromPattern(response?.time, 'hh:mm:ss+SSS a')
      .subtract(Utils.getDateTimeFromPattern(curl?.time, 'hh:mm:ss+SSS a').millisecond.ms)
      .millisecond;
}

class CurlModel {
  String title;
  String content;
  String time;

  CurlModel({
    required this.title,
    required this.content,
    required this.time,
  });
}

class ResponseModel {
  String title;
  String content;
  String time;
  int? statusCode;
  String? statusMessage;

  ResponseModel({
    required this.title,
    required this.content,
    required this.time,
    required this.statusCode,
    required this.statusMessage,
  });
}

// class DebugModel {
//   List<CurlModel> listCurl;
//   List<ResponseModel> listResponse;

//   DebugModel({
//     required this.listCurl,
//     required this.listResponse,
//   });
// }
