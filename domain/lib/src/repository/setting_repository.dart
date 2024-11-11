import 'package:flutter/material.dart';

abstract class SettingRepository {
  Future<void> setThemeMode(ThemeMode value);

  Future<ThemeMode> getThemeMode();

  Future<void> setLanguageCode(String value);

  Future<String> getLanguageCode();

  Future<void> setBaseUrl(String value);

  Future<String> getBaseUrl();

  Future<void> setApiKey(String value);

  Future<String> getApiKey();

  Future<void> setModel(String value);

  Future<String> getModel();

  Future<void> setHttpProxy(String value);

  Future<String> getHttpProxy();
}
