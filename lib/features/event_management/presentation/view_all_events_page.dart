import 'package:event_planner/core/services/injection_container.dart';
import 'package:event_planner/core/widgets/empty_state_list.dart';
import 'package:event_planner/core/widgets/error_state_list.dart';
import 'package:event_planner/core/widgets/loading_state_circular_progress.dart';
import 'package:event_planner/features/event_management/presentation/add_edit_event_page.dart';
import 'package:event_planner/features/event_management/presentation/cubit/event_cubit.dart';
import 'package:event_planner/features/event_management/presentation/view_event_page.dart';
import 'package:event_planner/features/guest_list_management/presentation/cubit/guest_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAllEventsPage extends StatefulWidget {
  const ViewAllEventsPage({super.key});

  @override
  State<ViewAllEventsPage> createState() => _ViewAllEventsPageState();
}

class _ViewAllEventsPageState extends State<ViewAllEventsPage> {
  @override
  void initState() {
    super.initState();
    context.read<EventCubit>().getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/Logo.png'),
        ),
        title: const Text("Events"),
      ),
      body: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            debugPrint("Loadinggggggg");
            return const LoadingStateCircularProgress();
          } else if (state is EventLoaded) {
            if (state.events.isEmpty) {
              return const EmptyStateList(
                  imageAssetName: 'assets/empty.png',
                  title: 'Oops... There are no events found.',
                  description: "Tap '+' to add a new event.");
            }
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                childAspectRatio: 1, // Make the cards square
                crossAxisSpacing: 8.0, // Space between columns
                mainAxisSpacing: 8.0, // Space between rows
              ),
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final currentEvent = state.events[index];
                return Card(
                  child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => serviceLocator<EventCubit>(),
                            child: ViewEventPage(event: currentEvent),
                          ),
                        ),
                      );
                      context
                          .read<EventCubit>()
                          .getAllEvents(); // Refresh the page

                      if (result.runtimeType == String) {
                        final snackBar = SnackBar(content: Text(result));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentEvent.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          currentEvent.location,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is EventError) {
            debugPrint("Error: ${state.message} hehe");
            return ErrorStateList(
              imageAssetName: 'assets/error.png',
              errorMessage: state.message,
              onRetry: () {
                context.read<EventCubit>().getAllEvents();
              },
            );
          } else {
            return const EmptyStateList(
                imageAssetName: 'assets/empty.png',
                title: 'Oops... There are no events found.',
                description: "Tap '+' to add a new event.");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to CreateEventPage with both EventCubit and GuestCubit
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => serviceLocator<EventCubit>(),
                  ),
                  BlocProvider(
                    create: (context) => serviceLocator<GuestCubit>(),
                  ),
                ],
                child: const AddEditEventPage(),
              ),
            ),
          );

          // Refresh the event list
          context.read<EventCubit>().getAllEvents();

          // Show SnackBar with result if it's a string
          if (result.runtimeType == String) {
            final snackBar = SnackBar(content: Text(result));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
