import 'package:flutter/material.dart';
import 'package:flutter_concepts/models/rendez_vous.dart';
import 'package:flutter_concepts/screen/home_screen.dart';
import 'package:flutter_concepts/screen/add_rendezvous_screen.dart';
import 'package:flutter_concepts/screen/rendezvous_detail_screen.dart';
import 'package:flutter_concepts/screen/login_screen.dart';

class AppRoutes {
  static const String login = LoginScreen.routeName;
  static const String home = HomeScreen.routeName;
  static const String addRendezVous = AddRendezVousScreen.routeName;
  static const String detailRendezVous = RendezVousDetailScreen.routeName;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
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
      case detailRendezVous:
        final appointment = settings.arguments as RendezVous;
        return MaterialPageRoute(
          builder: (_) => RendezVousDetailScreen(appointment: appointment),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Aucune route définie pour ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
