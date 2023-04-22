import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeThemeProvider = StateProvider<Themes>((ref) {
  final currentTheme = ref.watch(currentThemeProvider);
  return currentTheme;
});

final currentThemeProvider = Provider<Themes>((ref) => Themes.dark);

enum Themes {
  dark,
  light,
}
