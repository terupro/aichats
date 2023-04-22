import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final activeThemeProvider = StateProvider<Themes>(
  (ref) => Themes.dark,
);

enum Themes {
  dark,
  light,
}

Future<void> saveTheme(Themes theme) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('theme', theme.index);
}

Future<Themes> getSavedTheme() async {
  final prefs = await SharedPreferences.getInstance();
  return Themes.values[prefs.getInt('theme') ?? Themes.dark.index];
}
