import 'package:flutter/material.dart';
import 'package:flutter_concepts/models/rendez_vous.dart';
import 'package:flutter_concepts/services/rendezvous_service.dart';
import 'package:flutter_concepts/widgets/my_app_bar.dart';
import 'package:flutter_concepts/widgets/my_drawer.dart';
import 'package:intl/intl.dart';

class AddRendezVousScreen extends StatefulWidget {
  const AddRendezVousScreen({super.key});

  @override
  State<AddRendezVousScreen> createState() => _AddRendezVousScreenState();
}

class _AddRendezVousScreenState extends State<AddRendezVousScreen> {
        final TextEditingController _titleController = TextEditingController();
        final TextEditingController _descriptionController = TextEditingController();
        final _formKey = GlobalKey<FormState>();
        DateTime? _selectedDate;

       Future<void> _pickDate() async {
         final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: now.subtract(const Duration(days: 365)),
          lastDate: now.add(const Duration(days: 365 * 5)),
              );
          if (picked != null) {
            setState(() {
              _selectedDate = picked;
            });
          }
     }
      void _submit() {
        if (_formKey.currentState?.validate() != true || _selectedDate == null) {
          return;
        }
        final appointment = RendezVous(
         title: _titleController.text.trim(),
         date: _selectedDate!,
           description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
        );
        RendezVousService().addAppointment(appointment);
        Navigator.pop(context, true);
     }

        @override
          void dispose() {
            _titleController.dispose();
            _descriptionController.dispose();
            super.dispose();
          }

  @override
  Widget build(BuildContext context) {
      final dateText = _selectedDate == null
        ? 'Sélectionnez une date'
        : DateFormat('dd MMM yyyy').format(_selectedDate!);


    return Scaffold(
         appBar: const MyAppBar(),
        drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                    labelText: 'Titre',
                    border: OutlineInputBorder(),
                  ),
              validator: (value) {
                return (value == null || value.trim().isEmpty) ? 'Le titre est requis' : null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
                onTap:_pickDate,
                child:  InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(dateText),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optionnelle)',
                  border: OutlineInputBorder(),
                ),
              ),
     
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('Enregistrer'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
          ],)),
      ),
    );
  }
}