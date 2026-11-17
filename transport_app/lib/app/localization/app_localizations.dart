import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

import 'en.dart';
import 'km.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const List<Locale> supportedLocales = [
    Locale('km'),
    Locale('en'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _values = {
    'km': km,
    'en': en,
  };

  /// Looks up [key] in the current language.
  /// Falls back to English, then to the key itself, so it never throws.
  String tr(String key) {
    return _values[locale.languageCode]?[key] ?? en[key] ?? key;
  }

  // Typed getters
  String get welcome => tr('welcome');
  String get login => tr('login');

  String get from => tr('from');
  String get to => tr('to');
  String get departDate => tr('depart_date');
  String get returnDate => tr('return_date');
  String get selectDate => tr('select_date');
  String get search => tr('search');

  String get selectCalendarDate => tr('select_calendar_date');
  String get cancel => tr('cancel');
  String get confirm => tr('confirm');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((l) => l.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Shortcut: `context.l10n.search`
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}