import 'package:event_planner/core/services/injection_container.dart';
import 'package:event_planner/features/event_management/presentation/view_event_row.dart';
import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';
import 'package:event_planner/features/guest_list_management/presentation/add_edit_guest_page.dart';
import 'package:event_planner/features/guest_list_management/presentation/cubit/guest_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewGuestPage extends StatefulWidget {
  final Guest guest;

  const ViewGuestPage({
    super.key,
    required this.guest,
  });

  @override
  State<ViewGuestPage> createState() => _ViewGuestPageState();
}

class _ViewGuestPageState extends State<ViewGuestPage> {
  late Guest _currentGuest;

  @override
  void initState() {
    super.initState();
    _currentGuest = widget.guest;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GuestCubit, GuestState>(
      listener: (context, state) {
        if (state is GuestDeleted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(context, "Guest Deleted");
        } else if (state is GuestError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Back To Guest List",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Icon(Icons.person, size: 150),
              Text(
                _currentGuest.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              Text(_currentGuest.contactInfo),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('RSVP: ${_currentGuest.isRSVP}'),
              ]),
              const SizedBox(height: 30),
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => serviceLocator<GuestCubit>(),
                              child: AddEditGuestPage(guest: _currentGuest),
                            ),
                          ),
                        );

                        if (result.runtimeType == Guest) {
                          setState(() {
                            _currentGuest = result;
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).primaryColor),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: const Text("Edit Guest"),
                    ),
                  ),
                  const SizedBox(
                      height: 8), // Add some space between the buttons
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        const snackBar = SnackBar(
                          content: Text("Deleting Guest..."),
                          duration: Duration(seconds: 9),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        context.read<GuestCubit>().deleteGuest(widget.guest.id);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: const Text("Delete Guest"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // body: ListView(
        //   padding: const EdgeInsets.all(8.0),
        //   children: [
        //     LabelValueRow(label: 'Name', value: _currentGuest.name),
        //     LabelValueRow(label: 'Contact Information', value: _currentGuest.contactInfo),
        //     LabelValueRow(label: 'RVSP', value: _currentGuest.isRSVP),
        //   ],
        // ),
      ),
    );
  }
}
