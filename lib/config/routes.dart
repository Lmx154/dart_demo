// lib/config/routes.dart
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/rocket_game_page.dart'; // Corrected import

Map<String, WidgetBuilder> getAppRoutes() {
  return {
    '/': (context) => HomePage(),
    '/about': (context) => AboutPage(),
    '/rocket': (context) => RocketGamePage(), // Ensure this route is correct
  };
}
