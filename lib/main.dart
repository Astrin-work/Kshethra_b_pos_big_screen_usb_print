import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kshethra_mini/utils/hive/constants.dart';
import 'package:kshethra_mini/utils/hive/hive.dart';
import 'package:kshethra_mini/view/language_select_view.dart';
import 'package:kshethra_mini/view/login_view.dart';
import 'package:kshethra_mini/view/splash_screen_view.dart';
import 'package:kshethra_mini/view/widgets/home_page_widgets/home_widget.dart';
import 'package:kshethra_mini/view_model/auth_viewmodel.dart';
import 'package:kshethra_mini/view_model/booking_viewmodel.dart';
import 'package:kshethra_mini/view_model/donation_viewmodel.dart';
import 'package:kshethra_mini/view_model/e_hundi_viewmodel.dart';
import 'package:kshethra_mini/view_model/home_page_viewmodel.dart';
import 'package:kshethra_mini/view_model/terminal_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:easy_localization/easy_localization.dart';

Box? box;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  await EasyLocalization.ensureInitialized();
  box = await Hive.openBox(Constants.BOX_NAME);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ml'),
        Locale('hi'),
        Locale('ta'),
        Locale('te'),
        Locale('kn'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      startLocale: Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomePageViewmodel()),
          ChangeNotifierProvider(create: (_) => EHundiViewmodel()),
          ChangeNotifierProvider(create: (_) => DonationViewmodel()),
          ChangeNotifierProvider(create: (_) => AuthViewmodel()),
          ChangeNotifierProvider(create: (_) => BookingViewmodel()),
          ChangeNotifierProvider(create: (_) => TerminalViewmodel()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppHive().getIsUserLoggedIn()==true ? LanguageSelectView() :LoginView(),
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
