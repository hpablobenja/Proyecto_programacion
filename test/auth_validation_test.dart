import 'package:flutter_test/flutter_test.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor ingresa tu correo electrónico';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Por favor ingresa un correo válido';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor ingresa tu contraseña';
  }
  if (value.length < 5) {
    return 'La contraseña debe tener al menos 5 caracteres';
  }
  return null;
}

void main() {
  group('Login validation', () {
    test('Valid credentials pass validation', () {
      const email = 'hpablobenja18@gmail.com';
      const password = '12345';

      expect(validateEmail(email), isNull);
      expect(validatePassword(password), isNull);
    });

    test('Invalid email fails validation', () {
      const badEmail = 'hpablobenja18@';
      expect(validateEmail(badEmail), isNotNull);
    });

    test('Short password fails validation (<5)', () {
      const shortPass = '1234';
      expect(validatePassword(shortPass), isNotNull);
    });
  });
}
