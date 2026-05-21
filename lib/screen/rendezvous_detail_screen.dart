import 'package:flutter/material.dart';
import 'package:flutter_concepts/models/rendez_vous.dart';
import 'package:flutter_concepts/routes/app_router.dart';
import 'package:flutter_concepts/services/rendezvous_service.dart';
import 'package:flutter_concepts/widgets/my_app_bar.dart';
import 'package:flutter_concepts/widgets/my_drawer.dart';
import 'package:intl/intl.dart';

class RendezVousDetailScreen extends StatelessWidget {
  final RendezVous appointment;

  const RendezVousDetailScreen({
    super.key,
    required this.appointment,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final service = RendezVousService();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Supprimer'),
          ],
        ),
        content: const Text(
          'Voulez-vous vraiment supprimer ce rendez-vous ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Show loading indicator
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      try {
        await service.deleteAppointment(appointment.id);
        if (context.mounted) {
          // Pop loading indicator
          Navigator.pop(context);
          // Pop detail screen
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rendez-vous supprimé avec succès.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context); // Pop loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de la suppression')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = RendezVousService();

    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        // Find latest version of the appointment from service
        RendezVous? currentAppointment;
        try {
          currentAppointment = service.appointments.firstWhere((rv) => rv.id == appointment.id);
        } catch (_) {
          // If not found in the service, it was probably deleted.
        }

        // Fallback or closing transition
        if (currentAppointment == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final dateFormatted = DateFormat('dd MMMM yyyy').format(currentAppointment.date);
        final timeFormatted = DateFormat('HH:mm').format(currentAppointment.date);

        return Scaffold(
          appBar: MyAppBar(
            title: 'Détail du Rendez‑vous',
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Modifier',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.addRendezVous,
                    arguments: currentAppointment,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'Supprimer',
                onPressed: () => _confirmDelete(context),
              ),
              const SizedBox(width: 8),
            ],
          ),
          drawer: const MyDrawer(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Premium Header with Icon & Title
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 32, left: 24, right: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // Icon badge with subtle shadow
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.event_available_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Appointment Title
                      Text(
                        currentAppointment.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Details Container
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Colors.indigo,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Date & Heure',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$dateFormatted à $timeFormatted',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description Card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.description_outlined,
                                      color: Colors.indigo,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24, thickness: 1),
                              if (currentAppointment.description != null &&
                                  currentAppointment.description!.trim().isNotEmpty)
                                Text(
                                  currentAppointment.description!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black87,
                                  ),
                                )
                              else
                                const Text(
                                  'Aucune description renseignée pour ce rendez-vous.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black54,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Return Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Retour aux rendez‑vous'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
