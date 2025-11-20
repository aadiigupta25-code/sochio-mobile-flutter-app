import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../lib/services/api_service.dart';
import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ApiService Tests', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
    });

    group('getRequest', () {
      test('should return successful response', () async {
        when(mockClient.get(
          Uri.parse('https://sochio-backend.onrender.com/api/health'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('{"status": "ok"}', 200));

        final response = await ApiService.getRequest('api/health');
        
        expect(response.statusCode, 200);
        expect(response.body, '{"status": "ok"}');
      });

      test('should handle network failure', () async {
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenThrow(Exception('Network error'));

        expect(
          () => ApiService.getRequest('api/health'),
          throwsException,
        );
      });

      test('should retry on 401 and refresh token', () async {
        when(mockClient.get(
          Uri.parse('https://sochio-backend.onrender.com/api/health'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('Unauthorized', 401));

        when(mockClient.post(
          Uri.parse('https://sochio-backend.onrender.com/api/auth/refresh'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('{"token": "new_token"}', 200));

        when(mockClient.get(
          Uri.parse('https://sochio-backend.onrender.com/api/health'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('{"status": "ok"}', 200));

        final response = await ApiService.getRequest('api/health');
        
        expect(response.statusCode, 200);
        verify(mockClient.post(
          Uri.parse('https://sochio-backend.onrender.com/api/auth/refresh'),
          headers: anyNamed('headers'),
        )).called(1);
      });
    });

    group('postRequest', () {
      test('should return successful response', () async {
        final testData = {'email': 'test@test.com', 'password': 'password'};
        
        when(mockClient.post(
          Uri.parse('https://sochio-backend.onrender.com/api/auth/login'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('{"token": "test_token"}', 200));

        final response = await ApiService.postRequest('api/auth/login', testData);
        
        expect(response.statusCode, 200);
        expect(response.body, '{"token": "test_token"}');
      });

      test('should handle network failure', () async {
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenThrow(Exception('Network error'));

        expect(
          () => ApiService.postRequest('api/auth/login', {}),
          throwsException,
        );
      });

      test('should retry on 401 and refresh token', () async {
        final testData = {'test': 'data'};
        
        when(mockClient.post(
          Uri.parse('https://sochio-backend.onrender.com/api/test'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('Unauthorized', 401));

        when(mockClient.post(
          Uri.parse('https://sochio-backend.onrender.com/api/auth/refresh'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('{"token": "new_token"}', 200));

        when(mockClient.post(
          Uri.parse('https://sochio-backend.onrender.com/api/test'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('{"success": true}', 200));

        final response = await ApiService.postRequest('api/test', testData);
        
        expect(response.statusCode, 200);
        verify(mockClient.post(
          Uri.parse('https://sochio-backend.onrender.com/api/auth/refresh'),
          headers: anyNamed('headers'),
        )).called(1);
      });
    });

    group('testConnection', () {
      test('should return true for successful connection', () async {
        when(mockClient.get(
          Uri.parse('https://sochio-backend.onrender.com/api/health'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('{"status": "ok"}', 200));

        final result = await ApiService.testConnection();
        
        expect(result, true);
      });

      test('should return false for failed connection', () async {
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenThrow(Exception('Network error'));

        final result = await ApiService.testConnection();
        
        expect(result, false);
      });
    });

    group('login', () {
      test('should return user data on successful login', () async {
        final responseData = {'token': 'test_token', 'user': {'id': 1}};
        
        when(mockClient.post(
          Uri.parse('https://sochio-backend.onrender.com/api/auth/login'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(jsonEncode(responseData), 200));

        final result = await ApiService.login('test@test.com', 'password');
        
        expect(result, isNotNull);
        expect(result!['token'], 'test_token');
      });

      test('should return null on failed login', () async {
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('Unauthorized', 401));

        final result = await ApiService.login('test@test.com', 'wrong_password');
        
        expect(result, isNull);
      });
    });
  });
}