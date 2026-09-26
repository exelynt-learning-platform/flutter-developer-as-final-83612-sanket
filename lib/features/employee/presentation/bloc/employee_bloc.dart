import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/employee_repository.dart';
import '../../data/models/employee_model.dart';
import '../../data/models/country_model.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  List<EmployeeModel> _allEmployees = [];
  List<CountryModel> _allCountries = [];

  EmployeeBloc({required this.repository}) : super(EmployeeInitial()) {
    on<FetchEmployees>(_onFetchEmployees);
    on<AddEmployee>(_onAddEmployee);
    on<UpdateEmployee>(_onUpdateEmployee);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<SearchEmployeeById>(_onSearchEmployeeById);
    on<FilterEmployees>(_onFilterEmployees);
  }

  Future<void> _onFetchEmployees(
    FetchEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    log('Event: FetchEmployees triggered');
    emit(EmployeeLoading());
    try {
      final results = await Future.wait([
        repository.getEmployees(),
        repository.getCountries(),
      ]);

      _allEmployees = results[0] as List<EmployeeModel>;
      _allCountries = results[1] as List<CountryModel>;

      log(
        'Success: Fetched ${_allEmployees.length} employees and ${_allCountries.length} countries',
      );
      emit(EmployeeLoaded(employees: _allEmployees, countries: _allCountries));
    } catch (e) {
      log('Error in FetchEmployees: $e', level: 1000);
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onAddEmployee(
    AddEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    log('Event: AddEmployee triggered for ${event.employee.name}');
    emit(EmployeeLoading());
    try {
      await repository.addEmployee(event.employee);
      log('Success: Employee added');
      emit(EmployeeActionSuccess("Employee added successfully"));
      add(FetchEmployees());
    } catch (e) {
      log('Error in AddEmployee: $e', level: 1000);
      emit(EmployeeError(e.toString()));
      emit(EmployeeLoaded(employees: _allEmployees, countries: _allCountries));
    }
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    log('Event: UpdateEmployee triggered for ID: ${event.id}');
    emit(EmployeeLoading());
    try {
      await repository.updateEmployee(event.id, event.employee);
      log('Success: Employee updated');
      emit(EmployeeActionSuccess("Employee updated successfully"));
      add(FetchEmployees());
    } catch (e) {
      log('Error in UpdateEmployee: $e', level: 1000);
      emit(EmployeeError(e.toString()));
      emit(EmployeeLoaded(employees: _allEmployees, countries: _allCountries));
    }
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    log('Event: DeleteEmployee triggered for ID: ${event.id}');
    emit(EmployeeLoading());
    try {
      await repository.deleteEmployee(event.id);
      log('Success: Employee deleted');
      emit(EmployeeActionSuccess("Employee deleted successfully"));
      add(FetchEmployees());
    } catch (e) {
      log('Error in DeleteEmployee: $e', level: 1000);
      emit(EmployeeError(e.toString()));
      emit(EmployeeLoaded(employees: _allEmployees, countries: _allCountries));
    }
  }

  void _onSearchEmployeeById(
    SearchEmployeeById event,
    Emitter<EmployeeState> emit,
  ) {
    log('Event: SearchEmployeeById triggered with query: ${event.id}');
    if (event.id.isEmpty) {
      emit(EmployeeLoaded(employees: _allEmployees, countries: _allCountries));
      return;
    }

    final filtered = _allEmployees.where((emp) => emp.id == event.id).toList();
    emit(EmployeeLoaded(employees: filtered, countries: _allCountries));
  }

  void _onFilterEmployees(FilterEmployees event, Emitter<EmployeeState> emit) {
    log('Event: FilterEmployees triggered with query: ${event.query}');
    final query = event.query.toLowerCase();
    if (query.isEmpty) {
      emit(EmployeeLoaded(employees: _allEmployees, countries: _allCountries));
      return;
    }

    final filtered = _allEmployees.where((emp) {
      return emp.name.toLowerCase().contains(query) ||
          emp.email.toLowerCase().contains(query) ||
          emp.mobile.toLowerCase().contains(query) ||
          emp.country.toLowerCase().contains(query);
    }).toList();

    emit(EmployeeLoaded(employees: filtered, countries: _allCountries));
  }
}
