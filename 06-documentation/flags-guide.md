# SuperClaude Flags User Guide 🏁

A practical guide to SuperClaude's flag system. Flags are like command-line options that change how SuperClaude behaves - think of them as superpowers for your commands.

## What Are Flags? 🤔

**Flags are modifiers** that change how SuperClaude processes your requests. They come after commands and start with `--`.

**Basic syntax**:
```bash
/command --flag-name
/command --flag-name value
/analyze src/ --focus security --depth deep
```

**Two ways flags work**:
1. **Manual** - You add them explicitly: `/analyze --think --focus security`
2. **Auto-activation** - SuperClaude adds them based on context (this happens a lot!)

**Why use flags?**
- Get better, more focused results
- Control SuperClaude's thinking depth
- Enable special capabilities (MCP servers)
- Optimize for speed or detail
- Direct attention to specific areas

## Flag Categories 📂

### Planning & Analysis Flags 🧠

These control how deeply SuperClaude thinks about your request.

#### `--plan`
**What it does**: Shows execution plan before doing anything  
**When to use**: When you want to see what SuperClaude will do first  
**Example**: `/build --plan` - See build steps before running

#### `--think`
**What it does**: Multi-file analysis (~4K tokens)  
**When to use**: Complex problems involving several files  
**Auto-activates**: Import chains >5 files, cross-module calls >10 references  
**Example**: `/analyze complex-system/ --think`

#### `--think-hard` 
**What it does**: Deep architectural analysis (~10K tokens)  
**When to use**: System-wide problems, architectural decisions  
**Auto-activates**: System refactoring, bottlenecks >3 modules  
**Example**: `/improve legacy-system/ --think-hard`

#### `--ultrathink`
**What it does**: Maximum depth analysis (~32K tokens)  
**When to use**: Critical system redesign, complex debugging  
**Auto-activates**: Legacy modernization, critical vulnerabilities  
**Example**: `/troubleshoot "entire auth system broken" --ultrathink`

**💡 Tip**: Start with `--think`, only go deeper if needed. More thinking = slower but more thorough.

---

### Efficiency & Control Flags ⚡

Control output style, safety, and performance.

#### `--uc` / `--ultracompressed`
**What it does**: 60-80% token reduction using symbols  
**When to use**: Large operations, when context is getting full  
**Auto-activates**: Context usage >75%, large-scale operations  
**Example**: `/analyze huge-codebase/ --uc`

#### `--safe-mode`
**What it does**: Maximum validation, conservative execution  
**When to use**: Production environments, risky operations  
**Auto-activates**: Resource usage >85%, production environment  
**Example**: `/improve production-code/ --safe-mode`

#### `--validate`
**What it does**: Pre-operation validation and risk assessment  
**When to use**: Want to check before making changes  
**Auto-activates**: Risk score >0.7  
**Example**: `/cleanup legacy/ --validate`

#### `--verbose`
**What it does**: Maximum detail and explanation  
**When to use**: Learning, debugging, need full context  
**Example**: `/build --verbose` - See every build step

#### `--answer-only`
**What it does**: Direct response without task creation  
**When to use**: Quick questions, don't want workflow automation  
**Example**: `/explain React hooks --answer-only`

**💡 Tip**: `--uc` is great for big operations. `--safe-mode` for anything important. `--verbose` when you're learning.

---

### MCP Server Flags 🔧

Enable specialized capabilities through MCP servers.

#### `--c7` / `--context7`
**What it does**: Enables Context7 for official library documentation  
**When to use**: Working with frameworks, need official docs  
**Auto-activates**: External library imports, framework questions  
**Example**: `/build react-app/ --c7` - Get React best practices

#### `--seq` / `--sequential`
**What it does**: Enables Sequential for complex multi-step analysis  
**When to use**: Complex debugging, system design  
**Auto-activates**: Complex debugging, `--think` flags  
**Example**: `/troubleshoot "auth flow broken" --seq`

