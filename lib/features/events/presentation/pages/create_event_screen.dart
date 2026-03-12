import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../bloc/create_event_bloc.dart';
import '../bloc/create_event_event.dart';
import '../bloc/create_event_state.dart';
import '../bloc/update_event_bloc.dart';
import '../bloc/update_event_event.dart';
import '../bloc/update_event_state.dart';
import '../../domain/entities/event_entity.dart';
import '../../../../di/service_locator.dart';
import '../../../../core/utils/snackbar_util.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';

class CreateEventScreen extends StatefulWidget {
  final EventEntity? event;
  const CreateEventScreen({super.key, this.event});

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

  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final event = widget.event!;
      _titleController.text = event.title;
      _descController.text = event.description;
      _locationController.text = event.location;
      _capacityController.text = event.capacity.toString();
      _selectedDate = event.eventDate.toLocal();
      _selectedTime = TimeOfDay.fromDateTime(event.eventDate.toLocal());
    }
  }

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

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate() && _selectedDate != null && _selectedTime != null) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        final finalDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );
        
        if (_isEditing) {
          context.read<UpdateEventBloc>().add(
            SubmitEventUpdate(
              eventId: widget.event!.id,
              title: _titleController.text.trim(),
              description: _descController.text.trim(),
              location: _locationController.text.trim(),
              capacity: int.parse(_capacityController.text.trim()),
              date: finalDateTime.toUtc(),
            ),
          );
        } else {
          context.read<CreateEventBloc>().add(
            SubmitEventCreation(
              organizerId: authState.user.id,
              title: _titleController.text.trim(),
              description: _descController.text.trim(),
              location: _locationController.text.trim(),
              capacity: int.parse(_capacityController.text.trim()),
              date: finalDateTime.toUtc(),
            ),
          );
        }
      } else {
        SnackbarUtil.showError(context, 'You must be logged in to create an event');
      }
    } else if (_selectedDate == null || _selectedTime == null) {
       SnackbarUtil.showError(context, 'Please select date and time');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CreateEventBloc>()),
        BlocProvider(create: (_) => sl<UpdateEventBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(_isEditing ? 'Edit Event' : 'Create Event')),
        body: MultiBlocListener(
          listeners: [
            BlocListener<CreateEventBloc, CreateEventState>(
              listener: (context, state) {
                if (state is CreateEventSuccess) {
                  SnackbarUtil.showSuccess(context, 'Event created successfully!');
                  context.pop(true);
                } else if (state is CreateEventError) {
                  SnackbarUtil.showError(context, state.message);
                }
              },
            ),
            BlocListener<UpdateEventBloc, UpdateEventState>(
              listener: (context, state) {
                if (state is UpdateEventSuccess) {
                  SnackbarUtil.showSuccess(context, 'Event updated successfully!');
                  context.pop(true);
                } else if (state is UpdateEventError) {
                  SnackbarUtil.showError(context, state.message);
                }
              },
            ),
          ],
          child: BlocBuilder<CreateEventBloc, CreateEventState>(
            builder: (context, createState) {
              return BlocBuilder<UpdateEventBloc, UpdateEventState>(
                builder: (context, updateState) {
                  final isLoading = createState is CreateEventLoading || updateState is UpdateEventLoading;
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
                            onPressed: isLoading ? null : () => _submit(context),
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                            child: isLoading 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(_isEditing ? 'Update Event' : 'Create Event', style: const TextStyle(fontSize: 16)),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

