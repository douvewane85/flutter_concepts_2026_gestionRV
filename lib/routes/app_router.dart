import 'package:flutter/material.dart';
import 'package:flutter_concepts/models/rendez_vous.dart';
import 'package:flutter_concepts/screen/add_rendezvous_screen.dart';
import 'package:flutter_concepts/screen/home_screen.dart';
import 'package:flutter_concepts/screen/rendezvous_detail_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String addRendezVous = '/add';
  static const String rendezvousDetail = '/detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case addRendezVous:
        return MaterialPageRoute(
          builder: (_) => const AddRendezVousScreen(),
          settings: settings,
        );
      case rendezvousDetail:
        final args = settings.arguments;
        if (args is RendezVous) {
          return MaterialPageRoute(
            builder: (_) => RendezVousDetailScreen(appointment: args),
            settings: settings,
          );
        }
        return _errorRoute(settings);
      default:
        return _errorRoute(settings);
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Erreur'),
        ),
        body: Center(
          child: Text('Aucune route définie pour ${settings.name}'),
        ),
      ),
      settings: settings,
    );
  }
}
