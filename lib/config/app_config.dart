class AppConfig {
  const AppConfig({
    required this.appName,
    required this.firebaseApiKey,
    required this.firebaseAppId,
    required this.firebaseMessagingSenderId,
    required this.firebaseProjectId,
    required this.firebaseAuthDomain,
    required this.firebaseStorageBucket,
  });

  static const current = AppConfig(
    appName: 'Nossas Metas',
    firebaseApiKey: String.fromEnvironment('FIREBASE_API_KEY'),
    firebaseAppId: String.fromEnvironment('FIREBASE_APP_ID'),
    firebaseMessagingSenderId: String.fromEnvironment(
      'FIREBASE_MESSAGING_SENDER_ID',
    ),
    firebaseProjectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
    firebaseAuthDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
    firebaseStorageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
  );

  final String appName;
  final String firebaseApiKey;
  final String firebaseAppId;
  final String firebaseMessagingSenderId;
  final String firebaseProjectId;
  final String firebaseAuthDomain;
  final String firebaseStorageBucket;

  bool get hasFirebaseConfig {
    return firebaseApiKey.isNotEmpty &&
        firebaseAppId.isNotEmpty &&
        firebaseMessagingSenderId.isNotEmpty &&
        firebaseProjectId.isNotEmpty;
  }
}
