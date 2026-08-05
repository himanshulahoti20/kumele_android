import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/debug_tools/debug_model.dart';
import 'package:kuemele/core/service_locator.dart';

import 'package:kuemele/shared/base/base_page.dart';
import 'debug_logger.dart';

class APIDebugPage extends StatefulWidget implements BasePage {
  final RequestLogType type;
  const APIDebugPage({super.key, required this.type});

  @override
  State<APIDebugPage> createState() => _APIDebugPageState();

  @override
  String get screenName => 'APIDebugPage';
}

class _APIDebugPageState extends State<APIDebugPage> {
  String? filterApi;

  @override
  Widget build(BuildContext context) {
    List<RequestLog> listRequest = [];
    switch (widget.type) {
      case RequestLogType.api:
        listRequest = DebugLogger.listLoggedRequestApi;
        break;
      case RequestLogType.log:
        listRequest = DebugLogger.listLogged;
      case RequestLogType.error:
        listRequest = DebugLogger.listError;
        break;
    }
    listRequest = listRequest.reversed.toList();
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.type.name),
            leading: BackButton(),
            actions: [
              IconButton(
                icon: Icon(Icons.clear_all),
                onPressed: () {
                  DebugLogger.clearListLoggedRequest(type: widget.type);
                  setState(() {});
                },
              ),
            ],
          ),
          body: (listRequest.isNotEmpty)
              ? Builder(
                  builder: (context) {
                    final listRequestFiltered = filterApi == null
                        ? listRequest
                        : listRequest
                            .where((element) => (element).name == filterApi)
                            .toList();
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: listRequestFiltered.length,
                      itemBuilder: (context, index) {
                        final item = listRequestFiltered[index];
                        return widget.type == RequestLogType.log
                            ? buildLogItem(item)
                            : buildRequestItem(item);
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Gap(6),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'Empty',
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildLogItem(RequestLog item) {
    return ExpandablePanel(
      theme: ExpandableThemeData(
        tapBodyToExpand: true,
        tapBodyToCollapse: true,
        hasIcon: false,
      ),
      header: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name),
                  SizedBox(height: 5),
                  Text(item.time ?? '-'),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: item.log ?? '-'));
                InjectionHelper.snackBar.show('Copied');
              },
            ),
          ],
        ),
      ),
      collapsed: SizedBox.shrink(),
      expanded: ExpandableButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Text(item.log ?? '-', softWrap: true),
        ),
      ),
    );
  }

  Widget buildRequestItem(RequestLog item) {
    final isSuccess = (item.response?.statusCode ?? 0) % 200 != 1;
    return Container(
      color: isSuccess ? Colors.black : Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(child: Text(item.name)),
                Gap(10),
                Text('${item.duration} ms',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          buildCurlItem(item.curl, isSuccess),
          Container(height: 0.5, width: double.infinity, color: Colors.grey),
          buildResponseItem(item.response, isSuccess),
        ],
      ),
    );
  }

  Widget buildCurlItem(CurlModel? item, bool isSuccess) {
    return ExpandablePanel(
      theme: ExpandableThemeData(
        tapBodyToExpand: true,
        tapBodyToCollapse: true,
        hasIcon: false,
      ),
      header: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        color: isSuccess ? null : Colors.red,
        child: Row(
          children: [
            Text('Request'),
            SizedBox(width: 5),
            Text(item?.time ?? '-'),
            Spacer(),
            SizedBox(width: 5),
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: item?.content ?? '-'));
                InjectionHelper.snackBar.show('Copied');
              },
            ),
          ],
        ),
      ),
      collapsed: SizedBox.shrink(),
      expanded: ExpandableButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Text(
            item?.content ?? '-',
            softWrap: true,
          ),
        ),
      ),
    );
  }

  Widget buildResponseItem(ResponseModel? item, bool isSuccess) {
    return ExpandablePanel(
      theme: ExpandableThemeData(
        tapBodyToExpand: true,
        tapBodyToCollapse: true,
        hasIcon: false,
      ),
      header: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        color: isSuccess ? null : Colors.red,
        child: Row(
          children: [
            Text('Response'),
            SizedBox(width: 5),
            Text(item?.time ?? '-'),
            Spacer(),
            IconButton(
              icon: Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: item?.content ?? '-'));
                InjectionHelper.snackBar.show('Copied');
              },
            ),
          ],
        ),
      ),
      collapsed: SizedBox.shrink(),
      expanded: ExpandableButton(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              item?.statusCode != null
                  ? Text(
                      'Status code: ${item?.statusCode}',
                    )
                  : SizedBox.shrink(),
              item?.statusMessage != null
                  ? Text(
                      'Status message: ${item?.statusMessage}',
                    )
                  : SizedBox.shrink(),
              SizedBox(height: 10),
              SelectableText(item?.content ?? '-'),
            ],
          ),
        ),
      ),
    );
  }
}
