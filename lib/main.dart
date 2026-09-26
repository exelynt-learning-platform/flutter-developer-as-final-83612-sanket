import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_developer_as_final_83612_sanket/features/employee/presentation/pages/dashboard.dart';
// import 'package:flutter_developer_as_final_83612_sanket/features/authentication/presentation/pages/dashboard_page.dart';

import 'core/utils/injection_container.dart' as di;
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/bloc/auth_event.dart';
import 'features/authentication/presentation/bloc/auth_state.dart';
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/employee/presentation/bloc/employee_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase Core
  await Firebase.initializeApp();

  // 2. Initialize Service Locator (GetIt)
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Upgraded to MultiBlocProvider to inject multiple BLoCs into the widget tree
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<EmployeeBloc>(create: (_) => di.sl<EmployeeBloc>()),
      ],
      child: MaterialApp(
        title: 'Employee Management App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        home: const AuthGate(),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<AuthBloc>(
//       create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
//       child: MaterialApp(
//         title: 'Employee Management App',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           useMaterial3: true,
//           colorSchemeSeed: Colors.indigo,
//           brightness: Brightness.light,
//         ),
//         darkTheme: ThemeData(
//           useMaterial3: true,
//           colorSchemeSeed: Colors.indigo,
//           brightness: Brightness.dark,
//         ),
//         themeMode: ThemeMode.system, // Responsive to system light/dark settings
//         home: const AuthGate(),
//       ),
//     );
//   }
// }

// WHAT: A routing gatekeeper widget.
// WHY: Watches AuthBloc state changes and cleanly swaps between LoginPage and DashboardPage.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // CORRECTED: Removed the 'user: state.user' parameter
          return const DashboardPage();
        } else if (state is Unauthenticated || state is AuthError) {
          return const LoginPage();
        }
        // Shows loading spinner while checking initial auth status
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_developer_as_final_83612_sanket/features/authentication/presentation/pages/dashboard_page.dart';

// import 'core/utils/injection_container.dart' as di;
// import 'features/authentication/presentation/bloc/auth_bloc.dart';
// import 'features/authentication/presentation/bloc/auth_event.dart';
// import 'features/authentication/presentation/bloc/auth_state.dart';
// import 'features/authentication/presentation/pages/login_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // 1. Initialize Firebase Core
//   await Firebase.initializeApp();

//   // 2. Initialize Service Locator (GetIt)
//   await di.init();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<AuthBloc>(
//       create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
//       child: MaterialApp(
//         title: 'Employee Management App',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           useMaterial3: true,
//           colorSchemeSeed: Colors.indigo,
//           brightness: Brightness.light,
//         ),
//         darkTheme: ThemeData(
//           useMaterial3: true,
//           colorSchemeSeed: Colors.indigo,
//           brightness: Brightness.dark,
//         ),
//         themeMode: ThemeMode.system, // Responsive to system light/dark settings
//         home: const AuthGate(),
//       ),
//     );
//   }
// }

// // WHAT: A routing gatekeeper widget.
// // WHY: Watches AuthBloc state changes and cleanly swaps between LoginPage and DashboardPage.
// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(
//       builder: (context, state) {
//         if (state is Authenticated) {
//           return DashboardPage(user: state.user);
//         } else if (state is Unauthenticated || state is AuthError) {
//           return const LoginPage();
//         }
//         // Shows loading spinner while checking initial auth status
//         return const Scaffold(body: Center(child: CircularProgressIndicator()));
//       },
//     );
//   }
// }
