import '../../data/models/country_model.dart';
import '../../data/models/employee_model.dart';

abstract class EmployeeState {}

// Initial state before anything happens
class EmployeeInitial extends EmployeeState {}

// Shows a loading spinner during API calls
class EmployeeLoading extends EmployeeState {}

// Contains the data to build the UI (lists of employees and countries)
class EmployeeLoaded extends EmployeeState {
  final List<EmployeeModel> employees;
  final List<CountryModel> countries;
  
  EmployeeLoaded({
    required this.employees,
    required this.countries,
  });
}

// Used to show SnackBars for successful CRUD operations
class EmployeeActionSuccess extends EmployeeState {
  final String message;
  EmployeeActionSuccess(this.message);
}

// Used to show error messages
class EmployeeError extends EmployeeState {
  final String message;
  EmployeeError(this.message);
}