import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/employee_cubit.dart';
import '../bloc/auth_cubit.dart';
import 'employee_form_page.dart';
import '../../domain/entities/employee.dart';

class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({super.key});

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final empCubit = context.read<EmployeeCubit>();
    empCubit.fetchEmployees(); // load employees

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: BlocBuilder<EmployeeCubit, EmployeeStatus>(
        builder: (context, state) {
          if (state == EmployeeStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state == EmployeeStatus.error) {
            return Center(
              child: Text(
                empCubit.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state == EmployeeStatus.loaded) {
            final employees = empCubit.employees;
            if (employees.isEmpty) {
              return const Center(child: Text('No employees found'));
            }
            return RefreshIndicator(
              onRefresh: () => empCubit.fetchEmployees(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final emp = employees[index];
                  return Dismissible(
                    key: Key(emp.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text(
                            'Are you sure you want to delete ${emp.name}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (_) => empCubit.deleteEmployee(emp.id),
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        title: Text(
                          emp.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(emp.position),
                            const SizedBox(height: 4),
                            Text(
                              formatCurrency(emp.salary),
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmployeeFormPage(employee: emp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmployeeFormPage()),
        ),
      ),
    );
  }
}
