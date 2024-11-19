import 'package:event_planner/core/services/injection_container.dart';
import 'package:event_planner/features/event_management/domain/entities/event.dart';
import 'package:event_planner/features/event_management/presentation/add_edit_event_page.dart';
import 'package:event_planner/features/event_management/presentation/cubit/event_cubit.dart';
import 'package:event_planner/features/guest_list_management/presentation/view_guest_by_event_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ViewEventPage extends StatefulWidget {
  final Event event;

  const ViewEventPage({
    super.key,
    required this.event,
  });

  @override
  State<ViewEventPage> createState() => _ViewEventPageState();
}

class _ViewEventPageState extends State<ViewEventPage> {
  late Event _currentEvent;

  @override
  void initState() {
    super.initState();
    _currentEvent = widget.event;
  }

  void _viewGuests() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GuestsByEventPage(guestIds: _currentEvent.guestIds),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventCubit, EventState>(
      listener: (context, state) {
        if (state is EventDeleted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(context, "Event Deleted");
        } else if (state is EventError) {
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
            "Back To Event List",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Icon(Icons.event, size: 150, color: Colors.pink[900]),
              Text(
                _currentEvent.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              Text(DateFormat.yMMMd().format(_currentEvent.date)),
              Text(DateFormat.jm().format(DateTime.parse(_currentEvent.time))),
              const SizedBox(height: 8),
              Text(
                "Location: ${_currentEvent.location}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _currentEvent.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: _viewGuests,
                      child: const Text("View Guests"),
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => serviceLocator<EventCubit>(),
                              child: AddEditEventPage(event: _currentEvent),
                            ),
                          ),
                        );

                        if (result.runtimeType == Event) {
                          setState(() {
                            _currentEvent = result;
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.green),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: const Text("Edit Event"),
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        const snackBar = SnackBar(
                          content: Text("Deleting Event..."),
                          duration: Duration(seconds: 9),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        context.read<EventCubit>().deleteEvent(widget.event);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                      ),
                      child: const Text("Delete Event"),
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
