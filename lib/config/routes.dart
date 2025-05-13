import 'package:flutter/material.dart';
import '../ui/pages/pages.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/home': (_) => const HomePage(),
  // '/details': (_) => const DetailsPage(), ← otras páginas irán aquí
};
