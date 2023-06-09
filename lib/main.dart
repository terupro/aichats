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
import 'utils/themes.dart';

final _configuration =
    PurchasesConfiguration(dotenv.env['PURCHASES_CONFIGURATION']!);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Purchases.configure(_configuration);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
  Themes currentTheme =
      prefs.getBool('is_dark_theme') ?? true ? Themes.dark : Themes.light;
  runApp(
    ProviderScope(
      overrides: [
        currentThemeProvider.overrideWithValue(currentTheme),
      ],
      child: App(
        seenOnboarding: seenOnboarding,
        currentTheme: currentTheme,
      ),
    ),
  );
}

class App extends ConsumerWidget {
  final bool seenOnboarding;
  final Themes currentTheme;

  const App(
      {super.key, required this.seenOnboarding, required this.currentTheme});

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
