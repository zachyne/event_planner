import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/core/services/injection_container.dart';
import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';
import 'package:event_planner/features/guest_list_management/presentation/cubit/guest_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'view_guest_page.dart';

class GuestsByEventPage extends StatelessWidget {
  final List<String> guestIds;

  const GuestsByEventPage({
    super.key,
    required this.guestIds,
  });

  Future<Guest?> fetchGuestDetails(String guestId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('guests')
          .doc(guestId)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        return Guest(
          id: guestId,
          name: data['name'] ?? 'Unknown Guest',
          contactInfo: data['contactInfo'] ?? '',
          isRSVP: data['isRSVP'] ?? false,
        );
      }
    } catch (e) {
      debugPrint('Error fetching guest details: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guests List'),
      ),
      body: ListView.builder(
        itemCount: guestIds.length,
        itemBuilder: (context, index) {
          final guestId = guestIds[index];

          return FutureBuilder<Guest?>(
            future: fetchGuestDetails(guestId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Card(
                  child: ListTile(
                    title: Text('Loading...'),
                  ),
                );
              } else if (snapshot.hasError) {
                return Card(
                  child: ListTile(
                    title: const Text('Error fetching guest details'),
                    subtitle: Text(snapshot.error.toString()),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                // If the guest is not found, return an empty container to exclude this item from the list
                return Container();
              }

              final guest = snapshot.data!;
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(guest.name),
                  subtitle: Text(guest.contactInfo),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => serviceLocator<GuestCubit>(),
                          child: ViewGuestPage(guest: guest),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
