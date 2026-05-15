import 'package:flutter/material.dart';
import 'package:flutter_concepts/models/rendez_vous.dart';
import 'package:flutter_concepts/screen/add_rendezvous_screen.dart';
import 'package:flutter_concepts/widgets/my_app_bar.dart';
import 'package:flutter_concepts/widgets/my_drawer.dart';
import 'package:flutter_concepts/widgets/rv_list_item.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<RendezVous> _rendezvouss = [
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

  void _addRendezVous(RendezVous rv) {
    setState(() {
      _rendezvouss.add(rv);
    });
  }


  @override
  Widget build(BuildContext context) {
    


    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      body: ListView(
        children: [
          for (int i = 0; i < _rendezvouss.length; i++)
            RVListItem(
              appointment: _rendezvouss[i],
              onTap: () {
                // Placeholder for future actions
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
         child:   const Icon(Icons.add),
         tooltip: "Ajouter un RV",
        onPressed: () async {
           final rvCreated = await Navigator.push<RendezVous>(
            context,
            MaterialPageRoute(
              builder: (_) => const AddRendezVousScreen(),
            ),
          );
          if (rvCreated!=null) {
              _addRendezVous(rvCreated);
          }
      },),

    );
  }
}