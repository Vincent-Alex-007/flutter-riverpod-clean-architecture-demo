import 'app.dart' show App;
import 'bootstrap.dart';
import 'core/config/env/app_env.dart';

Future<void> main() => bootstrap(() => const App(), AppEnvEnum.uat);
