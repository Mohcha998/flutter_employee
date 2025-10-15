# Employee Management System - Frontend

Frontend menggunakan **Flutter** dengan **Cubit** untuk state management, terhubung ke backend Django JWT.

---

## 🔹 Fitur

- Login Page (username + password)
- Employee List Page (Card UI, Swipe-to-Delete, Pull-to-Refresh)
- Employee Form Page (Add / Edit, Salary format IDR)
- Logout
- JWT disimpan di SharedPreferences

---

## 🔹 Struktur Project

lib
│ ├── core
│ │ └── constants.dart
│ ├── data
│ │ ├── models
│ │ │ └── employee_model.dart
│ │ └── repository
│ │ ├── auth_repository.dart
│ │ └── employee_repository.dart
│ ├── domain
│ │ ├── entities
│ │ │ └── employee.dart
│ │ └── usecases
│ │ ├── auth_usecase.dart
│ │ └── employee_usecase.dart
│ ├── main.dart
│ └── presentation
│ ├── bloc
│ │ ├── auth_cubit.dart
│ │ └── employee_cubit.dart
│ └── pages
│ ├── employee_form_page.dart
│ ├── employee_list_page.dart
│ └── login_page.dart

---

## 🔹 Setup Flutter

### Prasyarat

- Flutter SDK >= 3.x
- Dart >= 3.1
- Android Studio / VSCode
- Emulator / Device

### Instalasi

```bash
# Clone project
git clone <repo-url>
cd employee_app

# Install dependencies
flutter pub get

# SET UP API
const String baseUrl = 'http://127.0.0.1:8000/api';

Jalankan Aplikasi

flutter run
```
