import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:onework/view/pages/file_upload.dart';
import 'package:onework/view/pages/splash_page.dart';
import 'package:onework/view/pages/yandex_map_page.dart';
import 'package:provider/provider.dart';

import 'controller/auth_controller.dart';
import 'view/pages/view_map.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('de', 'DE')],
      fallbackLocale: Locale('de', 'DE'),
      startLocale: Locale('de', 'DE'),
      path: 'assets/tr',
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: MaterialApp(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          title: 'One Work',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const YandexMapPage()),
    );
  }
}
