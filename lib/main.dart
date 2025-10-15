import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/employee_repository.dart';
import 'domain/usecases/auth_usecase.dart';
import 'domain/usecases/employee_usecase.dart';
import 'presentation/bloc/auth_cubit.dart';
import 'presentation/bloc/employee_cubit.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/employee_list_page.dart';

void main() {
  final authRepo = AuthRepository();
  final authUsecase = AuthUsecase(authRepo);

  final empRepo = EmployeeRepository();
  final empUsecase = EmployeeUsecase(empRepo);

  runApp(MyApp(authUsecase: authUsecase, empUsecase: empUsecase));
}

class MyApp extends StatelessWidget {
  final AuthUsecase authUsecase;
  final EmployeeUsecase empUsecase;
  const MyApp({super.key, required this.authUsecase, required this.empUsecase});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(authUsecase)..checkLogin()),
        BlocProvider(create: (_) => EmployeeCubit(empUsecase)),
      ],
      child: MaterialApp(
        title: 'Master Karyawan',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: BlocBuilder<AuthCubit, AuthStatus>(
          builder: (context, state) {
            switch (state) {
              case AuthStatus.loading:
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              case AuthStatus.authenticated:
                context.read<EmployeeCubit>().fetchEmployees();
                return const EmployeeListPage();
              case AuthStatus.unauthenticated:
              case AuthStatus.initial:
              default:
                return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
