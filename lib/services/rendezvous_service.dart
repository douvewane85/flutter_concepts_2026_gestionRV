import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_concepts/models/rendez_vous.dart';

class RendezVousService extends ChangeNotifier {
  static final RendezVousService _instance = RendezVousService._internal();

  factory RendezVousService() {
    return _instance;
  }

  RendezVousService._internal();

  static const String _storageKey = 'rendezvous_list_key';
  List<RendezVous> _rendezvousList = [];
  bool _isInitialized = false;

  // Initialize the service and load persisted appointments or defaults
  Future<void> init() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(jsonString);
        _rendezvousList = decodedList
            .map((item) => RendezVous.fromMap(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error decoding appointments: $e');
        _loadDefaultData();
      }
    } else {
      _loadDefaultData();
      await _saveToPrefs();
    }

    _isInitialized = true;
    notifyListeners();
  }

  void _loadDefaultData() {
    final now = DateTime.now();
    _rendezvousList = [
      RendezVous(
        title: 'Consultation médicale',
        date: now.add(const Duration(hours: 2)),
        description: 'Consultation avec le Dr. Martin',
      ),
      RendezVous(
        title: 'Réunion d\'équipe',
        date: now.add(const Duration(days: 1, hours: 3)),
        description: 'Réunion mensuelle de l\'équipe technique',
      ),
      RendezVous(
        title: 'Déjeuner client',
        date: now.add(const Duration(days: 2, hours: 1)),
        description: 'Discuter du nouveau contrat de projet',
      ),
      RendezVous(
        title: 'Session de sport',
        date: now.add(const Duration(days: 3)),
        description: 'Entraînement hebdomadaire cardio',
      ),
    ];
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
      _rendezvousList.map((rv) => rv.toMap()).toList(),
    );
    await prefs.setString(_storageKey, jsonString);
  }

  // Get appointments asynchronously with simulated delay (600ms)
  Future<List<RendezVous>> getAppointments() async {
    await init();
    await Future.delayed(const Duration(milliseconds: 600));
    return List.from(_rendezvousList);
  }

  // Add appointment asynchronously
  Future<void> addAppointment(RendezVous rv) async {
    await init();
    await Future.delayed(const Duration(milliseconds: 400));
    _rendezvousList.add(rv);
    await _saveToPrefs();
    notifyListeners();
  }

  // Update appointment asynchronously
  Future<void> updateAppointment(RendezVous updatedRv) async {
    await init();
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _rendezvousList.indexWhere((rv) => rv.id == updatedRv.id);
    if (index != -1) {
      _rendezvousList[index] = updatedRv;
      await _saveToPrefs();
      notifyListeners();
    }
  }

  // Delete appointment asynchronously
  Future<void> deleteAppointment(String id) async {
    await init();
    await Future.delayed(const Duration(milliseconds: 400));
    _rendezvousList.removeWhere((rv) => rv.id == id);
    await _saveToPrefs();
    notifyListeners();
  }
}
