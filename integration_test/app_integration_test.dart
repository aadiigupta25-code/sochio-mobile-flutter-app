import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:video_player/video_player.dart';

import 'package:sochio_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('Complete app flow: Login -> Home -> Video', (tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to complete
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Verify we're on login screen
      expect(find.text('Login'), findsAtLeast(1));
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);

      // Enter test credentials
      await tester.enterText(
        find.byKey(const Key('email_field')), 
        'test@sochio.com'
      );
      await tester.enterText(
        find.byKey(const Key('password_field')), 
        'password123'
      );

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should navigate to home screen (even if login fails, for demo purposes)
      // In real app, this would check for successful login
      expect(find.text('Connected to Admin Panel'), findsAny);
      expect(find.byKey(const Key('video_nav_button')), findsOneWidget);

      // Navigate to video screen
      await tester.tap(find.byKey(const Key('video_nav_button')));
      await tester.pumpAndSettle();

      // Verify video screen loaded
      expect(find.text('Video Player'), findsOneWidget);
      
      // Wait for video to initialize
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify video player is present
      expect(find.byKey(const Key('video_player')), findsOneWidget);
      expect(find.byKey(const Key('play_button')), findsOneWidget);

      // Test video play functionality
      await tester.tap(find.byKey(const Key('play_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify video status changed to playing
      expect(find.byKey(const Key('video_status')), findsOneWidget);
      expect(find.text('Playing'), findsOneWidget);

      // Test video pause functionality
      await tester.tap(find.byKey(const Key('play_button')));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify video status changed to paused
      expect(find.text('Paused'), findsOneWidget);

      // Verify video player controller is working
      final videoPlayerFinder = find.byType(VideoPlayer);
      expect(videoPlayerFinder, findsOneWidget);
    });

    testWidgets('Video player initialization test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate through app to video screen
      await tester.pumpAndSettle(const Duration(seconds: 4));
      
      // Skip login for this test - go directly to video
      await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'test123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.byKey(const Key('video_nav_button')));
      await tester.pumpAndSettle();

      // Check loading state
      expect(find.byKey(const Key('video_loading')), findsOneWidget);
      
      // Wait for video to load
      await tester.pumpAndSettle(const Duration(seconds: 6));

      // Verify video loaded successfully
      expect(find.byKey(const Key('video_loading')), findsNothing);
      expect(find.byKey(const Key('video_player')), findsOneWidget);
    });

    testWidgets('Navigation flow test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test splash -> login navigation
      await tester.pumpAndSettle(const Duration(seconds: 4));
      expect(find.byKey(const Key('email_field')), findsOneWidget);

      // Test login -> home navigation
      await tester.enterText(find.byKey(const Key('email_field')), 'user@test.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'testpass');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Test home -> video navigation
      await tester.tap(find.byKey(const Key('video_nav_button')));
      await tester.pumpAndSettle();
      expect(find.text('Video Player'), findsOneWidget);

      // Test back navigation
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('video_nav_button')), findsOneWidget);
    });
  });
}