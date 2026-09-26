import '../../data/models/country_model.dart';
import '../../data/models/employee_model.dart';

abstract class EmployeeRepository {
  Future<List<EmployeeModel>> getEmployees();
  Future<EmployeeModel> getEmployeeById(String id);
  Future<EmployeeModel> addEmployee(EmployeeModel employee);
  Future<EmployeeModel> updateEmployee(String id, EmployeeModel employee);
  Future<void> deleteEmployee(String id);
  Future<List<CountryModel>> getCountries();
}
