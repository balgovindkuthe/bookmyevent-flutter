import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../bloc/create_event_bloc.dart';
import '../bloc/create_event_event.dart';
import '../bloc/create_event_state.dart';
import '../../../../di/service_locator.dart';
import '../../../../core/utils/snackbar_util.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      if (!mounted) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _selectedDate = date;
          _selectedTime = time;
        });
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedDate != null && _selectedTime != null) {
      final finalDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      
      context.read<CreateEventBloc>().add(
        SubmitEventCreation(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          location: _locationController.text.trim(),
          capacity: int.parse(_capacityController.text.trim()),
          date: finalDateTime.toUtc(), // assuming backend expects UTC
        ),
      );
    } else if (_selectedDate == null || _selectedTime == null) {
       SnackbarUtil.showError(context, 'Please select date and time');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreateEventBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Event')),
        body: BlocConsumer<CreateEventBloc, CreateEventState>(
          listener: (context, state) {
            if (state is CreateEventSuccess) {
              SnackbarUtil.showSuccess(context, 'Event created successfully!');
              context.pop(); // Go back to dashboard, optionally passing true to refresh
            } else if (state is CreateEventError) {
              SnackbarUtil.showError(context, state.message);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Event Title', border: OutlineInputBorder()),
                      validator: (value) => value!.isEmpty ? 'Enter event title' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                      validator: (value) => value!.isEmpty ? 'Enter event description' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
                      validator: (value) => value!.isEmpty ? 'Enter location' : null,
                    ),
                    const SizedBox(height: 16),
                     TextFormField(
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Total Capacity', border: OutlineInputBorder()),
                      validator: (value) {
                         if (value == null || value.isEmpty) return 'Enter capacity';
                         if (int.tryParse(value) == null) return 'Enter a valid number';
                         return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_selectedDate == null ? 'Select Date & Time' : DateFormat('MMM dd, yyyy - HH:mm').format(DateTime(
                         _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
                         _selectedTime?.hour ?? 0, _selectedTime?.minute ?? 0,
                      ))),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _pickDateTime,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: state is CreateEventLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: state is CreateEventLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Create Event', style: TextStyle(fontSize: 16)),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
