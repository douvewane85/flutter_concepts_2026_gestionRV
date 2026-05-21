import 'package:flutter_concepts/models/rendez_vous.dart';

class RendezvousService {
  // Pattern Singleton
  static final RendezvousService _instance = RendezvousService._internal();
  factory RendezvousService() => _instance;
  RendezvousService._internal();

  final List<RendezVous> _appointments = [
    RendezVous(
      title: 'Consultation médicale',
      date: DateTime.now(),
      description: 'Consultation avec le Dr. Martin',
    ),
    RendezVous(
      title: 'Réunion d\'équipe',
      date: DateTime.now(),
      description: 'Réunion mensuelle de l\'équipe',
    ),
    RendezVous(
      title: 'Réunion d\'équipe',
      date: DateTime.now(),
      description: 'Réunion mensuelle de l\'équipe',
    ),
    RendezVous(
      title: 'Réunion d\'équipe',
      date: DateTime.now(),
      description: 'Réunion mensuelle de l\'équipe',
    ),
    RendezVous(
      title: 'Réunion d\'équipe',
      date: DateTime.now(),
      description: 'Réunion mensuelle de l\'équipe',
    ),
    RendezVous(
      title: 'Réunion d\'équipe',
      date: DateTime.now(),
      description: 'Réunion mensuelle de l\'équipe',
    ),
  ];

  List<RendezVous> get appointments => List.unmodifiable(_appointments);

  void addAppointment(RendezVous appointment) {
    _appointments.add(appointment);
  }

  void deleteAppointment(int index) {
    if (index >= 0 && index < _appointments.length) {
      _appointments.removeAt(index);
    }
  }
}
