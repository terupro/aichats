import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/active_theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

class MyAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MyAppBar({required this.scaffoldKey, super.key});

  @override
  ConsumerState<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends ConsumerState<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
      ),
      title: Text(
        'AIChats',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            ref.watch(activeThemeProvider) == Themes.dark
                ? Icons.brightness_4
                : Icons.brightness_7,
          ),
          onPressed: () async {
            Themes newTheme = ref.read(activeThemeProvider) == Themes.dark
                ? Themes.light
                : Themes.dark;
            ref.read(activeThemeProvider.notifier).state = newTheme;
            HapticFeedback
                .mediumImpact(); // Save the new theme state to SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('is_dark_theme', newTheme == Themes.dark);
          },
        ),
      ],
    );
  }
}
