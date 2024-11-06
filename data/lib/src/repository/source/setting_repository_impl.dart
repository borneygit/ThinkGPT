import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'preference/app_preference.dart';

@LazySingleton(as: SettingRepository)
class SettingRepositoryImpl implements SettingRepository {
  SettingRepositoryImpl(
    this._appPreferences,
  );

  final AppPreferences _appPreferences;

  @override
  Future<String> getApiKey() => _appPreferences.getApiKey();

  @override
  Future<String> getBaseUrl() => _appPreferences.getBaseUrl();

  @override
  Future<String> getHttpProxy() => _appPreferences.getHttpProxy();

  @override
  Future<ThemeMode> getThemeMode() => _appPreferences.getThemeMode();

  @override
  Future<String> getLanguageCode() => _appPreferences.getLanguageCode();

  @override
  Future<void> setLanguageCode(String value) => _appPreferences.setLanguageCode(value);

  @override
  Future<void> setApiKey(String value) => _appPreferences.setApiKey(value);

  @override
  Future<void> setBaseUrl(String value) => _appPreferences.setBaseUrl(value);

  @override
  Future<void> setHttpProxy(String value) => _appPreferences.setHttpProxy(value);

  @override
  Future<void> setThemeMode(ThemeMode value) => _appPreferences.setThemeMode(value);
}
