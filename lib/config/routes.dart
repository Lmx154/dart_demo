// lib/config/routes.dart
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/lousy_rocket.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  return {
    '/': (context) => HomePage(),
    '/about': (context) => AboutPage(),
    '/rocket': (context) => RocketGamePage(), // Updated route
  };
}
