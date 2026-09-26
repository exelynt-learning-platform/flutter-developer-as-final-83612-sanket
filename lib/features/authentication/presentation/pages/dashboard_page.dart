import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';

class DashboardPage extends StatelessWidget {
  final User user;

  const DashboardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user.photoURL != null)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.photoURL!),
              )
            else
              CircleAvatar(
                radius: 40,
                child: Text(
                  (user.displayName?.isNotEmpty == true)
                      ? user.displayName![0].toUpperCase()
                      : (user.email?.isNotEmpty == true
                            ? user.email![0].toUpperCase()
                            : 'U'),
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              user.displayName ?? 'No Name Provided',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              user.email ?? '',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              'Employee list and CRUD actions will connect here next.',
            ),
          ],
        ),
      ),
    );
  }
}
