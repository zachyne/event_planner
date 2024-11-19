import 'package:event_planner/features/event_management/presentation/cubit/event_cubit.dart';
import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';
import 'package:event_planner/features/guest_list_management/presentation/cubit/guest_cubit.dart';
// import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// void main() {
//   runApp(MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: AddEditEventPage(
//           event: Event(
//             id: "1",
//             title: "Birthday Party",
//             date: DateTime.now(),
//             time: DateTime.now().toIso8601String(),
//             location: "123 Main St",
//             description: "A fun birthday party with amazing food and games",
//             guestIds: const [1, 2, 3],
//           ),
//         ),
//       )));
// }

class AddEditGuestPage extends StatefulWidget {
  final Guest? guest;

  const AddEditGuestPage({super.key, this.guest});

  @override
  State<AddEditGuestPage> createState() => _AddEditGuestPageState();
}

class _AddEditGuestPageState extends State<AddEditGuestPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.guest == null ? "Add New Guest" : "Edit Guest";
    String buttonLabel = widget.guest == null ? "Add Guest" : "Update Guest";
    final initialValues = {
      "name": widget.guest?.name ?? '',
      "contactInfo": widget.guest?.contactInfo ?? '',
      "isRVSP": widget.guest?.isRSVP ?? false,
    };

    return BlocListener<GuestCubit, GuestState>(
      listener: (context, state) {
        if (state is GuestAdded) {
          Navigator.pop(context, "Guest Added Successfully.");
        } else if (state is GuestError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _isPerforming = false;
          });
        } else if (state is GuestUpdated) {
          Navigator.pop(context, state.newGuest);
        } else if (state is EventDeleted) {
          Navigator.pop(context, "Guest Deleted Successfully.");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: Column(
          children: [
            Expanded(
              child: FormBuilder(
                key: _formKey,
                initialValue: initialValues,
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    // For Title
                    FormBuilderTextField(
                      name: "name",
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                      initialValue: initialValues["name"] as String,
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 8),

                    // For Date
                    FormBuilderTextField(
                      name: "contactInfo",
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contact Information',
                      ),
                      initialValue: initialValues["contactInfo"] as String,
                      validator: FormBuilderValidators.required(),
                    ),

                    const SizedBox(height: 8),

                    // for isRVSP
                    FormBuilderCheckbox(
                      name: "isRSVP",
                      title: const Text("RSVP"),
                      initialValue: (initialValues["isRSVP"] as bool?) ??
                          false, // Safeguard against null
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            Padding(
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
                        bool isValid = _formKey.currentState!.validate();
                        final inputs = _formKey.currentState!.instantValue;

                        if (isValid) {
                          setState(() {
                            _isPerforming = true;
                          });

                          final newGuest = Guest(
                            id: widget.guest?.id ?? '',
                            name: inputs["name"] as String,
                            contactInfo: inputs["contactInfo"] as String,
                            isRSVP: inputs["isRSVP"] as bool,
                          );

                          if (widget.guest == null) {
                            // Add new event
                            context.read<GuestCubit>().createGuest(newGuest);
                          } else {
                            // Update existing event
                            context.read<GuestCubit>().updateGuest(newGuest);
                          }
                        }
                      },
                      child: _isPerforming
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(),
                            )
                          : Text(buttonLabel),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
