# Claude MCP Configuration Setup

**PAPESLAY-Confirmed** - Complete MCP server configuration for Claude Desktop with multiple powerful integrations.

## 🔧 Quick Fix for Current Issues

### Perplexity API Error 401 Fix
Your current Perplexity API key has expired or your account is out of credits. 

**Immediate Solutions:**
1. **Check Credits**: Visit [Perplexity API Dashboard](https://www.perplexity.ai/settings/api) 
2. **Generate New Key**: If out of credits, add payment method and generate new API key
3. **Format Check**: Ensure key starts with `pplx-` followed by 40+ characters

### GitHub Token Issue
Your GitHub token format suggests it may be older. Consider regenerating for enhanced security.

## 📋 Complete MCP Server Configuration

This setup includes the following MCP servers:
- **researcher** - Perplexity AI for research and documentation
- **browser** - Puppeteer for web automation and testing  
- **memory** - Persistent memory across sessions
- **weather** - Brave Search for web searches
- **github** - GitHub integration for repository management
- **doc-scraper** - Custom document scraping server
- **desktop-commander** - Advanced filesystem and system operations
- **filesystem** - Basic filesystem operations with restricted access
- **everything** - Testing and validation server

## 🚀 Installation Instructions

### Prerequisites
- Node.js 18+ installed
- Python 3.8+ installed
- Claude Desktop application
- Git installed

### Step 1: API Keys Setup
You'll need to obtain the following API keys:

1. **Perplexity API Key**
   - Visit: https://www.perplexity.ai/settings/api
   - Generate new API key (starts with `pplx-`)
   - Add credits to your account

2. **GitHub Personal Access Token**
   - Visit: https://github.com/settings/tokens
   - Generate new token with repo permissions
   - Format: `ghp_` or newer `github_pat_` format

3. **Brave Search API Key**
   - Visit: https://api.search.brave.com/app/keys
   - Generate free API key
   - Format: Usually alphanumeric string

### Step 2: Configuration
1. Copy the `claude_desktop_config.json` template
2. Replace all placeholder API keys with your actual keys
3. Place the file in the correct location for your OS:
   - **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
   - **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - **Linux**: `~/.config/Claude/claude_desktop_config.json`

### Step 3: Custom Server Setup
Some servers require additional installation:

1. **Perplexity Server** (if using custom build):
   ```bash
   git clone [perplexity-server-repo]
   cd perplexity-server
   npm install
   npm run build
   ```

2. **Doc Scraper Server** (if using custom build):
   ```bash
   git clone [doc-scraper-repo]
   cd doc-scraper
   pip install -r requirements.txt
   ```

### Step 4: Verification
1. Restart Claude Desktop
2. Check that all MCP servers are loaded in the chat interface
3. Test each server with a simple command

## 🔐 Security Notes

- **NEVER commit API keys to git repositories**
- Store sensitive keys in environment variables when possible
- Regenerate keys periodically for security
- Use minimal required permissions for GitHub tokens

## 🛠️ Troubleshooting

### Common Issues
1. **401 Errors**: API key expired or invalid
2. **Module Not Found**: Missing Node.js packages
3. **Permission Denied**: Incorrect file permissions
4. **Server Not Starting**: Check paths and dependencies

### Log Locations
- Claude Desktop logs: Check application logs
- MCP server logs: Usually in console output
- Custom server logs: Check individual server directories

## 📚 Custom Instructions Integration

This configuration works best with the included custom instructions that enable:
- Autonomous development workflows
- Proper security handling
- Reasonably monolithic architecture preferences
- Proactive research and documentation

## 🤝 Contributing

Feel free to submit issues or improvements to this configuration setup.

## 📄 License

MIT License - Feel free to use and modify for your needs.
