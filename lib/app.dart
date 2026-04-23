import 'package:flutter/material.dart';

import 'core/di/providers.dart';
import 'routing/app_router.dart';
import 'routing/route_names.dart';
import 'ui/core/themes/app_theme.dart';

class TasksApp extends StatelessWidget {
  const TasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    // AppProviders is the composition root for services, repositories and view models.
    return AppProviders(
      child: MaterialApp(
        title: 'Tasks',
        theme: AppTheme.light,
        initialRoute: RouteNames.home,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
