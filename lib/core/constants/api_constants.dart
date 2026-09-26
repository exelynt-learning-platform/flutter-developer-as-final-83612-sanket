// WHAT: Centralized API URLs.
// WHY: Prevents hardcoding URLs across the app. Easy to change environments (Dev/Prod).
class ApiConstants {
  static const String baseUrl = 'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/';
  static const String employeeEndpoint = 'employee';
  static const String countryEndpoint = 'country';
}