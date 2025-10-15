import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/employee.dart';
import '../../domain/usecases/employee_usecase.dart';

enum EmployeeStatus { initial, loading, loaded, error }

class EmployeeCubit extends Cubit<EmployeeStatus> {
  final EmployeeUsecase usecase;
  List<Employee> employees = [];
  String errorMessage = '';

  EmployeeCubit(this.usecase) : super(EmployeeStatus.initial);

  Future<void> fetchEmployees() async {
    emit(EmployeeStatus.loading);
    try {
      employees = await usecase.fetchEmployees();
      emit(EmployeeStatus.loaded);
    } catch (e) {
      errorMessage = e.toString();
      emit(EmployeeStatus.error);
    }
  }

  Future<void> createEmployee(Employee emp) async {
    emit(EmployeeStatus.loading);
    try {
      final newEmp = await usecase.createEmployee(emp);
      employees.add(newEmp);
      emit(EmployeeStatus.loaded);
    } catch (e) {
      errorMessage = e.toString();
      emit(EmployeeStatus.error);
    }
  }

  Future<void> updateEmployee(Employee emp) async {
    emit(EmployeeStatus.loading);
    try {
      final updated = await usecase.updateEmployee(emp);
      final index = employees.indexWhere((e) => e.id == updated.id);
      if (index != -1) employees[index] = updated;
      emit(EmployeeStatus.loaded);
    } catch (e) {
      errorMessage = e.toString();
      emit(EmployeeStatus.error);
    }
  }

  Future<void> deleteEmployee(int id) async {
    emit(EmployeeStatus.loading);
    try {
      await usecase.deleteEmployee(id);
      employees.removeWhere((e) => e.id == id);
      emit(EmployeeStatus.loaded);
    } catch (e) {
      errorMessage = e.toString();
      emit(EmployeeStatus.error);
    }
  }
}
