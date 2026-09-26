import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/repositories/employee_repository.dart';
import '../models/country_model.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  static const String cachedEmployeesKey = 'CACHED_EMPLOYEES';

  EmployeeRepositoryImpl({
    required this.apiClient,
    required this.sharedPreferences,
  });

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    try {
      // 1. Try to fetch fresh data from the API
      final response = await apiClient.get('/employee');
      final List<EmployeeModel> employees = (response as List)
          .map((json) => EmployeeModel.fromJson(json))
          .toList();

      // 2. If successful, cache the data locally
      sharedPreferences.setString(
        cachedEmployeesKey,
        json.encode(employees.map((e) => e.toJson()).toList()),
      );

      return employees;
    } catch (e) {
      // 3. If the network fails, attempt to load from SharedPreferences
      final cachedData = sharedPreferences.getString(cachedEmployeesKey);
      if (cachedData != null) {
        final List<dynamic> decodedData = json.decode(cachedData);
        return decodedData.map((json) => EmployeeModel.fromJson(json)).toList();
      }
      // If there is no network and no cache, bubble up the error
      rethrow;
    }
  }

  @override
  Future<EmployeeModel> getEmployeeById(String id) async {
    final response = await apiClient.get('/employee/$id');
    return EmployeeModel.fromJson(response);
  }

  @override
  Future<EmployeeModel> addEmployee(EmployeeModel employee) async {
    final response = await apiClient.post('/employee', body: employee.toJson());
    return EmployeeModel.fromJson(response);
  }

  @override
  Future<EmployeeModel> updateEmployee(
    String id,
    EmployeeModel employee,
  ) async {
    final response = await apiClient.put(
      '/employee/$id',
      body: employee.toJson(),
    );
    return EmployeeModel.fromJson(response);
  }

  @override
  Future<void> deleteEmployee(String id) async {
    await apiClient.delete('/employee/$id');
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    final response = await apiClient.get('/country');
    return (response as List)
        .map((json) => CountryModel.fromJson(json))
        .toList();
  }
}
