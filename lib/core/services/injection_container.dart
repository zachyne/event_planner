import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/features/event_management/data/data_source/event_remote_datasource.dart';
import 'package:event_planner/features/event_management/data/data_source/firebase_event_remote_datasource.dart';
import 'package:event_planner/features/event_management/data/repository_impl/event_repo_impl.dart';
import 'package:event_planner/features/event_management/domain/repositories/event_repository.dart';
import 'package:event_planner/features/event_management/domain/use_cases/create_event.dart';
import 'package:event_planner/features/event_management/domain/use_cases/delete_event.dart';
import 'package:event_planner/features/event_management/domain/use_cases/get_all_events.dart';
import 'package:event_planner/features/event_management/domain/use_cases/update_event.dart';
import 'package:event_planner/features/event_management/presentation/cubit/event_cubit.dart';
import 'package:event_planner/features/guest_list_management/data/data_source/firebase_guest_remote_datasource.dart';
import 'package:event_planner/features/guest_list_management/data/data_source/guest_remote_datasource.dart';
import 'package:event_planner/features/guest_list_management/data/repository_impl/guest_repo_impl.dart';
import 'package:event_planner/features/guest_list_management/domain/repositories/guest_repository.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/create_guest.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/delete_guest.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/get_all_guests.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/get_guests_by_event.dart';
import 'package:event_planner/features/guest_list_management/domain/use_cases/update_guest.dart';
import 'package:event_planner/features/guest_list_management/presentation/cubit/guest_cubit.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // FEATURE 1: EVENT
  // Presentation Layer
  serviceLocator.registerFactory(() => EventCubit(
      createEventUseCase: serviceLocator(),
      deleteEventUseCase: serviceLocator(),
      getAllEventsUseCase: serviceLocator(),
      updateEventUseCase: serviceLocator()));

  // Domain Layer
  serviceLocator.registerLazySingleton(() => CreateEvent(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteEvent(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateEvent(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetAllEvents(repository: serviceLocator()));

  // Data Layer
  serviceLocator.registerLazySingleton<EventRepository>(() => EventRepositoryImplementation(serviceLocator()));

  // Data Source
  serviceLocator.registerLazySingleton<EventRemoteDataSource>(() => EventFirebaseRemoteDatasource(serviceLocator()));
  
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);

  // FEATURE 2: GUEST
  serviceLocator.registerFactory(() => GuestCubit(
      createGuestUseCase: serviceLocator(),
      deleteGuestUseCase: serviceLocator(),
      getGuestsByEventUseCase: serviceLocator(),
      updateGuestUseCase: serviceLocator(),
      getAllGuestsUseCase: serviceLocator()));

  // Domain Layer
  serviceLocator.registerLazySingleton(() => CreateGuest(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteGuest(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateGuest(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetGuestsByEvent(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetAllGuests(repository: serviceLocator()));

  // Data Layer
  serviceLocator.registerLazySingleton<GuestRepository>(() => GuestRepositoryImplementation(serviceLocator()));

  // Data Source
  serviceLocator.registerLazySingleton<GuestRemoteDataSource>(() => GuestFirebaseRemoteDataSource(serviceLocator()));
}
