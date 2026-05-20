import 'package:flutter_concepts/models/rendez_vous.dart';

class RendezVousService {
  static final RendezVousService _instance = RendezVousService._internal();

  factory RendezVousService() {
    return _instance;
  }

  RendezVousService._internal();

  final List<RendezVous> _rendezvousList = [
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

  List<RendezVous> getAppointments() {
    return List.from(_rendezvousList);
  }

  void addAppointment(RendezVous rv) {
    _rendezvousList.add(rv);
  }
}
