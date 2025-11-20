import 'dart:convert';
import 'dart:io';

const String baseUrl = 'https://sochio-backend.onrender.com';
const String apiSecret = 'sochio-api-secret-2024';

void main() async {
  print('🚀 Starting API Endpoint Tests...\n');
  
  final client = HttpClient();
  
  try {
    // Test 1: Health Check
    await testHealthCheck(client);
    
    // Test 2: Login
    String? token = await testLogin(client);
    
    // Test 3: Get Videos
    await testGetVideos(client, token);
    
    // Test 4: Payment Creation
    await testPaymentCreation(client, token);
    
  } catch (e) {
    print('❌ Test suite failed: $e');
  } finally {
    client.close();
    print('\n✅ API Tests Completed');
  }
}

Future<void> testHealthCheck(HttpClient client) async {
  print('📡 Testing Health Check...');
  try {
    final request = await client.getUrl(Uri.parse('$baseUrl/api/health'));
    request.headers.set('Authorization', 'Bearer $apiSecret');
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('Status: ${response.statusCode}');
    print('Response: $responseBody');
    
    if (response.statusCode == 200) {
      print('✅ Health check passed\n');
    } else {
      print('❌ Health check failed\n');
    }
  } catch (e) {
    print('❌ Health check error: $e\n');
  }
}

Future<String?> testLogin(HttpClient client) async {
  print('🔐 Testing Login...');
  try {
    final request = await client.postUrl(Uri.parse('$baseUrl/api/auth/login'));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Authorization', 'Bearer $apiSecret');
    
    final loginData = {
      'email': 'admin@sochio.com',
      'password': 'admin123'
    };
    
    request.write(jsonEncode(loginData));
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('Status: ${response.statusCode}');
    print('Response: $responseBody');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      final token = data['token'];
      print('✅ Login successful');
      print('Token: ${token?.substring(0, 20)}...\n');
      return token;
    } else {
      print('❌ Login failed\n');
      return null;
    }
  } catch (e) {
    print('❌ Login error: $e\n');
    return null;
  }
}

Future<void> testGetVideos(HttpClient client, String? token) async {
  print('🎥 Testing Get Videos...');
  try {
    final request = await client.getUrl(Uri.parse('$baseUrl/api/videos'));
    request.headers.set('Authorization', 'Bearer $apiSecret');
    if (token != null) {
      request.headers.set('x-auth-token', token);
    }
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('Status: ${response.statusCode}');
    print('Response: $responseBody');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      print('✅ Videos retrieved successfully');
      print('Video count: ${data['videos']?.length ?? 0}\n');
    } else {
      print('❌ Get videos failed\n');
    }
  } catch (e) {
    print('❌ Get videos error: $e\n');
  }
}

Future<void> testPaymentCreation(HttpClient client, String? token) async {
  print('💳 Testing Payment Creation...');
  try {
    final request = await client.postUrl(Uri.parse('$baseUrl/api/payments/create'));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Authorization', 'Bearer $apiSecret');
    if (token != null) {
      request.headers.set('x-auth-token', token);
    }
    
    final paymentData = {
      'amount': 1000,
      'currency': 'INR',
      'productId': 'test_product_123',
      'userId': 'test_user_456'
    };
    
    request.write(jsonEncode(paymentData));
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('Status: ${response.statusCode}');
    print('Response: $responseBody');
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ Payment creation successful\n');
    } else {
      print('❌ Payment creation failed\n');
    }
  } catch (e) {
    print('❌ Payment creation error: $e\n');
  }
}