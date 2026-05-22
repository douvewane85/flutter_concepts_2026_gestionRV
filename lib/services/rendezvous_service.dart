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
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        return jsonList.map((json) => RendezVous.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Impossible de charger les rendez-vous: Code ${response.statusCode}');
      }
    } catch (e) {
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
      if (response.statusCode == 201) {
        return RendezVous.fromJson(json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
      } else {
        throw Exception('Impossible d\'ajouter le rendez-vous: Code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion avec l\'API REST : $e');
    }
  }

  Future<void> deleteAppointment(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$id'));
      if (response.statusCode != 204) {
        throw Exception('Impossible de supprimer le rendez-vous: Code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion avec l\'API REST : $e');
    }
  }
}
