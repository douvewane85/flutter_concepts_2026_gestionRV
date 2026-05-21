import 'package:flutter/material.dart';
import 'package:flutter_concepts/models/rendez_vous.dart';
import 'package:flutter_concepts/routes/app_router.dart';
import 'package:flutter_concepts/services/rendezvous_service.dart';
import 'package:flutter_concepts/widgets/my_app_bar.dart';
import 'package:flutter_concepts/widgets/my_drawer.dart';
import 'package:flutter_concepts/widgets/rv_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RendezVousService _rendezVousService = RendezVousService();
  List<RendezVous>? _appointments;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Subscribe to service changes so the UI refreshes automatically!
    _rendezVousService.addListener(_onServiceChanged);
    _loadAppointments();
  }

  @override
  void dispose() {
    _rendezVousService.removeListener(_onServiceChanged);
    super.dispose();
  }

  void _onServiceChanged() {
    _loadAppointments(silent: true);
  }

  Future<void> _loadAppointments({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }
    try {
      final list = await _rendezVousService.getAppointments();
      if (mounted) {
        setState(() {
          _appointments = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading appointments: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Impossible de charger vos rendez-vous.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteAppointment(RendezVous appointment) async {
    try {
      await _rendezVousService.deleteAppointment(appointment.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rendez-vous "${appointment.title}" supprimé.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error deleting appointment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la suppression')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_isLoading && _appointments == null) {
      body = const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.indigo),
            SizedBox(height: 16),
            Text(
              'Chargement de vos rendez‑vous...',
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      );
    } else if (_errorMessage != null) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _loadAppointments(),
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              ),
            ],
          ),
        ),
      );
    } else if (_appointments == null || _appointments!.isEmpty) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.event_busy_rounded,
                  size: 80,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Aucun rendez‑vous',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vous n\'avez aucun rendez-vous de planifié pour le moment.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, AppRouter.addRendezVous),
                icon: const Icon(Icons.add),
                label: const Text('Ajouter un rendez-vous'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      body = RefreshIndicator(
        onRefresh: () => _loadAppointments(silent: true),
        color: Colors.indigo,
        child: ListView.builder(
          itemCount: _appointments!.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            final appointment = _appointments![index];
            return Dismissible(
              key: Key(appointment.id),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('Confirmer'),
                      ],
                    ),
                    content: Text(
                      'Voulez-vous vraiment supprimer le rendez-vous "${appointment.title}" ?',
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
              },
              onDismissed: (direction) {
                _deleteAppointment(appointment);
              },
              background: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.delete_sweep_rounded,
                  color: Colors.red.shade700,
                  size: 28,
                ),
              ),
              child: RVListItem(
                appointment: appointment,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.rendezvousDetail,
                    arguments: appointment,
                  );
                },
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: const MyAppBar(title: 'Mes Rendez-vous'),
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          body,
          if (_isLoading && _appointments != null)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                color: Colors.indigo,
                backgroundColor: Colors.transparent,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Ajouter un RV",
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRouter.addRendezVous,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}