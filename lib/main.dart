import 'app.dart' show App;
import 'bootstrap.dart';
import 'core/enums/app_env_enum.dart';

Future<void> main() => bootstrap(App.new, AppEnvEnum.dev);
