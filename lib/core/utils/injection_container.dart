import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../features/employee/data/repositories/employee_repository_impl.dart';
import '../../features/employee/domain/repositories/employee_repository.dart';
import '../../features/employee/presentation/bloc/employee_bloc.dart';
import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- Core / External Packages ---
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => ApiClient(client: sl()));

  sl.registerLazySingleton(() => FirebaseAuth.instance);

  final googleSignIn = GoogleSignIn.instance;
  await googleSignIn.initialize();
  sl.registerLazySingleton(() => googleSignIn);

  // --- Authentication Feature ---
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseAuth: sl(), googleSignIn: sl()),
  );

  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  // --- Employee Feature ---
  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(apiClient: sl(), sharedPreferences: sl()),
  );

  // ADDED: This is the missing line causing your crash
  sl.registerFactory(() => EmployeeBloc(repository: sl()));
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get_it/get_it.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../features/authentication/data/repositories/auth_repository_impl.dart';
// import '../../features/authentication/domain/repositories/auth_repository.dart';
// import '../../features/authentication/presentation/bloc/auth_bloc.dart';
// import '../../features/employee/data/repositories/employee_repository_impl.dart';
// import '../../features/employee/domain/repositories/employee_repository.dart';
// import '../network/api_client.dart';

// final sl = GetIt.instance; // sl stands for Service Locator

// Future<void> init() async {
//   // --- Core / External Packages ---
//   // Await SharedPreferences initialization before registering
//   final sharedPreferences = await SharedPreferences.getInstance();
//   sl.registerLazySingleton(() => sharedPreferences);

//   sl.registerLazySingleton(() => http.Client());
//   sl.registerLazySingleton(() => ApiClient(client: sl()));

//   sl.registerLazySingleton(() => FirebaseAuth.instance);

//   final googleSignIn = GoogleSignIn.instance;
//   await googleSignIn.initialize();
//   sl.registerLazySingleton(() => googleSignIn);

//   // --- Authentication Feature ---
//   sl.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(firebaseAuth: sl(), googleSignIn: sl()),
//   );

//   // We use registerFactory so a new instance is created if the UI needs it, preventing stale states.
//   sl.registerFactory(() => AuthBloc(authRepository: sl()));

//   // --- Employee Feature ---
//   sl.registerLazySingleton<EmployeeRepository>(
//     () => EmployeeRepositoryImpl(apiClient: sl(), sharedPreferences: sl()),
//   );
// }

// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:get_it/get_it.dart';
// // import 'package:google_sign_in/google_sign_in.dart';

// // import '../../features/authentication/data/repositories/auth_repository_impl.dart';
// // import '../../features/authentication/domain/repositories/auth_repository.dart';
// // import '../../features/authentication/presentation/bloc/auth_bloc.dart';

// // final sl = GetIt.instance; // sl stands for Service Locator

// // Future<void> init() async {
// //   // --- External Packages ---
// //   sl.registerLazySingleton(() => FirebaseAuth.instance);

// //   final googleSignIn = GoogleSignIn.instance;
// //   await googleSignIn.initialize();
// //   sl.registerLazySingleton(() => googleSignIn);

// //   // --- Authentication Repository ---
// //   sl.registerLazySingleton<AuthRepository>(
// //     () => AuthRepositoryImpl(firebaseAuth: sl(), googleSignIn: sl()),
// //   );

// //   // --- Authentication BLoC ---
// //   // We use registerFactory so a new instance is created if the UI needs it, preventing stale states.
// //   sl.registerFactory(() => AuthBloc(authRepository: sl()));
// // }
