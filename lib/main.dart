import 'app.dart' show App;
import 'bootstrap.dart';
import 'core/config/app_env.dart' show AppEnvEnum;

Future<void> main() => bootstrap(() => const App(), AppEnvEnum.dev);
