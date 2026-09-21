import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noua/app/app.locator.dart';
import 'package:noua/app/app.router.dart';
import 'package:noua/services/dio_service.dart';
import 'package:noua/ui/common/app_colors.dart';
import 'package:stacked_services/stacked_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupLocator();
  // A saved token skips the login screen. If the server has revoked it, the
  // first 401 sends the user back to login (see api_response_extension.dart).
  final token = await locator<DioService>().getToken();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('fr'),
      startLocale: const Locale('fr'),
      child: MainApp(initialRoute: token == null || token.isEmpty ? Routes.loginView : Routes.mainView),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noua',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor, surface: AppColors.backgroundColor),
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      initialRoute: initialRoute,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      // Without this, an initial route of '/main-view' also stacks '/' (login)
      // underneath it, and swiping back would reveal the login screen.
      onGenerateInitialRoutes: (name) =>
          [StackedRouter().onGenerateRoute(RouteSettings(name: name))!],
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [StackedService.routeObserver],
    );
  }
}
