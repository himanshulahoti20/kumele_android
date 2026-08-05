import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:kuemele/app/cubit/app_cubit.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/debug_tools/debug_tool_widget.dart';
import 'package:kuemele/shared/theme/kumele_theme.dart';

class MyRootApp extends StatefulWidget {
  const MyRootApp({super.key});

  @override
  State<MyRootApp> createState() => _MyRootAppState();
}

class _MyRootAppState extends State<MyRootApp> {
  @override
  void initState() {
    super.initState();
    // Initialize the app state
    getIt<AppCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: appBlocProviders,
      child: BlocBuilder<AppCubit, AppState>(
        bloc: getIt<AppCubit>(),
        builder: (context, state) {
          final savedThemeMode =
              state is AppReady ? state.savedThemeMode : null;

          if (state is AppLoading || state is AppInitial) {
            return MaterialApp(
              scaffoldMessengerKey: InjectionHelper.snackBar.messengerKey,
              debugShowCheckedModeBanner: false,
              theme: KumeleTheme.light(),
              darkTheme: KumeleTheme.dark(),
              themeMode: ThemeMode.system,
              home: const Scaffold(
                backgroundColor: Colors.black,
              ),
              builder: _responsiveAppBuilder,
            );
          }

          return AdaptiveTheme(
            light: KumeleTheme.light(),
            dark: KumeleTheme.dark(),
            initial: savedThemeMode ?? AdaptiveThemeMode.system,
            builder: (theme, darkTheme) => MaterialApp.router(
              scaffoldMessengerKey: InjectionHelper.snackBar.messengerKey,
              debugShowCheckedModeBanner: false,
              scrollBehavior: const _InvisibleScrollBehavior(),
              theme: theme,
              darkTheme: darkTheme,
              routerConfig: InjectionHelper.router,
              builder: _responsiveAppBuilder,
            ),
          );
        },
      ),
    );
  }

  Widget _responsiveAppBuilder(BuildContext context, Widget? child) {
    final appChild = ResponsiveAppShell(
      child: child ?? const SizedBox.shrink(),
    );
    final smartDialogBuilder = FlutterSmartDialog.init();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: smartDialogBuilder(
        context,
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: appChild,
              ),
              if (kDebugMode) const DebugTool(),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvisibleScrollBehavior extends MaterialScrollBehavior {
  const _InvisibleScrollBehavior();

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
