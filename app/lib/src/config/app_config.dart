import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';

@freezed
class AppConfig with _$AppConfig {
  factory AppConfig({
    @Default(ThemeMode.light) ThemeMode themeMode,
    @Default('') String language,
    @Default('') String baseUrl,
    @Default('') String apiKey,
    @Default('') String model,
  }) = _AppConfig;
}
