import 'app.dart' show App;
import 'bootstrap.dart';
import 'core/config/app_env.dart';

Future<void> main() => bootstrap(() => const App(), AppEnvEnum.uat);
