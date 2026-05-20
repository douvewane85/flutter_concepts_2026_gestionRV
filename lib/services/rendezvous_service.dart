import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_concepts/models/rendez_vous.dart';
import 'package:flutter_concepts/services/mock_api.dart';

class RendezVousService {
  // Singleton instance
  static final RendezVousService _instance = RendezVousService._internal();
  factory RendezVousService() => _instance;
  RendezVousService._internal();

  final http.Client _client = MockApi.getClient();

  // Retrieve appointments via HTTP GET
  Future<List<RendezVous>> getRendezVous() async {
    try {
      final response = await _client.get(
        Uri.parse('https://api.example.com/rendezvous'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> decodedList = jsonDecode(utf8.decode(response.bodyBytes));
        return decodedList
            .map((item) => RendezVous.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Impossible de charger les rendez-vous: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion lors de la récupération des rendez-vous: $e');
    }
  }

  // Add a new appointment via HTTP POST
  Future<void> addRendezVous(RendezVous rv) async {
    try {
      final response = await _client.post(
        Uri.parse('https://api.example.com/rendezvous'),
        headers: {'content-type': 'application/json; charset=utf-8'},
        body: jsonEncode(rv.toJson()),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Impossible d\'ajouter le rendez-vous: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion lors de l\'ajout du rendez-vous: $e');
    }
  }
}
