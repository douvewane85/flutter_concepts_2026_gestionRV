import 'package:flutter/material.dart';
import 'package:flutter_concepts/models/rendez_vous.dart';
import 'package:flutter_concepts/routes/app_routes.dart';
import 'package:flutter_concepts/widgets/my_app_bar.dart';
import 'package:flutter_concepts/widgets/my_drawer.dart';
import 'package:flutter_concepts/widgets/rv_list_item.dart';
import 'package:flutter_concepts/services/rendezvous_service.dart';


class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RendezVousService _rvService = RendezVousService();
  late Future<List<RendezVous>> _rvFuture;

  @override
  void initState() {
    super.initState();
    _fetchRendezVous();
  }

  void _fetchRendezVous() {
    _rvFuture = _rvService.getRendezVous();
  }

  Future<void> _addRendezVous(RendezVous rv) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await _rvService.addRendezVous(rv);

      if (mounted) {
        Navigator.pop(context); // Pop the progress dialog
        setState(() {
          _fetchRendezVous(); // Refresh the list
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rendez-vous ajouté avec succès !'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Pop the progress dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Gestion de Rendez‑vous'),
      drawer: const MyDrawer(),
      body: FutureBuilder<List<RendezVous>>(
        future: _rvFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Une erreur est survenue',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _fetchRendezVous();
                          });
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Réessayer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _fetchRendezVous();
                });
                await _rvFuture;
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aucun rendez-vous',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Appuyez sur le bouton "+" pour ajouter un nouveau rendez-vous.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final appointments = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _fetchRendezVous();
              });
              await _rvFuture;
            },
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final rv = appointments[index];
                return RVListItem(
                  appointment: rv,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.detailRendezVous,
                      arguments: rv,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Ajouter un RV",
        onPressed: () async {
          final rvCreated = await Navigator.pushNamed<RendezVous>(
            context,
            AppRoutes.addRendezVous,
          );
          if (rvCreated != null) {
            _addRendezVous(rvCreated);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}