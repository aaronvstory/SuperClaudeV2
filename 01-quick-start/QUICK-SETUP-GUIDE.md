# SuperClaude V2 - Quick Setup Guide 🚀

**Get your enhanced Claude Code environment running in 5 minutes!**

## 📋 Prerequisites Checklist

Before starting, make sure you have:
- ✅ **Windows 10/11** (64-bit)
- ✅ **Node.js 18+** ([Download here](https://nodejs.org/))
- ✅ **Git for Windows** ([Download here](https://git-scm.com/download/win))
- ✅ **Claude Desktop** ([Download here](https://claude.ai/download))
- ✅ **Administrative privileges** (required for installation)

## 🚀 30-Second Installation

### Step 1: Download SuperClaude V2
```bash
git clone https://github.com/aaronvstory/SuperClaudeV2.git
cd SuperClaudeV2
```

### Step 2: Run Master Installer
```batch
# Right-click and select "Run as administrator"
.\02-installers\MASTER-INSTALLER.bat
```

### Step 3: Launch Enhanced Claude Code
```batch
.\01-quick-start\LAUNCH-SUPERCLAUDE.bat
```

**That's it!** You now have the complete SuperClaude V2 experience.

## 🎯 Immediate Next Steps

### 1. Test AI Personas
Try these commands in Claude Code:
```
@frontend "Create a responsive navbar with shadcn/ui"
@security "Review this authentication code for vulnerabilities"
@performance "Analyze my React app for optimization opportunities"
```

### 2. Use Power Commands
```
/analyze components/ --depth 3 --focus architecture
/improve api/auth.js --security --validation
/troubleshoot "git push fails with authentication error"
```

### 3. Configure MCP Servers
Edit `%APPDATA%\Claude\claude_desktop_config.json` with your API keys:
```json
{
  "mcpServers": {
    "shadcn-ui": {
      "command": "npx",
      "args": ["@jpisnice/shadcn-ui-mcp-server"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "YOUR_GITHUB_PAT_HERE"
      }
    }
  }
}
```

## 🔧 Advanced Configuration

### GitHub Personal Access Token Setup
For shadcn/ui integration:
```batch
C:\claude\tools\setup-github-pat.bat
```

### Custom Persona Configuration
Edit `%USERPROFILE%\.claude\PERSONAS.md` to add your own specialists.

### Performance Optimization
```batch
C:\claude\tools\optimize-performance.bat
```

## 📚 Learning Resources

### Essential Documentation
- **[Printable Reference](PRINTABLE-REFERENCE.md)** - Desk reference card
- **[Command Reference](../06-documentation/COMMANDS-REFERENCE.md)** - Complete command guide
- **[Persona Guide](../06-documentation/PERSONAS-GUIDE.md)** - AI specialist system

### Quick Examples
- **Project Analysis**: `/analyze my-project/ --comprehensive`
- **Code Improvement**: `/improve components/Button.tsx --performance`
- **Security Review**: `@security "Audit this API endpoint"`
- **UI Creation**: `@frontend "Build a dashboard with shadcn/ui"`

## 🛠️ Troubleshooting

### Common Issues

**"Permission denied" errors**
```batch
# Run installer as Administrator
Right-click MASTER-INSTALLER.bat → "Run as administrator"
```

**Claude Code not found**
```bash
npm install -g @anthropic-ai/claude-code
```

**Git integration issues**
```batch
C:\claude\tools\fix-git-integration.bat
```

**MCP servers not working**
```batch
# Restart Claude Desktop after configuration
# Check: %APPDATA%\Claude\claude_desktop_config.json
```

## 🎉 Success Indicators

You'll know SuperClaude V2 is working when:
- ✅ AI personas auto-activate (you see `@frontend activated` messages)
- ✅ Power commands work (`/analyze` returns detailed insights)
- ✅ shadcn/ui components generate properly
- ✅ Git operations work seamlessly
- ✅ No WSL errors or dependencies

## 🆘 Getting Help

### Quick Support
- **Documentation**: `C:\claude\documentation\`
- **Tools**: `C:\claude\tools\`
- **Verification**: `C:\claude\tools\verify-installation.bat`

### Community Support
- **GitHub Issues**: [Report bugs](https://github.com/aaronvstory/SuperClaudeV2/issues)
- **GitHub Discussions**: [Ask questions](https://github.com/aaronvstory/SuperClaudeV2/discussions)
- **Documentation**: [Complete guides](../06-documentation/)

## 🚀 What's Next?

1. **Explore Personas** - Try all 11 AI specialists
2. **Learn Commands** - Master the 15 power commands
3. **Configure MCP** - Set up all 5 server integrations
4. **Optimize Workflow** - Customize for your development style
5. **Join Community** - Share experiences and get help

---

**Ready to transform your development experience?** 

Start with: `@frontend "Show me what you can do"`

**Welcome to SuperClaude V2!** 🎉
