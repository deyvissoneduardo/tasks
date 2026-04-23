import 'package:flutter/material.dart';

import '../ui/home/view/home_view.dart';
import 'route_names.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == RouteNames.home || settings.name == null) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const HomeView(),
      );
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => const HomeView(),
    );
  }
}
