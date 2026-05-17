/// Static, compile-time application metadata.
///
/// Anything that depends on environment (URLs, keys) belongs in `--dart-define`
/// flags read inside `main.dart`, not here.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Market App';
}
