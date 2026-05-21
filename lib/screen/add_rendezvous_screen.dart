import 'package:flutter/material.dart';
import 'package:flutter_concepts/models/rendez_vous.dart';
import 'package:flutter_concepts/services/rendezvous_service.dart';
import 'package:flutter_concepts/widgets/my_app_bar.dart';
import 'package:flutter_concepts/widgets/my_drawer.dart';
import 'package:intl/intl.dart';

class AddRendezVousScreen extends StatefulWidget {
  final RendezVous? appointmentToEdit;

  const AddRendezVousScreen({super.key, this.appointmentToEdit});

  @override
  State<AddRendezVousScreen> createState() => _AddRendezVousScreenState();
}

class _AddRendezVousScreenState extends State<AddRendezVousScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.appointmentToEdit != null) {
      _titleController.text = widget.appointmentToEdit!.title;
      _descriptionController.text = widget.appointmentToEdit!.description ?? '';
      _selectedDate = widget.appointmentToEdit!.date;
    }
  }

  Future<void> _pickDate() async {
    if (_isLoading) return;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner une date')),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.appointmentToEdit != null) {
        // Edit Mode
        final updated = widget.appointmentToEdit!.copyWith(
          title: _titleController.text.trim(),
          date: _selectedDate!,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );
        await RendezVousService().updateAppointment(updated);
      } else {
        // Create Mode
        final appointment = RendezVous(
          title: _titleController.text.trim(),
          date: _selectedDate!,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );
        await RendezVousService().addAppointment(appointment);
      }
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Error saving appointment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'enregistrement')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.appointmentToEdit != null;
    final dateText = _selectedDate == null
        ? 'Sélectionnez une date'
        : DateFormat('dd MMM yyyy').format(_selectedDate!);

    return Scaffold(
      appBar: MyAppBar(
        title: isEditMode ? 'Modifier le Rendez-vous' : 'Nouveau Rendez-vous',
      ),
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Titre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      return (value == null || value.trim().isEmpty)
                          ? 'Le titre est requis'
                          : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(dateText),
                          const Icon(Icons.calendar_today, color: Colors.indigo),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _descriptionController,
                    enabled: !_isLoading,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description (optionnelle)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _submit,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.check),
                    label: Text(
                      _isLoading
                          ? 'Enregistrement...'
                          : (isEditMode ? 'Enregistrer les modifications' : 'Créer le rendez-vous'),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.indigo.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black12,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}