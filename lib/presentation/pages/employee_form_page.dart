import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/employee.dart';
import '../bloc/employee_cubit.dart';

class EmployeeFormPage extends StatefulWidget {
  final Employee? employee;
  const EmployeeFormPage({super.key, this.employee});

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final positionController = TextEditingController();
  final salaryController = TextEditingController();
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      nameController.text = widget.employee!.name;
      emailController.text = widget.employee!.email;
      positionController.text = widget.employee!.position;
      salaryController.text = formatter.format(widget.employee!.salary);
    }
  }

  double parseCurrency(String value) {
    // Hapus Rp, titik, dan spasi
    return double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EmployeeCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? 'Add Employee' : 'Edit Employee'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(nameController, 'Name', Icons.person),
              const SizedBox(height: 16),
              buildTextField(
                emailController,
                'Email',
                Icons.email,
                keyboard: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              buildTextField(positionController, 'Position', Icons.work),
              const SizedBox(height: 16),
              TextFormField(
                controller: salaryController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Salary',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.monetization_on),
                ),
                onChanged: (value) {
                  final plain = parseCurrency(value);
                  salaryController.value = TextEditingValue(
                    text: formatter.format(plain),
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: formatter.format(plain).length),
                    ),
                  );
                },
                validator: (value) {
                  if (parseCurrency(value ?? '') <= 0)
                    return 'Salary must be greater than 0';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final emp = Employee(
                        id: widget.employee?.id ?? 0,
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        position: positionController.text.trim(),
                        salary: parseCurrency(salaryController.text),
                      );
                      if (widget.employee == null) {
                        cubit.createEmployee(emp);
                      } else {
                        cubit.updateEmployee(emp);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    widget.employee == null
                        ? 'Add Employee'
                        : 'Update Employee',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty)
          return '$label cannot be empty';
        return null;
      },
    );
  }
}
