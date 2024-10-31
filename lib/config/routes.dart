// lib/routes/routes.dart
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/contact_page.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  return {
    '/': (context) => HomePage(),
    '/about': (context) => AboutPage(),
    '/contact': (context) => ContactPage(),
  };
}