#### `--magic`
**What it does**: Enables Magic for UI component generation  
**When to use**: Creating UI components, design systems  
**Auto-activates**: UI component requests, frontend persona  
**Example**: `/build dashboard --magic` - Get modern UI components

#### `--play` / `--playwright`
**What it does**: Enables Playwright for browser automation and testing  
**When to use**: E2E testing, performance monitoring  
**Auto-activates**: Test workflows, QA persona  
**Example**: `/test e2e --play`

#### `--all-mcp`
**What it does**: Enables all MCP servers simultaneously  
**When to use**: Complex multi-domain problems  
**Auto-activates**: Problem complexity >0.8, multi-domain indicators  
**Example**: `/analyze entire-app/ --all-mcp`

#### `--no-mcp`
**What it does**: Disables all MCP servers, native tools only  
**When to use**: Faster execution, don't need specialized features  
**Example**: `/analyze simple-script.js --no-mcp`

**💡 Tip**: MCP servers add capabilities but use more tokens. `--c7` for docs, `--seq` for thinking, `--magic` for UI.

---

### Advanced Orchestration Flags 🎭

For complex operations and workflows.

#### `--delegate [files|folders|auto]`
**What it does**: Enables sub-agent delegation for parallel processing  
**When to use**: Large codebases, complex analysis  
**Auto-activates**: >7 directories or >50 files  
**Options**:
- `files` - Delegate individual file analysis
- `folders` - Delegate directory-level analysis  
- `auto` - Smart delegation strategy

**Example**: `/analyze monorepo/ --delegate auto`

#### `--wave-mode [auto|force|off]`
**What it does**: Multi-stage execution with compound intelligence  
**When to use**: Complex improvements, systematic analysis  
**Auto-activates**: Complexity >0.8 AND files >20 AND operation types >2  
**Example**: `/improve legacy-system/ --wave-mode force`

#### `--loop`
**What it does**: Iterative improvement mode  
**When to use**: Quality improvement, refinement operations  
**Auto-activates**: Polish, refine, enhance keywords  
**Example**: `/improve messy-code.js --loop`

#### `--concurrency [n]`
**What it does**: Control max concurrent sub-agents (1-15)  
**When to use**: Controlling resource usage  
**Example**: `/analyze --delegate auto --concurrency 3`

**💡 Tip**: These are powerful but complex. Start with `--delegate auto` for big projects, `--loop` for improvements.

---

### Focus & Scope Flags 🎯

Direct SuperClaude's attention to specific areas.

#### `--scope [level]`
**Options**: file, module, project, system  
**What it does**: Sets analysis scope  
**Example**: `/analyze --scope module auth/`

#### `--focus [domain]`
**Options**: performance, security, quality, architecture, accessibility, testing  
**What it does**: Focuses analysis on specific domain  
**Example**: `/analyze --focus security --scope project`

#### Persona Flags
**Available personas**: architect, frontend, backend, analyzer, security, mentor, refactorer, performance, qa, devops, scribe  
**What they do**: Activates specialist behavior patterns  
**Example**: `/analyze --persona-security` - Security-focused analysis

**💡 Tip**: `--focus` is great for targeted analysis. Personas auto-activate but manual control helps.

---

## Common Flag Patterns 🔄

### Quick Analysis
```bash
/analyze src/ --focus quality          # Quick quality check
/analyze --uc --focus security         # Fast security scan
```

### Deep Investigation  
```bash
/troubleshoot "bug" --think --seq      # Systematic debugging
/analyze --think-hard --focus architecture  # Architectural analysis
```

### Large Project Work
```bash
/analyze monorepo/ --delegate auto --uc     # Efficient large analysis
/improve legacy/ --wave-mode auto --safe-mode  # Safe systematic improvement
```

### Learning & Documentation
```bash
/explain React hooks --c7 --verbose    # Detailed explanation with docs
/document api/ --persona-scribe        # Professional documentation
```

