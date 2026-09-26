import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/employee_model.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';

class AddEditEmployeePage extends StatefulWidget {
  // If employee is null, the form is in "Add" mode. If provided, it is in "Edit" mode.
  final EmployeeModel? employee;

  const AddEditEmployeePage({super.key, this.employee});

  @override
  State<AddEditEmployeePage> createState() => _AddEditEmployeePageState();
}

class _AddEditEmployeePageState extends State<AddEditEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _countryController;
  late TextEditingController _stateController;
  late TextEditingController _districtController;

  bool get isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    // Required Feature: Pre-populate employee data while editing
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _emailController = TextEditingController(
      text: widget.employee?.email ?? '',
    );
    _mobileController = TextEditingController(
      text: widget.employee?.mobile ?? '',
    );
    _countryController = TextEditingController(
      text: widget.employee?.country ?? '',
    );
    _stateController = TextEditingController(
      text: widget.employee?.state ?? '',
    );
    _districtController = TextEditingController(
      text: widget.employee?.district ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedEmployee = EmployeeModel(
        id: isEditing ? widget.employee!.id : '',
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        mobile: _mobileController.text.trim(),
        country: _countryController.text.trim(),
        state: _stateController.text.trim(),
        district: _districtController.text.trim(),
      );

      if (isEditing) {
        context.read<EmployeeBloc>().add(
          UpdateEmployee(id: widget.employee!.id, employee: updatedEmployee),
        );
      } else {
        context.read<EmployeeBloc>().add(AddEmployee(updatedEmployee));
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Employee' : 'Add Employee')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email is required';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                    return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _mobileController,
                label: 'Mobile Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Mobile number is required'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _countryController,
                label: 'Country',
                icon: Icons.public,
                validator: (value) => value == null || value.isEmpty
                    ? 'Country is required'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _stateController,
                label: 'State',
                icon: Icons.map,
                validator: (value) =>
                    value == null || value.isEmpty ? 'State is required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _districtController,
                label: 'District',
                icon: Icons.location_city,
                validator: (value) => value == null || value.isEmpty
                    ? 'District is required'
                    : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    isEditing ? 'Update Employee' : 'Save Employee',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
