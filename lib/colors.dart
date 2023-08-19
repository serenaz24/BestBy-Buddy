import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFF0F5E8),
  100: Color(0xFFD8E7C5),
  200: Color(0xFFBFD79E),
  300: Color(0xFFA5C677),
  400: Color(0xFF91BA5A),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFF76A737),
  700: Color(0xFF6B9D2F),
  800: Color(0xFF619427),
  900: Color(0xFF4E841A),
});
const int _primaryPrimaryValue = 0xFF7EAE3D;

const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFDBFFBD),
  200: Color(_primaryAccentValue),
  400: Color(0xFFA4FF57),
  700: Color(0xFF97FF3D),
});
const int _primaryAccentValue = 0xFFC0FF8A;