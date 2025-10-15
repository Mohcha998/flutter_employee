import '../../data/repository/employee_repository.dart';
import '../entities/employee.dart';

class EmployeeUsecase {
  final EmployeeRepository repository;
  EmployeeUsecase(this.repository);

  Future<List<Employee>> fetchEmployees() => repository.fetchEmployees();
  Future<Employee> createEmployee(Employee emp) =>
      repository.createEmployee(emp);
  Future<Employee> updateEmployee(Employee emp) =>
      repository.updateEmployee(emp);
  Future<void> deleteEmployee(int id) => repository.deleteEmployee(id);
}
