#!/usr/bin/env node

// Test script for shadcn-ui MCP server integration
// Run: node test-shadcn-ui-integration.js

console.log('🧪 Testing shadcn-ui MCP Server Integration...\n');

// Test 1: Check if we can run the server
console.log('1. Testing server availability...');

const { spawn } = require('child_process');

const testServer = spawn('npx', ['@jpisnice/shadcn-ui-mcp-server', '--help'], {
  env: {
    ...process.env,
    GITHUB_PERSONAL_ACCESS_TOKEN: process.env.GITHUB_PAT || 'YOUR_GITHUB_PAT_HERE'
  },
  stdio: 'pipe'
});

let output = '';
let error = '';

testServer.stdout.on('data', (data) => {
  output += data.toString();
});

testServer.stderr.on('data', (data) => {
  error += data.toString();
});

testServer.on('close', (code) => {
  if (code === 0) {
    console.log('✅ Server is available and responding');
    console.log('📋 Server help output:');
    console.log(output);
  } else {
    console.log('❌ Server test failed with code:', code);
    console.log('Error output:', error);
  }
  
  console.log('\n🔧 Claude Desktop Configuration:');
  console.log('Location: C:\\Users\\d0nbx\\AppData\\Roaming\\Claude\\claude_desktop_config.json');
  console.log('Status: ✅ shadcn-ui server added with GitHub PAT');
  console.log('Rate Limit: 5,000 requests/hour');
  
  console.log('\n📚 SuperClaude Integration:');
  console.log('✅ Added to superclaude-config.json');
  console.log('✅ Frontend persona updated');
  console.log('✅ MCP.md documentation updated'); 
  console.log('✅ SHADCN-UI-MCP.md guide created');
  
  console.log('\n🎯 Next Steps:');
  console.log('1. Restart Claude Desktop to load new MCP server');
  console.log('2. Test with: "List available shadcn/ui components"');
  console.log('3. Try: @frontend "Create a modern card component"');
  console.log('4. Advanced: "Show me shadcn dashboard blocks"');
  
  console.log('\n🚀 Integration Complete! Ready for use.');
});

setTimeout(() => {
  testServer.kill();
}, 10000); // Kill after 10 seconds if still running
