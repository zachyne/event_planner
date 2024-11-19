import 'package:event_planner/core/services/injection_container.dart';
import 'package:event_planner/core/widgets/empty_state_list.dart';
import 'package:event_planner/core/widgets/error_state_list.dart';
import 'package:event_planner/core/widgets/loading_state_circular_progress.dart';
import 'package:event_planner/features/guest_list_management/presentation/cubit/guest_cubit.dart';
import 'package:event_planner/features/guest_list_management/presentation/add_edit_guest_page.dart';
import 'package:event_planner/features/guest_list_management/presentation/view_guest_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAllGuestsPage extends StatefulWidget {
  const ViewAllGuestsPage({super.key});

  @override
  State<ViewAllGuestsPage> createState() => _ViewAllGuestsPageState();
}

class _ViewAllGuestsPageState extends State<ViewAllGuestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<GuestCubit>().getAllGuests();
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
      body: BlocBuilder<GuestCubit, GuestState>(
        builder: (context, state) {
          if (state is GuestLoading) {
            return const LoadingStateCircularProgress();
          } else if (state is GuestLoaded) {
            if (state.guests.isEmpty) {
              return const EmptyStateList(
                  imageAssetName: 'assets/empty.png',
                  title: 'Oops... There are no guests found.',
                  description: "Tap '+' to add a new guest.");
            }
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 items per row
                childAspectRatio: 1, // Square cards
                crossAxisSpacing: 8.0, // Horizontal spacing
                mainAxisSpacing: 8.0, // Vertical spacing
              ),
              itemCount: state.guests.length,
              itemBuilder: (context, index) {
                final currentGuest = state.guests[index];
                return Card(
                  child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => serviceLocator<GuestCubit>(),
                            child: ViewGuestPage(guest: currentGuest),
                          ),
                        ),
                      );
                      context.read<GuestCubit>().getAllGuests();

                      if (result.runtimeType == String) {
                        final snackBar = SnackBar(content: Text(result));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person, size: 40),
                          const SizedBox(height: 8.0),
                          Flexible(
                            child: Text(
                              currentGuest.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1, // Prevent text overflow
                            ),
                          ),
                          Flexible(
                            child: Text(
                              currentGuest.contactInfo,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12.0,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1, // Prevent text overflow
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is GuestError) {
            return ErrorStateList(
              imageAssetName: 'assets/error.png',
              errorMessage: state.message,
              onRetry: () {
                context.read<GuestCubit>().getAllGuests();
              },
            );
          } else {
            return const EmptyStateList(
                imageAssetName: 'assets/empty.png',
                title: 'Oops... There are no guests found.',
                description: "Tap '+' to add a new guest.");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => serviceLocator<GuestCubit>(),
                child: const AddEditGuestPage(),
              ),
            ),
          );

          context.read<GuestCubit>().getAllGuests();

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
