import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_concepts/models/rendez_vous.dart';

class RendezvousService {
  // Pattern Singleton
  static final RendezvousService _instance = RendezvousService._internal();
  factory RendezvousService() => _instance;
  RendezvousService._internal();

  static const String _baseUrl = 'http://localhost:8082/api/rendezvous';

  Future<List<RendezVous>> getAppointments() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      final Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = body['data'] as List<dynamic>;
        return jsonList.map((jsonItem) => RendezVous.fromJson(jsonItem as Map<String, dynamic>)).toList();
      } else {
        final String message = body['message'] ?? 'Impossible de charger les rendez-vous';
        throw Exception(message);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erreur de connexion avec l\'API REST : $e');
    }
  }

  Future<RendezVous> addAppointment(RendezVous appointment) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(appointment.toJson()),
      );
      final Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      
      if (response.statusCode == 201) {
        return RendezVous.fromJson(body['data'] as Map<String, dynamic>);
      } else {
        if (body.containsKey('errors') && body['errors'] != null) {
          final Map<String, dynamic> errors = body['errors'] as Map<String, dynamic>;
          final errorMessages = errors.entries.map((e) => '${e.key}: ${e.value}').join(', ');
          throw Exception('Échec de validation : $errorMessages');
        }
        final String message = body['message'] ?? 'Impossible d\'ajouter le rendez-vous';
        throw Exception(message);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erreur de connexion avec l\'API REST : $e');
    }
  }

  Future<void> deleteAppointment(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$id'));
      final Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      
      if (response.statusCode != 200) {
        final String message = body['message'] ?? 'Impossible de supprimer le rendez-vous';
        throw Exception(message);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erreur de connexion avec l\'API REST : $e');
    }
  }
}

