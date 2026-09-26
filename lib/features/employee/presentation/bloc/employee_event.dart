import '../../data/models/employee_model.dart';

abstract class EmployeeEvent {}

// Triggered when the dashboard first loads or when pulling to refresh
class FetchEmployees extends EmployeeEvent {}

// Triggered when the user submits the Add Employee form
class AddEmployee extends EmployeeEvent {
  final EmployeeModel employee;
  AddEmployee(this.employee);
}

// Triggered when the user submits the Edit Employee form
class UpdateEmployee extends EmployeeEvent {
  final String id;
  final EmployeeModel employee;
  UpdateEmployee({required this.id, required this.employee});
}

// Triggered when the user confirms deletion in the dialog
class DeleteEmployee extends EmployeeEvent {
  final String id;
  DeleteEmployee(this.id);
}

// Triggered when typing in the search bar for an exact ID
class SearchEmployeeById extends EmployeeEvent {
  final String id;
  SearchEmployeeById(this.id);
}

// Triggered when typing in the filter bar (Name, Email, Mobile, Country)
class FilterEmployees extends EmployeeEvent {
  final String query;
  FilterEmployees(this.query);
}