import 'package:app/src/di/inject.config.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

@InjectableInit(
  initializerName: 'initGetIt',
  preferRelativeImports: true,
  asExtension: true,
)
configureDependencies({String? environment}) async {
  getIt.initGetIt(environment: environment);
}
