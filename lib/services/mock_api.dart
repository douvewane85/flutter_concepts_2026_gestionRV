import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class MockApi {
  // Static database simulation
  static final List<Map<String, dynamic>> _db = [
    {
      'title': 'Consultation médicale',
      'date': DateTime.now().toIso8601String(),
      'description': 'Consultation avec le Dr. Martin',
    },
    {
      'title': 'Réunion d\'équipe',
      'date': DateTime.now().toIso8601String(),
      'description': 'Réunion mensuelle de l\'équipe',
    },
    {
      'title': 'Réunion d\'équipe',
      'date': DateTime.now().toIso8601String(),
      'description': 'Réunion mensuelle de l\'équipe',
    },
    {
      'title': 'Réunion d\'équipe',
      'date': DateTime.now().toIso8601String(),
      'description': 'Réunion mensuelle de l\'équipe',
    },
    {
      'title': 'Réunion d\'équipe',
      'date': DateTime.now().toIso8601String(),
      'description': 'Réunion mensuelle de l\'équipe',
    },
    {
      'title': 'Réunion d\'équipe',
      'date': DateTime.now().toIso8601String(),
      'description': 'Réunion mensuelle de l\'équipe',
    },
  ];

  static http.Client getClient() {
    return MockClient((request) async {
      final url = request.url;
      final path = url.path;
      final method = request.method.toUpperCase();

      // Add a small artificial network latency to simulate standard REST API
      await Future.delayed(const Duration(milliseconds: 800));

      if (path == '/login' && method == 'POST') {
        try {
          final Map<String, dynamic> body = jsonDecode(request.body);
          final email = body['email']?.toString().trim();
          final password = body['password']?.toString();

          if (email == 'admin@example.com' && password == 'admin123') {
            return http.Response(
              jsonEncode({
                'token': 'mock-jwt-token-123456789',
                'user': {
                  'email': email,
                  'name': 'Administrateur',
                }
              }),
              200,
              headers: {'content-type': 'application/json; charset=utf-8'},
            );
          } else {
            return http.Response(
              jsonEncode({'error': 'Identifiants de connexion incorrects.'}),
              401,
              headers: {'content-type': 'application/json; charset=utf-8'},
            );
          }
        } catch (e) {
          return http.Response(
            jsonEncode({'error': 'Requête invalide'}),
            400,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }
      }

      if (path == '/rendezvous') {
        if (method == 'GET') {
          return http.Response(
            jsonEncode(_db),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        } else if (method == 'POST') {
          try {
            final Map<String, dynamic> body = jsonDecode(request.body);
            // Simple validation
            if (!body.containsKey('title') || !body.containsKey('date')) {
              return http.Response(
                jsonEncode({'error': 'Le titre et la date sont requis'}),
                400,
                headers: {'content-type': 'application/json; charset=utf-8'},
              );
            }
            
            // Persist the new appointment in our static "database"
            _db.add(body);

            return http.Response(
              jsonEncode(body),
              201,
              headers: {'content-type': 'application/json; charset=utf-8'},
            );
          } catch (e) {
            return http.Response(
              jsonEncode({'error': 'Requête invalide'}),
              400,
              headers: {'content-type': 'application/json; charset=utf-8'},
            );
          }
        }
      }

      // Default fallback
      return http.Response(
        jsonEncode({'error': 'Ressource non trouvée'}),
        404,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });
  }
}
