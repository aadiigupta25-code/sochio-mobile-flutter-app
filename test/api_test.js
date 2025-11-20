const https = require('https');

const baseUrl = 'https://sochio-backend.onrender.com';
const apiSecret = 'sochio-api-secret-2024';

async function makeRequestWithAuth(method, endpoint, data = null, token = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(endpoint, baseUrl);
    const options = {
      method,
      headers: {
        'Authorization': `Bearer ${apiSecret}`,
        'Content-Type': 'application/json'
      }
    };
    
    if (token) {
      options.headers['key'] = token;
    }

    const req = https.request(url, options, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        resolve({
          statusCode: res.statusCode,
          body: body,
          headers: res.headers
        });
      });
    });

    req.on('error', reject);
    
    if (data) {
      req.write(JSON.stringify(data));
    }
    
    req.end();
  });
}

async function makeRequest(method, endpoint, data = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(endpoint, baseUrl);
    const options = {
      method,
      headers: {
        'Authorization': `Bearer ${apiSecret}`,
        'Content-Type': 'application/json'
      }
    };

    const req = https.request(url, options, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        resolve({
          statusCode: res.statusCode,
          body: body,
          headers: res.headers
        });
      });
    });

    req.on('error', reject);
    
    if (data) {
      req.write(JSON.stringify(data));
    }
    
    req.end();
  });
}

async function testHealthCheck() {
  console.log('📡 Testing Health Check...');
  try {
    const response = await makeRequest('GET', '/api/health');
    console.log(`Status: ${response.statusCode}`);
    console.log(`Response: ${response.body}`);
    
    if (response.statusCode === 200) {
      console.log('✅ Health check passed\n');
    } else {
      console.log('❌ Health check failed\n');
    }
  } catch (error) {
    console.log(`❌ Health check error: ${error.message}\n`);
  }
}

async function testLogin() {
  console.log('🔐 Testing Login...');
  try {
    const loginData = {
      email: 'admin@sochio.com',
      password: 'Admin@123'
    };
    
    const response = await makeRequest('POST', '/admin/login', loginData);
    console.log(`Status: ${response.statusCode}`);
    console.log(`Response: ${response.body}`);
    
    if (response.statusCode === 200) {
      const data = JSON.parse(response.body);
      console.log('✅ Login successful');
      console.log(`Token: ${data.token?.substring(0, 20)}...\n`);
      return data.token;
    } else {
      console.log('❌ Login failed\n');
      return null;
    }
  } catch (error) {
    console.log(`❌ Login error: ${error.message}\n`);
    return null;
  }
}

async function testGetProducts(token) {
  console.log('📦 Testing Get Products...');
  try {
    const options = {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${apiSecret}`,
        'Content-Type': 'application/json'
      }
    };
    
    if (token) {
      options.headers['key'] = token;
    }
    
    const response = await makeRequestWithAuth('GET', '/product', null, token);
    console.log(`Status: ${response.statusCode}`);
    console.log(`Response: ${response.body}`);
    
    if (response.statusCode === 200) {
      const data = JSON.parse(response.body);
      console.log('✅ Products retrieved successfully');
      console.log(`Product count: ${data.product?.length || 0}\n`);
    } else {
      console.log('❌ Get products failed\n');
    }
  } catch (error) {
    console.log(`❌ Get products error: ${error.message}\n`);
  }
}

async function testGetCategories(token) {
  console.log('📂 Testing Get Categories...');
  try {
    const response = await makeRequestWithAuth('GET', '/category', null, token);
    console.log(`Status: ${response.statusCode}`);
    console.log(`Response: ${response.body}`);
    
    if (response.statusCode === 200) {
      const data = JSON.parse(response.body);
      console.log('✅ Categories retrieved successfully');
      console.log(`Category count: ${data.category?.length || 0}\n`);
    } else {
      console.log('❌ Get categories failed\n');
    }
  } catch (error) {
    console.log(`❌ Get categories error: ${error.message}\n`);
  }
}

async function runTests() {
  console.log('🚀 Starting API Endpoint Tests...\n');
  
  try {
    await testHealthCheck();
    const token = await testLogin();
    await testGetProducts(token);
    await testGetCategories(token);
  } catch (error) {
    console.log(`❌ Test suite failed: ${error.message}`);
  }
  
  console.log('✅ API Tests Completed');
}

runTests();