import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/shared_preference_constants.dart';

@lazySingleton
class AppPreferences {
  final SharedPreferences _prefs;

  AppPreferences(this._prefs);

  Future<ThemeMode> getThemeMode() async {
    final themeMode = _prefs.getString(SharedPreferenceConstants.themeMode) ??
        ThemeMode.system.name;
    switch (themeMode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(SharedPreferenceConstants.themeMode, mode.name);
  }


  Future<void> setLanguageCode(String languageCode) async {
    await _prefs.setString(SharedPreferenceConstants.language, languageCode);
  }

  Future<String> getLanguageCode() async {
    return _prefs.getString(SharedPreferenceConstants.language) ?? 'zh';
  }

  Future<void> setApiKey(String apiKey) async {
    if (apiKey.isNotEmpty) {
      await _prefs.setString(SharedPreferenceConstants.apiKey, apiKey);
    }
  }

  Future<String> getApiKey() async {
    return _prefs.getString(SharedPreferenceConstants.apiKey) ?? '';
  }

  Future<void> setBaseUrl(String baseUrl) async {
    if (baseUrl.isNotEmpty) {
      await _prefs.setString(SharedPreferenceConstants.baseUrl, baseUrl);
    }
  }

  Future<String> getBaseUrl() async {
    return _prefs.getString(SharedPreferenceConstants.baseUrl) ?? '';
  }

  Future<void> setHttpProxy(String httpProxy) async {
    if (httpProxy.isNotEmpty) {
      await _prefs.setString(SharedPreferenceConstants.httpProxy, httpProxy);
    }
  }

  Future<String> getHttpProxy() async {
    return _prefs.getString(SharedPreferenceConstants.httpProxy) ?? '';
  }
}
