import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_developer_as_final_83612_sanket/features/authentication/presentation/bloc/auth_event.dart';
import 'package:flutter_developer_as_final_83612_sanket/features/employee/presentation/widgets/employee_card.dart';

import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';

// Note: We will create the AddEditEmployeePage in the next phase.
import 'add_edit_employee_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Dispatch the initial fetch event when the dashboard loads
    context.read<EmployeeBloc>().add(FetchEmployees());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  // Required Feature: Delete Confirmation Dialog[cite: 2]
  Future<void> _confirmDelete(
    BuildContext context,
    String employeeId,
    String employeeName,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Employee'),
          content: Text(
            'Are you sure you want to delete $employeeName? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      context.read<EmployeeBloc>().add(DeleteEmployee(employeeId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter UI[cite: 2]
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search by exact ID',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<EmployeeBloc>().add(SearchEmployeeById(value));
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _filterController,
                  decoration: const InputDecoration(
                    labelText: 'Filter by Name, Email, Country...',
                    prefixIcon: Icon(Icons.filter_list),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<EmployeeBloc>().add(FilterEmployees(value));
                  },
                ),
              ],
            ),
          ),

          // List and State Handling
          Expanded(
            child: BlocConsumer<EmployeeBloc, EmployeeState>(
              listener: (context, state) {
                if (state is EmployeeActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is EmployeeError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is EmployeeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EmployeeLoaded) {
                  if (state.employees.isEmpty) {
                    return const Center(child: Text('No employees found.'));
                  }

                  // Required Feature: Pull-to-refresh[cite: 2]
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<EmployeeBloc>().add(FetchEmployees());
                    },
                    child: ListView.builder(
                      itemCount: state.employees.length,
                      itemBuilder: (context, index) {
                        final employee = state.employees[index];
                        return EmployeeCard(
                          employee: employee,
                          onEdit: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    AddEditEmployeePage(employee: employee),
                              ),
                            );
                          },
                          onDelete: () => _confirmDelete(
                            context,
                            employee.id,
                            employee.name,
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: Text('Start by fetching employees.'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddEditEmployeePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
