import 'package:event_planner/features/event_management/domain/entities/event.dart';
import 'package:event_planner/features/event_management/presentation/cubit/event_cubit.dart';
import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';
import 'package:event_planner/features/guest_list_management/presentation/cubit/guest_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddEditEventPage extends StatefulWidget {
  final Event? event;

  const AddEditEventPage({super.key, this.event});

  @override
  State<AddEditEventPage> createState() => _AddEditEventPageState();
}

class _AddEditEventPageState extends State<AddEditEventPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;

  @override
  void initState() {
    super.initState();
    context.read<GuestCubit>().getAllGuests(); // Fetch guests on page load
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.event == null ? "Add New Event" : "Edit Event";
    String buttonLabel = widget.event == null ? "Add Event" : "Update Event";

    final initialValues = {
      "title": widget.event?.title ?? '',
      "date": widget.event?.date,
      "time": widget.event?.date,
      "location": widget.event?.location ?? '',
      "description": widget.event?.description ?? '',
      "selectedGuests": widget.event?.guestIds ?? [],
    };

    List<Guest> availableGuests = [];

    return BlocListener<EventCubit, EventState>(
      listener: (context, state) {
        if (state is EventAdded) {
          Navigator.pop(context, "Event Added Successfully.");
        } else if (state is EventError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _isPerforming = false;
          });
        } else if (state is EventUpdated) {
          Navigator.pop(context, state.newEvent);
        } else if (state is EventDeleted) {
          Navigator.pop(context, "Event Deleted Successfully.");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: BlocBuilder<GuestCubit, GuestState>(
          builder: (context, guestState) {
            if (guestState is GuestLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (guestState is GuestError) {
              return Center(
                child: Text("Failed to load guests: ${guestState.message}"),
              );
            }

            if (guestState is GuestLoaded) {
              availableGuests = guestState.guests;
            }

            if (availableGuests.isEmpty) {
              return const Center(
                child: Text("No guests available."),
              );
            }

            return FormBuilder(
              key: _formKey,
              initialValue: initialValues,
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  // Title Field
                  FormBuilderTextField(
                    name: "title",
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                    initialValue: initialValues["title"] as String,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: 8),

                  // Date Field
                  FormBuilderDateTimePicker(
                    name: "date",
                    inputType: InputType.date,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Date',
                    ),
                    initialValue: initialValues["date"] as DateTime?,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: 8),

                  // Time Field
                  FormBuilderDateTimePicker(
                    name: "time",
                    inputType: InputType.time,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Time',
                    ),
                    initialValue: initialValues["time"] as DateTime?,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: 8),

                  // Location Field
                  FormBuilderTextField(
                    name: "location",
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Location',
                    ),
                    initialValue: initialValues["location"] as String,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: 8),

                  // Description Field
                  FormBuilderTextField(
                    name: "description",
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                    initialValue: initialValues["description"] as String,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: 8),

                  // Guests Selection
                  const Text(
                    "Select Guests",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FormBuilderCheckboxGroup<String>(
                    name: 'selectedGuests',
                    decoration: const InputDecoration(
                      labelText: 'Select Guests',
                      labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    options: availableGuests
                        .map(
                          (guest) => FormBuilderFieldOption(
                            value: guest.id,
                            child: Text(guest.name),
                          ),
                        )
                        .toList(),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: 'Please select at least one guest'),
                    ]),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isPerforming
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final inputs = _formKey.currentState!.instantValue;

                      /*final selectedGuestIds = availableGuests
                          .where((guest) =>
                              _formKey.currentState!.fields["guest_${guest.id}"]
                                  ?.value ==
                              true)
                          .map((guest) => guest.id) // Ensure IDs are strings
                          .toList();
                      print(
                          "Selected guest IDs: $selectedGuestIds"); // Debug log*/

                      final newEvent = Event(
                        id: widget.event?.id ?? '',
                        title: inputs["title"] as String,
                        date: inputs["date"] as DateTime,
                        time: (inputs["time"] as DateTime).toIso8601String(),
                        location: inputs["location"] as String,
                        description: inputs["description"] as String,
                        guestIds: inputs[
                            "selectedGuests"], // Include selected guest IDs
                      );

                      if (widget.event == null) {
                        context.read<EventCubit>().createEvent(newEvent);
                      } else {
                        context.read<EventCubit>().updateEvent(newEvent);
                      }
                    }
                  },
                  child: _isPerforming
                      ? const CircularProgressIndicator()
                      : Text(buttonLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
