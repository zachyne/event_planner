import 'package:event_planner/core/services/injection_container.dart';
import 'package:event_planner/features/event_management/domain/entities/event.dart';
import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';
import 'package:event_planner/features/guest_list_management/presentation/add_edit_guest_page.dart';
import 'package:event_planner/features/guest_list_management/presentation/cubit/guest_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuestListPage extends StatelessWidget {
  final Event event; // Event passed from the previous page

  GuestListPage({super.key, required this.event});

  // Mock data for guests (in a real app, you'd fetch this from a database or API)
  final List<Guest> allGuests = [
    const Guest(
        id: '1',
        name: 'John Doe',
        contactInfo: 'john@example.com',
        isRSVP: false),
    const Guest(
        id: '2',
        name: 'Jane Smith',
        contactInfo: 'jane@example.com',
        isRSVP: true),
    const Guest(
        id: '3',
        name: 'Alice Johnson',
        contactInfo: 'alice@example.com',
        isRSVP: true),
    const Guest(
        id: '4',
        name: 'Tom Johnson',
        contactInfo: 'tom@example.com',
        isRSVP: true),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter the guests based on the guestIds passed in the event
    final List<Guest> guests = allGuests.where((guest) {
      return event.guestIds
          .contains(guest.id); // Only include guests whose IDs match
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest List'),
      ),
      body: guests.isEmpty
          ? const Center(child: Text('No guests found.'))
          : ListView.builder(
              itemCount: guests.length,
              itemBuilder: (context, index) {
                final guest = guests[index];
                return ListTile(
                  title: Text(guest.name),
                  subtitle: Text(guest.contactInfo), // Display name and email
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {
    // Navigate to AddEditGuestPage
    final newGuestId = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => serviceLocator<GuestCubit>(),
          child: AddEditGuestPage(),
        ),
      ),
    );

    // Update guestIds if a new guest is added
    if (newGuestId != null && newGuestId.isNotEmpty) {
      event.guestIds.add(newGuestId);

      // Optionally, call setState if you need to refresh the UI
      (context as Element).markNeedsBuild();
    }
  },
  tooltip: 'Add Guest',
  child: const Icon(Icons.add),
),
    );
  }
}
