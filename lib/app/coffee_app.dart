import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../scenes/launch/launch_factory.dart';
import 'app_dependencies.dart';
import 'app_navigator.dart';

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppDependencies.instance.themeController;
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: theme,
      builder: (context, mode, _) => MaterialApp(
        title: 'Coffee Shop',
        debugShowCheckedModeBanner: false,
        navigatorKey: AppNavigator.navigatorKey,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: mode,
        home: LaunchFactory.make(),
      ),
    );
  }
}
