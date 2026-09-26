class EmployeeModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String country;
  final String state;
  final String district;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.country,
    required this.state,
    required this.district,
  });

  // Converts the raw JSON map from the API into our Dart object
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
    );
  }

  // Converts our Dart object back into a JSON map to send to the API via POST/PUT
  Map<String, dynamic> toJson() {
    return {
      // We usually don't send the ID on POST, but MockAPI handles it safely
      'name': name,
      'email': email,
      'mobile': mobile,
      'country': country,
      'state': state,
      'district': district,
    };
  }
}
