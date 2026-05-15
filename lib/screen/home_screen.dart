import 'package:flutter/material.dart';
import 'package:flutter_concepts/models/rendez_vous.dart';
import 'package:flutter_concepts/screen/add_rendezvous_screen.dart';
import 'package:intl/intl.dart';


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
       appBar: AppBar(
        title: const Text('Gestion de Rendez‑vous'),
      ),
      body: ListView(children: [
      for(int i=0;i<_rendezvouss.length;i++)
          Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
          leading: const Icon(Icons.event_note, color: Colors.indigo),
          title:  Text(_rendezvouss[i].title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(DateFormat('dd MMM yyyy – HH:mm').format(_rendezvouss[i].date)),
              if (_rendezvouss[i].description != null && _rendezvouss[i].description!.isNotEmpty)
                 Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(_rendezvouss[i].description! , style: const TextStyle(color: Colors.grey)),
                ),
             ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {

          }, // Placeholder for future actions
          ),
        )

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