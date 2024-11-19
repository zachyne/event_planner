// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:event_planner/features/guest_list_management/data/data_source/firebase_guest_remote_datasource.dart';
// import 'package:event_planner/features/guest_list_management/domain/entities/guest.dart';
import 'package:event_planner/core/services/injection_container.dart';
import 'package:event_planner/features/event_management/presentation/cubit/event_cubit.dart';
import 'package:event_planner/features/event_management/presentation/view_all_events_page.dart';
import 'package:event_planner/features/guest_list_management/presentation/cubit/guest_cubit.dart';
import 'package:event_planner/features/guest_list_management/presentation/view_all_guests.dart';
// import 'package:event_planner/features/guest_list_management/presentation/cubit/guest_cubit.dart';
// import 'package:event_planner/features/guest_list_management/presentation/view_guests_by_event_page.dart';
import 'package:event_planner/firebase_options.dart';
import 'package:event_planner/profile_page.dart';
import 'package:event_planner/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures Flutter is initialized before Firebase

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
    return; // Exit if Firebase fails to initialize
  }

  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Planner',
      themeMode: ThemeMode.light,
      theme: GlobalThemeData.lightThemeData,
      home: const MyHomePage(title: 'Event Planner'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          BlocProvider(
            create: (context) => serviceLocator<EventCubit>(),
            child: const ViewAllEventsPage(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<GuestCubit>(),
            child: const ViewAllGuestsPage(),
          ),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.celebration), label: "Events"),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Guests"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      
    );
  }
}
