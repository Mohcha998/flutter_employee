import '../../domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required int id,
    required String name,
    required String email,
    required String position,
    required double salary,
  }) : super(
         id: id,
         name: name,
         email: email,
         position: position,
         salary: salary,
       );

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      position: json['position'],
      salary: (json['salary'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'position': position,
      'salary': salary,
    };
  }
}
