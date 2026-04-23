import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'config/app_config.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const config = AppConfig.current;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on UnsupportedError {
    if (config.hasFirebaseConfig) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: config.firebaseApiKey,
          appId: config.firebaseAppId,
          messagingSenderId: config.firebaseMessagingSenderId,
          projectId: config.firebaseProjectId,
          authDomain: config.firebaseAuthDomain.isEmpty
              ? null
              : config.firebaseAuthDomain,
          storageBucket: config.firebaseStorageBucket.isEmpty
              ? null
              : config.firebaseStorageBucket,
        ),
      );
    }
  }

  runApp(const TasksApp());
}
