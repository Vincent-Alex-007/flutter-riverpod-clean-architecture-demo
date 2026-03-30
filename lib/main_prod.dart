import 'app.dart';
import 'bootstrap.dart';
import 'core/enums/app_env_enum.dart';

Future<void> main() => bootstrap(() => const App(), AppEnvEnum.prod);
