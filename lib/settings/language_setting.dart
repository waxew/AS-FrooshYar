import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:possystem/settings/setting.dart';

/// Application language preference.
///
/// FrooshYar is Persian-first, while still allowing users to switch to the
/// inherited English and Traditional Chinese translations.
class LanguageSetting extends Setting<Language?> {
  Language? _systemLanguage;

  static final LanguageSetting instance = ._();

  LanguageSetting._() {
    value = .fa;
  }

  @override
  final String key = 'language';

  @override
  bool get registryForApp => true;

  /// Capture the system locale once. Unsupported system locales safely fall
  /// back to Persian instead of throwing during application startup.
  set systemLanguage(String locale) {
    _systemLanguage ??= parseLanguage(locale) ?? .fa;
  }

  Language get language => value ?? _systemLanguage ?? .fa;

  @override
  void initialize() {
    value = parseLanguage(service.get<String>(key)) ?? .fa;
    notifyListeners();
  }

  @override
  Future<void> updateRemotely(Language? data) {
    return service.set<String>(key, (data ?? .fa).locale.toString());
  }

  Language? parseLanguage(String? value) {
    if (value == null || value.isEmpty) return null;

    final codes = value.split('_');

    return Language.values.firstWhereOrNull((e) => e.locale.languageCode == codes[0]);
  }
}

enum Language {
  fa(Locale('fa', 'IR'), 'فارسی'),
  en(Locale('en'), 'English'),
  zhTW(Locale('zh', 'TW'), '繁體中文');

  final Locale locale;

  final String title;

  const Language(this.locale, this.title);
}
