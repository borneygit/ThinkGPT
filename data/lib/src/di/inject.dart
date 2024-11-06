import 'package:data/src/di/inject.config.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

@InjectableInit(
  initializerName: 'initDataGetIt',
  preferRelativeImports: true,
  asExtension: true,
)
configureDependencies({String? environment}) async {
  await getIt.initDataGetIt(environment: environment);
}