### Performance-Focused
```bash
/analyze --focus performance --play     # Performance analysis with testing
/build --uc --no-mcp                   # Fast build without extra features
```

### Security-Focused
```bash
/analyze --focus security --think --validate  # Thorough security analysis
/scan --persona-security --safe-mode         # Conservative security scan
```

## Practical Examples 💡

### Before/After: Basic Analysis
**Before** (basic):
```bash
/analyze auth.js
# → Simple file analysis
```

**After** (with flags):
```bash
/analyze auth.js --focus security --think --c7
# → Security-focused analysis with deep thinking and official docs
# → Much more thorough, finds security patterns, checks against best practices
```

### Before/After: Large Project
**Before** (slow):
```bash
/analyze huge-monorepo/
# → Tries to analyze everything at once, may timeout or use too many tokens
```

**After** (efficient):
```bash
/analyze huge-monorepo/ --delegate auto --uc --focus architecture
# → Delegates work to sub-agents, compresses output, focuses on architecture
# → Faster, more focused, better results
```

### Before/After: Improvement Work
**Before** (risky):
```bash
/improve legacy-system/
# → May make too many changes, could break things
```

**After** (safe):
```bash
/improve legacy-system/ --safe-mode --loop --validate --preview
# → Safe changes only, iterative approach, validates first, shows preview
# → Much safer, progressive improvement
```

## Auto-Activation Examples 🤖

SuperClaude automatically adds flags based on context. Here's when:

### Complexity-Based
```bash
/analyze huge-codebase/
# Auto-adds: --delegate auto --uc
# Why: >50 files detected, context management needed

/troubleshoot "complex system issue"  
# Auto-adds: --think --seq
# Why: Multi-component problem detected
```

### Domain-Based
```bash
/build react-app/
# Auto-adds: --c7 --persona-frontend
# Why: Frontend framework detected

/analyze --focus security
# Auto-adds: --persona-security --validate
# Why: Security focus triggers security specialist
```

### Performance-Based
```bash
# When context usage >75%
/analyze large-project/
# Auto-adds: --uc
# Why: Token optimization needed

# When risk score >0.7
/improve production-code/
# Auto-adds: --safe-mode --validate
# Why: High-risk operation detected
```

## Advanced Usage 🚀

### Complex Flag Combinations

**Comprehensive Code Review**:
```bash
/review codebase/ --persona-qa --think-hard --focus quality --validate --c7
# → QA specialist + deep thinking + quality focus + validation + docs
```

**Legacy System Modernization**:
```bash
/improve legacy/ --wave-mode force --persona-architect --safe-mode --loop --c7
# → Wave orchestration + architect perspective + safety + iteration + docs
```

**Security Audit**:
```bash
/scan --persona-security --ultrathink --focus security --validate --seq
# → Security specialist + maximum thinking + security focus + validation + systematic analysis
```

### Performance Optimization

**For Speed**:
```bash
/analyze --no-mcp --uc --scope file
# → Disable extra features, compress output, limit scope
```

**For Thoroughness**:
```bash
/analyze --all-mcp --think-hard --delegate auto
# → All capabilities, deep thinking, parallel processing
```

### Custom Workflows

**Bug Investigation Workflow**:
```bash
/troubleshoot "specific error" --seq --think --validate
/analyze affected-files/ --focus quality --persona-analyzer  
/test --play --coverage
```

**Feature Development Workflow**:
```bash
/design new-feature --persona-architect --c7
/build --magic --persona-frontend --validate
/test --play --coverage
/document --persona-scribe --c7
```

## Quick Reference 📋

### Most Useful Flags
| Flag | Purpose | When to Use |
|------|---------|-------------|
| `--think` | Deeper analysis | Complex problems |
| `--uc` | Compress output | Large operations |
| `--safe-mode` | Conservative execution | Important code |
| `--c7` | Official docs | Framework work |
| `--seq` | Systematic analysis | Debugging |
| `--focus security` | Security focus | Security concerns |
| `--delegate auto` | Parallel processing | Large codebases |
| `--validate` | Check before action | Risky operations |

