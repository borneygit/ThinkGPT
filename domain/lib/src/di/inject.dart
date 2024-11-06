import 'package:domain/src/di/inject.config.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

@InjectableInit(
  initializerName: 'initDomainGetIt',
  preferRelativeImports: true,
  asExtension: true,
)
configureDependencies({String? environment}) async {
  getIt.initDomainGetIt(environment: environment);
}
