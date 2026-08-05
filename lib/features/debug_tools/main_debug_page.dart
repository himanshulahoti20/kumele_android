import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/features/debug_tools/debug_logger.dart';
import 'package:kuemele/features/debug_tools/debug_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:kuemele/shared/base/base_page.dart';

class MainDebugPage extends StatefulWidget implements BasePage {
  const MainDebugPage({super.key});

  @override
  State<MainDebugPage> createState() => _MainDebugPageState();

  @override
  String get screenName => 'MainDebugPage';
}

class _MainDebugPageState extends State<MainDebugPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Debug Tools'),
            leading: BackButton(),
            actions: [
              IconButton(
                icon: Icon(Icons.clear_all),
                onPressed: () => DebugLogger.clearAllLoggedRequest(),
              ),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Container(
                alignment: Alignment.center,
                child: FutureBuilder<PackageInfo?>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final packageInfo = snapshot.data;
                    return Text(
                      'Version: ${packageInfo?.version} (${packageInfo?.buildNumber})',
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              buildDebugItem(
                RequestLogType.api.name,
                () => context.push(AppRoutes.apiDebug,
                    extra: ApiDebugRouteArgs(type: RequestLogType.api)),
              ),
              SizedBox(height: 16),
              buildDebugItem(
                RequestLogType.log.name,
                () => context.push(AppRoutes.apiDebug,
                    extra: ApiDebugRouteArgs(type: RequestLogType.log)),
              ),
              SizedBox(height: 16),
              buildDebugItem(
                RequestLogType.error.name,
                () => context.push(AppRoutes.apiDebug,
                    extra: ApiDebugRouteArgs(type: RequestLogType.error)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildSwitchDebugItem(
      String title, bool switchValue, Function(bool) onChanged) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
            ),
          ),
          SizedBox(
            height: 22,
            child: Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                value: switchValue,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InkWell buildDebugItem(String title, Function() onTap,
      {bool useArrow = true}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Text(title),
          Spacer(),
          useArrow ? Icon(Icons.arrow_forward_ios_rounded) : SizedBox.shrink(),
        ],
      ),
    );
  }
}