### Flag Combinations That Work Well
```bash
# Safe improvement
--safe-mode --validate --preview

# Deep analysis  
--think --seq --c7

# Large project
--delegate auto --uc --focus

# Learning
--verbose --c7 --persona-mentor

# Security work
--persona-security --focus security --validate

# Performance work
--persona-performance --focus performance --play
```

### Auto-Activation Triggers
- **--think**: Complex imports, cross-module calls
- **--uc**: Context >75%, large operations  
- **--safe-mode**: Resource usage >85%, production
- **--delegate**: >7 directories or >50 files
- **--c7**: Framework imports, documentation requests
- **--seq**: Debugging keywords, --think flags
- **Personas**: Domain-specific keywords and patterns

## Troubleshooting Flag Issues 🚨

### Common Problems

**"Flags don't seem to work"**
- Check spelling (common typos: `--ultracompresed`, `--persona-fronted`)
- Some flags need values: `--scope project`, `--focus security`
- Flag conflicts: `--no-mcp` overrides `--c7`, `--seq`, etc.

**"Operation too slow"**
- Try `--uc` for compression
- Use `--no-mcp` to disable extra features
- Limit scope: `--scope file` instead of `--scope project`

**"Too much output"**
- Add `--uc` for compression
- Remove `--verbose` if present
- Use `--answer-only` for simple questions

**"Not thorough enough"**
- Add `--think` or `--think-hard`
- Enable relevant MCP servers: `--seq`, `--c7`
- Use appropriate persona: `--persona-analyzer`

**"Changes too risky"**
- Always use `--safe-mode` for important code
- Add `--validate` to check first
- Use `--preview` to see changes before applying

### Flag Conflicts

**These override others**:
- `--no-mcp` overrides all MCP flags (`--c7`, `--seq`, etc.)
- `--safe-mode` overrides optimization flags
- Last persona flag wins: `--persona-frontend --persona-backend` → backend

**Precedence order**:
1. Safety flags (`--safe-mode`) beat optimization
2. Explicit flags beat auto-activation
3. Thinking depth: `--ultrathink` > `--think-hard` > `--think`
4. Scope: system > project > module > file

## Tips for Effective Flag Usage 💡

### Starting Out
1. **Begin simple**: Try basic flags like `--think` and `--focus`
2. **Watch auto-activation**: See what SuperClaude adds automatically
3. **Use `--help`**: Many commands show available flags
4. **Start safe**: Use `--safe-mode` and `--validate` for important work

### Getting Advanced
1. **Learn combinations**: `--think --seq --c7` works great together
2. **Understand auto-activation**: Know when flags get added automatically
3. **Use personas**: They're like having specialists on your team
4. **Optimize for your workflow**: Fast (`--uc --no-mcp`) vs thorough (`--think-hard --all-mcp`)

### Performance Tips
- **For speed**: `--uc --no-mcp --scope file`
- **For thoroughness**: `--think-hard --all-mcp --delegate auto`
- **For safety**: `--safe-mode --validate --preview`
- **For learning**: `--verbose --c7 --persona-mentor`

---

## Final Notes 📝

**Remember:**
- Flags make SuperClaude more powerful but also more complex
- Start simple and add flags as you learn what they do
- Auto-activation usually gets it right - trust it until you know better
- `--safe-mode` and `--validate` are your friends for important work

**Still evolving:**
- Some advanced flags (wave, delegation) are still experimental
- Auto-activation keeps getting smarter
- New flags and capabilities are added regularly

**When in doubt:**
- Start with basic commands and see what auto-activates
- Use `--safe-mode` for anything important
- Check the commands guide for flag suggestions per command
- GitHub issues are great for flag-related questions

**Happy flagging!** 🚩 These flags can really supercharge your SuperClaude experience once you get the hang of them.

---

*Flags are like spices - a little goes a long way, and the right combination can make everything better! 🌶️*