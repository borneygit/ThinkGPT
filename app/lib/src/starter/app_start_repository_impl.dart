import 'package:app/src/config/app_config.dart';
import 'package:domain/domain.dart';
import 'package:initializer/initializer.dart';
import 'package:shared/shared.dart';

class AppStartRepositoryImpl implements AppStartRepository<AppConfig> {
  const AppStartRepositoryImpl();

  @override
  Future<AppConfig> init() async {
    final settingRepository = getIt<SettingRepository>();
    final themeMode = await settingRepository.getThemeMode();
    final baseUrl = await settingRepository.getBaseUrl();
    final apiKey = await settingRepository.getApiKey();
    final language = await settingRepository.getLanguageCode();
    return AppConfig(
        themeMode: themeMode,
        baseUrl: baseUrl,
        apiKey: apiKey,
        language: language);
  }
}
