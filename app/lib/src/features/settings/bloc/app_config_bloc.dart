import 'package:app/src/config/app_config.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

@singleton
class AppConfigBloc extends Cubit<AppConfig> {
  AppConfigBloc() : super(AppConfig());

  void init(AppConfig state) {
    emit(state);
  }

  void setApiKey(String apiKey) async {
    final repository = getIt<SettingRepository>();
    repository.setApiKey(apiKey);
    emit(state.copyWith(apiKey: apiKey));
  }

  void setBaseUrl(String baseUrl) async {
    final repository = getIt<SettingRepository>();
    repository.setBaseUrl(baseUrl);
    emit(state.copyWith(baseUrl: baseUrl));
  }

  void setTheme(ThemeMode theme) async {
    final repository = getIt<SettingRepository>();
    repository.setThemeMode(theme);
    emit(state.copyWith(themeMode: theme));
  }

  void setLanguage(String language) async {
    final repository = getIt<SettingRepository>();
    repository.setLanguageCode(language);
    emit(state.copyWith(language: language));
  }
}
