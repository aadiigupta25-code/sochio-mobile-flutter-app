import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../lib/screens/login_screen.dart';
import '../lib/screens/home_screen.dart';
import '../lib/services/api_service.dart';

class MockApiService extends Mock {
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    return null;
  }
}

@GenerateMocks([MockApiService])
void main() {
  group('LoginScreen Widget Tests', () {
    
    Widget createLoginScreen() {
      return GetMaterialApp(
        home: const LoginScreen(),
      );
    }

    testWidgets('should display login form elements', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
      expect(find.text('Login'), findsNWidgets(2)); // AppBar + Button
    });

    testWidgets('should validate empty email field', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should validate invalid email format', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(find.byKey(const Key('email_field')), 'invalid-email');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('should validate empty password field', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should validate short password', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');
      await tester.enterText(find.byKey(const Key('password_field')), '123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('should show loading indicator during login', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message on login failure', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'wrongpassword');
      
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('Invalid email or password'), findsOneWidget);
    });

    testWidgets('should accept valid email formats', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      final validEmails = [
        'test@example.com',
        'user.name@domain.co.uk',
        'admin@sochio.com'
      ];

      for (String email in validEmails) {
        await tester.enterText(find.byKey(const Key('email_field')), email);
        await tester.enterText(find.byKey(const Key('password_field')), 'password123');
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pump();

        expect(find.text('Enter a valid email'), findsNothing);
        
        // Clear fields for next test
        await tester.enterText(find.byKey(const Key('email_field')), '');
        await tester.enterText(find.byKey(const Key('password_field')), '');
      }
    });

    testWidgets('should disable login button when loading', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      final loginButton = tester.widget<ElevatedButton>(find.byKey(const Key('login_button')));
      expect(loginButton.onPressed, isNull);
    });

    testWidgets('should clear error message on new login attempt', (tester) async {
      await tester.pumpWidget(createLoginScreen());

      // First failed attempt
      await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'wrong');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(find.byKey(const Key('error_message')), findsOneWidget);

      // Second attempt should clear error
      await tester.enterText(find.byKey(const Key('password_field')), 'newpassword');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      expect(find.byKey(const Key('error_message')), findsNothing);
    });
  });
}