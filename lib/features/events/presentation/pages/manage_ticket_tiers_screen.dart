import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ticket_tier_bloc.dart';
import '../bloc/ticket_tier_event.dart';
import '../bloc/ticket_tier_state.dart';
import '../../../../di/service_locator.dart';
import '../../../../core/utils/snackbar_util.dart';

class ManageTicketTiersScreen extends StatefulWidget {
  final int eventId;

  const ManageTicketTiersScreen({super.key, required this.eventId});

  @override
  State<ManageTicketTiersScreen> createState() => _ManageTicketTiersScreenState();
}

class _ManageTicketTiersScreenState extends State<ManageTicketTiersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _capacityController = TextEditingController();
  late TicketTierBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<TicketTierBloc>()..add(FetchTicketTiers(widget.eventId));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _bloc.add(CreateTicketTierRequested(
        eventId: widget.eventId,
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        capacity: int.parse(_capacityController.text.trim()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Manage Ticket Tiers')),
        body: BlocConsumer<TicketTierBloc, TicketTierState>(
          listener: (context, state) {
            if (state is TicketTierCreationSuccess) {
              SnackbarUtil.showSuccess(context, 'Ticket tier created!');
              _nameController.clear();
              _priceController.clear();
              _capacityController.clear();
            } else if (state is TicketTierError) {
              SnackbarUtil.showError(context, state.message);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                _buildAddTierForm(state),
                const Divider(height: 32, thickness: 2),
                Expanded(child: _buildTiersList(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddTierForm(TicketTierState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Add New Tier', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tier Name (e.g. VIP)', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Enter name' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Price (\$)', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty || double.tryParse(v) == null ? 'Invalid price' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _capacityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Initial Capacity', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty || int.tryParse(v) == null ? 'Invalid capacity' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: state is TicketTierLoading ? null : _submit,
              child: state is TicketTierLoading 
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Add Ticket Tier'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTiersList(TicketTierState state) {
    if (state is TicketTierLoading && _bloc.state is! TicketTiersLoaded) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TicketTiersLoaded) {
      if (state.tiers.isEmpty) {
         return const Center(child: Text('No ticket tiers added yet.'));
      }
      return ListView.builder(
        itemCount: state.tiers.length,
        itemBuilder: (context, index) {
          final tier = state.tiers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(tier.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Capacity: ${tier.capacity} | Sold: ${tier.capacity - tier.availableQty}'),
              trailing: Text('\$${tier.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            ),
          );
        },
      );
    }
    return const SizedBox();
  }
}
