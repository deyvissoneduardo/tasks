import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../config/app_config.dart';
import '../../data/repositories/local_task_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../data/services/task_firestore_service.dart';
import '../../ui/home/view_model/home_view_model.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders(AppConfig.current),
      child: child,
    );
  }
}

List<SingleChildWidget> appProviders(AppConfig config) {
  // Provider owns dependency wiring. Widgets consume ViewModels and do not build data-layer objects directly.
  return [
    Provider<AppConfig>.value(value: config),
    Provider<TaskRepository>(
      create: (_) {
        if (Firebase.apps.isEmpty) {
          return LocalTaskRepository();
        }

        return TaskRepositoryImpl(
          TaskFirestoreService(FirebaseFirestore.instance),
        );
      },
      dispose: (_, repository) {
        if (repository is LocalTaskRepository) {
          repository.dispose();
        }
      },
    ),
    ChangeNotifierProvider<HomeViewModel>(
      create: (context) =>
          HomeViewModel(context.read<TaskRepository>())..start(),
    ),
  ];
}
