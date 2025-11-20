const https = require('https');

const baseUrl = 'https://sochio-backend.onrender.com';
const apiSecret = 'sochio-api-secret-2024';

async function makeAuthRequest(method, endpoint, data = null, token = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(endpoint, baseUrl);
    const options = {
      method,
      headers: {
        'Authorization': `Bearer ${apiSecret}`,
        'Content-Type': 'application/json'
      }
    };
    
    // Use API secret key for authentication
    options.headers['key'] = apiSecret;

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

async function runFinalTests() {
  console.log('🚀 Final API Connection Test\n');
  
  try {
    // 1. Test Admin Login
    console.log('🔐 Testing Admin Login...');
    const loginResponse = await makeAuthRequest('POST', '/admin/login', {
      email: 'admin@sochio.com',
      password: 'Admin@123'
    });
    
    console.log(`Status: ${loginResponse.statusCode}`);
    
    if (loginResponse.statusCode === 200) {
      const loginData = JSON.parse(loginResponse.body);
      if (loginData.status) {
        console.log('✅ Admin login successful');
        const token = loginData.token;
        
        // 2. Test Products Endpoint
        console.log('\n📦 Testing Products Endpoint...');
        const productsResponse = await makeAuthRequest('GET', '/product/getRealProducts', null, token);
        console.log(`Status: ${productsResponse.statusCode}`);
        
        if (productsResponse.statusCode === 200) {
          try {
            const productsData = JSON.parse(productsResponse.body);
            console.log('✅ Products endpoint working');
            console.log(`Product count: ${productsData.product?.length || 0}`);
          } catch (e) {
            console.log('❌ Products response not JSON');
          }
        } else {
          console.log('❌ Products endpoint failed');
        }
        
        // 3. Test Categories Endpoint
        console.log('\n📂 Testing Categories Endpoint...');
        const categoriesResponse = await makeAuthRequest('GET', '/category', null, token);
        console.log(`Status: ${categoriesResponse.statusCode}`);
        
        if (categoriesResponse.statusCode === 200) {
          try {
            const categoriesData = JSON.parse(categoriesResponse.body);
            console.log('✅ Categories endpoint working');
            console.log(`Category count: ${categoriesData.category?.length || 0}`);
          } catch (e) {
            console.log('❌ Categories response not JSON');
          }
        } else {
          console.log('❌ Categories endpoint failed');
        }
        
      } else {
        console.log('❌ Login failed:', loginData.message);
      }
    } else {
      console.log('❌ Login request failed');
    }
    
  } catch (error) {
    console.log('❌ Test failed:', error.message);
  }
  
  console.log('\n✅ Final API Test Completed');
}

runFinalTests();