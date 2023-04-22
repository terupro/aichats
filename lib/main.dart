import 'package:aichats/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/active_theme_provider.dart';
import 'screens/chat_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants/themes.dart';

final _configuration =
    PurchasesConfiguration('appl_mGrBTwcMzFnFWhKUJikpGashbYj');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Purchases.configure(_configuration);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
  await dotenv.load();
  runApp(ProviderScope(child: App(seenOnboarding: seenOnboarding)));
}

class App extends ConsumerWidget {
  final bool seenOnboarding;
  const App({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en"),
        Locale("ja"),
      ],
      locale: const Locale('ja', 'JP'),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      themeMode: activeTheme == Themes.dark ? ThemeMode.dark : ThemeMode.light,
      home: seenOnboarding ? ChatScreen() : const OnboardingScreen(),
    );
  }
}
