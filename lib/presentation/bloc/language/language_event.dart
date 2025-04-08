import 'package:flutter/material.dart';

abstract class LanguageEvent {
  const LanguageEvent();
}

class ToggleLanguageEvent extends LanguageEvent {
  final Locale locale;

  const ToggleLanguageEvent(this.locale);
}
