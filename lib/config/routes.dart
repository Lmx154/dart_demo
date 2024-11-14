// lib/config/routes.dart
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/lousy_rocket.dart'; // Ensure this import is correct

Map<String, WidgetBuilder> getAppRoutes() {
  return {
    '/': (context) => HomePage(),
    '/about': (context) => AboutPage(),
    '/rocket': (context) => RocketGamePage(), // Ensure this route is correct
  };
}
