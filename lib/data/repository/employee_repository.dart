import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/employee_model.dart';
import '../../domain/entities/employee.dart';

const String baseUrl = 'http://localhost:8000/api';

class EmployeeRepository {
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) throw Exception('User not authenticated');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Employee>> fetchEmployees() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/employees/'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => EmployeeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<Employee> createEmployee(Employee emp) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/employees/'),
      headers: headers,
      body: jsonEncode(
        EmployeeModel(
          id: emp.id,
          name: emp.name,
          email: emp.email,
          position: emp.position,
          salary: emp.salary,
        ).toJson(),
      ),
    );
    if (response.statusCode == 201) {
      return EmployeeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create employee');
    }
  }

  Future<Employee> updateEmployee(Employee emp) async {
    final headers = await _getHeaders();
    final url = '$baseUrl/employees/${emp.id}/';
    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(
        EmployeeModel(
          id: emp.id,
          name: emp.name,
          email: emp.email,
          position: emp.position,
          salary: emp.salary,
        ).toJson(),
      ),
    );
    if (response.statusCode == 200) {
      return EmployeeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update employee');
    }
  }

  Future<void> deleteEmployee(int id) async {
    final headers = await _getHeaders();
    final url = '$baseUrl/employees/$id/';
    final response = await http.delete(Uri.parse(url), headers: headers);
    if (response.statusCode != 204) {
      throw Exception('Failed to delete employee');
    }
  }
}
