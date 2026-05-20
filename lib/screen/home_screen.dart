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
  late List<RendezVous> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = _rendezVousService.getAppointments();
  }

  void _refreshAppointments() {
    setState(() {
      _appointments = _rendezVousService.getAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      body: ListView(
        children: [
          for (int i = 0; i < _appointments.length; i++)
            RVListItem(
              appointment: _appointments[i],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.rendezvousDetail,
                  arguments: _appointments[i],
                );
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Ajouter un RV",
        onPressed: () async {
          final success = await Navigator.pushNamed<bool>(
            context,
            AppRouter.addRendezVous,
          );
          if (success == true) {
            _refreshAppointments();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}