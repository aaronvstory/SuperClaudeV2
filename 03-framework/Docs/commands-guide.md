# SuperClaude Commands Guide 🛠️

A practical guide to all 15 SuperClaude slash commands. We'll be honest about what works well and what's still rough around the edges.

## Quick Reference 📋

| Command | Purpose | Best For |
|---------|---------|----------|
| `/analyze` | Code analysis | Finding issues, understanding codebases |
| `/build` | Project building | Compilation, bundling, deployment prep |
| `/cleanup` | Technical debt | Removing dead code, organizing files |
| `/design` | System design | Architecture planning, API design |
| `/document` | Documentation | README files, code comments, guides |
| `/estimate` | Project estimation | Time/effort planning, complexity analysis |
| `/explain` | Educational help | Learning concepts, understanding code |
| `/git` | Git operations | Smart commits, branch management |
| `/improve` | Code enhancement | Refactoring, optimization, quality fixes |
| `/index` | Command help | Finding the right command for your task |
| `/load` | Context loading | Project analysis, codebase understanding |
| `/spawn` | Complex orchestration | Multi-step operations, workflow automation |
| `/task` | Project management | Long-term feature planning, task tracking |
| `/test` | Testing | Running tests, coverage analysis |
| `/troubleshoot` | Problem solving | Debugging, issue investigation |

## Development Commands 🔨

### `/build` - Project Building
**What it does**: Builds, compiles, and packages projects with smart error handling.

**When to use it**:
- You need to compile/bundle your project
- Build process is failing and you want help debugging
- Setting up build optimization
- Preparing for deployment

**Basic syntax**:
```bash
/build                          # Build current project
/build --type prod              # Production build
/build --clean                  # Clean build (remove old artifacts)
/build --optimize               # Enable optimizations
/build src/                     # Build specific directory
```

**Useful flags**:
- `--type dev|prod|test` - Build type
- `--clean` - Clean before building  
- `--optimize` - Enable build optimizations
- `--verbose` - Show detailed build output

**Real examples**:
```bash
/build --type prod --optimize   # Production build with optimizations
/build --clean --verbose        # Clean build with detailed output
/build src/components           # Build just the components folder
```

**Gotchas**:
- Works best with common build tools (npm, webpack, etc.)
- May struggle with very custom build setups
- Check your build tool is in PATH

---

### `/design` - System & Component Design
**What it does**: Creates system architecture, API designs, and component specifications.

**When to use it**:
- Planning new features or systems
- Need API or database design
- Creating component architecture
- Documenting system relationships

**Basic syntax**:
```bash
/design user-auth-system        # Design a user authentication system
/design --type api auth         # Design just the API part
/design --format spec payment   # Create formal specification
```

**Useful flags**:
- `--type architecture|api|component|database` - Design focus
- `--format diagram|spec|code` - Output format
- `--iterative` - Refine design through iterations

**Real examples**:
```bash
/design --type api user-management    # Design user management API
/design --format spec chat-system     # Create chat system specification
/design --type database ecommerce     # Design database schema
```

**Gotchas**:
- More conceptual than code-generating
- Output quality depends on how clearly you describe requirements
- Great for planning phase, less for implementation details

## Analysis Commands 🔍

### `/analyze` - Code Analysis
**What it does**: Comprehensive analysis of code quality, security, performance, and architecture.

**When to use it**:
- Understanding unfamiliar codebases
- Finding security vulnerabilities
- Performance bottleneck hunting
- Code quality assessment

**Basic syntax**:
```bash
/analyze src/                   # Analyze entire src directory
/analyze --focus security       # Focus on security issues
/analyze --depth deep app.js    # Deep analysis of specific file
```

**Useful flags**:
- `--focus quality|security|performance|architecture` - Analysis focus
- `--depth quick|deep` - Analysis thoroughness
- `--format text|json|report` - Output format

**Real examples**:
```bash
/analyze --focus security --depth deep     # Deep security analysis
/analyze --focus performance src/api/      # Performance analysis of API
/analyze --format report .                 # Generate analysis report
```

**Gotchas**:
- Can take a while on large codebases
- Security analysis is pretty good, performance analysis varies
- Works best with common languages (JS, Python, etc.)

---

### `/troubleshoot` - Problem Investigation
**What it does**: Systematic debugging and problem investigation.

**When to use it**:
- Something's broken and you're not sure why
- Need systematic debugging approach
- Error messages are confusing
- Performance issues investigation

**Basic syntax**:
```bash
/troubleshoot "login not working"     # Investigate login issue
/troubleshoot --logs error.log        # Analyze error logs
/troubleshoot performance             # Performance troubleshooting
```

**Useful flags**:
- `--logs <file>` - Include log file analysis
- `--systematic` - Use structured debugging approach
- `--focus network|database|frontend` - Focus area

**Real examples**:
```bash
/troubleshoot "API returning 500" --logs server.log
/troubleshoot --focus database "slow queries"
/troubleshoot "build failing" --systematic
```

**Gotchas**:
- Works better with specific error descriptions
- Include relevant error messages and logs when possible
- May suggest obvious things first (that's usually good!)

---

### `/explain` - Educational Explanations
**What it does**: Explains code, concepts, and technologies in an educational way.

**When to use it**:
- Learning new technologies or patterns
- Understanding complex code
- Need clear explanations for team members
- Documenting tricky concepts

**Basic syntax**:
```bash
/explain async/await               # Explain async/await concept
/explain --code src/utils.js       # Explain specific code file
/explain --beginner React hooks    # Beginner-friendly explanation
```

**Useful flags**:
- `--beginner` - Simpler explanations
- `--advanced` - Technical depth
- `--code <file>` - Explain specific code
- `--examples` - Include practical examples

**Real examples**:
```bash
/explain --beginner "what is REST API"
/explain --code src/auth.js --advanced
/explain --examples "React context patterns"
```

**Gotchas**:
- Great for well-known concepts, may struggle with very niche topics
- Better with specific questions than vague "explain this codebase"
- Include context about your experience level

## Quality Commands ✨

### `/improve` - Code Enhancement
**What it does**: Systematic improvements to code quality, performance, and maintainability.

**When to use it**:
- Refactoring messy code
- Performance optimization
- Applying best practices
- Modernizing old code

**Basic syntax**:
```bash
/improve src/legacy/            # Improve legacy code
/improve --type performance     # Focus on performance
/improve --safe src/utils.js    # Safe, low-risk improvements only
```

**Useful flags**:
- `--type quality|performance|maintainability|style` - Improvement focus
- `--safe` - Only apply low-risk changes
- `--preview` - Show what would be changed without doing it

**Real examples**:
```bash
/improve --type performance --safe src/api/
/improve --preview src/components/LegacyComponent.js
/improve --type style . --safe
```

**Gotchas**:
- Always use `--preview` first to see what it wants to change
- `--safe` is your friend - prevents risky refactoring
- Works best on smaller files/modules rather than entire codebases

---

### `/cleanup` - Technical Debt Reduction
**What it does**: Removes dead code, unused imports, and organizes file structure.

**When to use it**:
- Codebase feels cluttered
- Lots of unused imports/variables
- File organization is messy
- Before major refactoring

**Basic syntax**:
```bash
/cleanup src/                   # Clean up src directory
/cleanup --dead-code            # Focus on dead code removal
/cleanup --imports package.js   # Clean up imports in specific file
```

**Useful flags**:
- `--dead-code` - Remove unused code
- `--imports` - Clean up import statements
- `--files` - Reorganize file structure
- `--safe` - Conservative cleanup only

**Real examples**:
```bash
/cleanup --dead-code --safe src/utils/
/cleanup --imports src/components/
/cleanup --files . --safe
```

**Gotchas**:
- Can be aggressive - always review changes carefully
- May not catch all dead code (especially dynamic imports)
- Better to run on smaller sections than entire projects

---

### `/test` - Testing & Quality Assurance
**What it does**: Runs tests, generates coverage reports, and maintains test quality.

**When to use it**:
- Running test suites
- Checking test coverage
- Generating test reports
- Setting up continuous testing

**Basic syntax**:
```bash
/test                           # Run all tests
/test --type unit               # Run only unit tests
/test --coverage                # Generate coverage report
/test --watch src/              # Watch mode for development
```

**Useful flags**:
- `--type unit|integration|e2e|all` - Test type
- `--coverage` - Generate coverage reports
- `--watch` - Run tests in watch mode
- `--fix` - Try to fix failing tests automatically

**Real examples**:
```bash
/test --type unit --coverage
/test --watch src/components/
/test --type e2e --fix
```

**Gotchas**:
- Needs your test framework to be properly configured
- Coverage reports depend on your existing test setup
- `--fix` is experimental - review what it changes

## Documentation Commands 📝

### `/document` - Focused Documentation
**What it does**: Creates documentation for specific components, functions, or features.

**When to use it**:
- Need README files
- Writing API documentation
- Adding code comments
- Creating user guides

**Basic syntax**:
```bash
/document src/api/auth.js       # Document authentication module
/document --type api            # API documentation
/document --style brief README  # Brief README file
```

**Useful flags**:
- `--type inline|external|api|guide` - Documentation type
- `--style brief|detailed` - Level of detail
- `--template` - Use specific documentation template

**Real examples**:
```bash
/document --type api src/controllers/
/document --style detailed --type guide user-onboarding
/document --type inline src/utils/helpers.js
```

**Gotchas**:
- Better with specific files/functions than entire projects
- Quality depends on how well-structured your code is
- May need some editing to match your project's documentation style

## Project Management Commands 📊

### `/estimate` - Project Estimation
**What it does**: Estimates time, effort, and complexity for development tasks.

**When to use it**:
- Planning new features
- Sprint planning
- Understanding project complexity
- Resource allocation

**Basic syntax**:
```bash
/estimate "add user authentication"    # Estimate auth feature
/estimate --detailed shopping-cart     # Detailed breakdown
/estimate --complexity user-dashboard  # Complexity analysis
```

**Useful flags**:
- `--detailed` - Detailed breakdown of tasks
- `--complexity` - Focus on technical complexity
- `--team-size <n>` - Consider team size in estimates

**Real examples**:
```bash
/estimate --detailed "implement payment system"
/estimate --complexity --team-size 3 "migrate to microservices"
/estimate "add real-time chat" --detailed
```

**Gotchas**:
- Estimates are rough - use as starting points, not gospel
- Works better with clear, specific feature descriptions
- Consider your team's experience with the tech stack

---

### `/task` - Long-term Project Management
**What it does**: Manages complex, multi-session development tasks and features.

**When to use it**:
- Planning features that take days/weeks
- Breaking down large projects
- Tracking progress across sessions
- Coordinating team work

**Basic syntax**:
```bash
/task create "implement user dashboard"  # Create new task
/task status                            # Check task status
/task breakdown "payment integration"    # Break down into subtasks
```

**Useful flags**:
- `create` - Create new long-term task
- `status` - Check current task status
- `breakdown` - Break large task into smaller ones
- `--priority high|medium|low` - Set task priority

**Real examples**:
```bash
/task create "migrate from REST to GraphQL" --priority high
/task breakdown "e-commerce checkout flow"
/task status
```

**Gotchas**:
- Still experimental - may not persist perfectly across sessions
- Better for planning than actual project management
- Works best when you're specific about requirements

---

### `/spawn` - Complex Operation Orchestration
**What it does**: Coordinates complex, multi-step operations and workflows.

**When to use it**:
- Operations involving multiple tools/systems
- Coordinating parallel workflows
- Complex deployment processes
- Multi-stage data processing

**Basic syntax**:
```bash
/spawn deploy-pipeline          # Orchestrate deployment
/spawn --parallel migrate-data  # Parallel data migration
/spawn setup-dev-environment    # Complex environment setup
```

**Useful flags**:
- `--parallel` - Run operations in parallel when possible
- `--sequential` - Force sequential execution
- `--monitor` - Monitor operation progress

**Real examples**:
```bash
/spawn --parallel "test and deploy to staging"
/spawn setup-ci-cd --monitor
/spawn --sequential database-migration
```

**Gotchas**:
- Most complex command - expect some rough edges
- Better for well-defined workflows than ad-hoc operations
- May need multiple iterations to get right

## Version Control Commands 🔄

### `/git` - Enhanced Git Operations
**What it does**: Git operations with intelligent commit messages and workflow optimization.

**When to use it**:
- Making commits with better messages
- Branch management
- Complex git workflows
- Git troubleshooting

**Basic syntax**:
```bash
/git commit                     # Smart commit with auto-generated message
/git --smart-commit add .       # Add and commit with smart message
/git branch feature/new-auth    # Create and switch to new branch
```

**Useful flags**:
- `--smart-commit` - Generate intelligent commit messages
- `--branch-strategy` - Apply branch naming conventions
- `--interactive` - Interactive mode for complex operations

**Real examples**:
```bash
/git --smart-commit "fixed login bug"
/git branch feature/user-dashboard --branch-strategy
/git merge develop --interactive
```

**Gotchas**:
- Smart commit messages are pretty good but review them
- Assumes you're following common git workflows
- Won't fix bad git habits - just makes them easier

## Utility Commands 🔧

### `/index` - Command Navigation
**What it does**: Helps you find the right command for your task.

**When to use it**:
- Not sure which command to use
- Exploring available commands
- Learning about command capabilities

**Basic syntax**:
```bash
/index                          # List all commands
/index testing                  # Find commands related to testing
/index --category analysis      # Commands in analysis category
```

**Useful flags**:
- `--category <cat>` - Filter by command category
- `--search <term>` - Search command descriptions

**Real examples**:
```bash
/index --search "performance"
/index --category quality
/index git
```

**Gotchas**:
- Simple but useful for discovery
- Better than trying to remember all 15 commands

---

### `/load` - Project Context Loading
**What it does**: Loads and analyzes project context for better understanding.

**When to use it**:
- Starting work on unfamiliar project
- Need to understand project structure
- Before making major changes
- Onboarding team members

**Basic syntax**:
```bash
/load                           # Load current project context
/load src/                      # Load specific directory context
/load --deep                    # Deep analysis of project structure
```

**Useful flags**:
- `--deep` - Comprehensive project analysis
- `--focus <area>` - Focus on specific project area
- `--summary` - Generate project summary

**Real examples**:
```bash
/load --deep --summary
/load src/components/ --focus architecture
/load . --focus dependencies
```

**Gotchas**:
- Can take time on large projects
- More useful at project start than during development
- Helps with onboarding but not a replacement for good docs

## Command Tips & Patterns 💡

### Effective Flag Combinations
```bash
# Safe improvement workflow
/improve --preview src/component.js    # See what would change
/improve --safe src/component.js       # Apply safe changes only

# Comprehensive analysis
/analyze --focus security --depth deep
/test --coverage
/document --type api

# Smart git workflow
/git add .
/git --smart-commit --branch-strategy

# Project understanding workflow
/load --deep --summary
/analyze --focus architecture
/document --type guide
```

### Common Workflows

**New Project Onboarding**:
```bash
/load --deep --summary
/analyze --focus architecture
/test --coverage
/document README
```

**Bug Investigation**:
```bash
/troubleshoot "specific error message" --logs
/analyze --focus security
/test --type unit affected-component
```

**Code Quality Improvement**:
```bash
/analyze --focus quality
/improve --preview src/
/cleanup --safe
/test --coverage
```

**Pre-deployment Checklist**:
```bash
/test --type all --coverage
/analyze --focus security
/build --type prod --optimize
/git --smart-commit
```

### Troubleshooting Command Issues

**Command not working as expected?**
- Try adding `--help` to see all options
- Use `--preview` or `--safe` flags when available
- Start with smaller scope (single file vs. entire project)

**Analysis taking too long?**
- Use `--focus` to narrow scope
- Try `--depth quick` instead of deep analysis
- Analyze smaller directories first

**Build/test commands failing?**
- Make sure your tools are in PATH
- Check that config files are in expected locations
- Try running the underlying commands directly first

**Not sure which command to use?**
- Use `/index` to browse available commands
- Look at the Quick Reference table above
- Try the most specific command first, then broader ones

---

## Final Notes 📝

**Remember:**
- Commands work best when you're specific about what you want
- Use `--preview` and `--safe` flags liberally
- Start small (single files) before running on entire projects
- These commands enhance your workflow, they don't replace understanding your tools

**Still rough around the edges:**
- Complex orchestration (spawn, task) may not work perfectly
- Some analysis depends heavily on your project setup
- Error handling could be better in some commands

**Getting better all the time:**
- We actively improve commands based on user feedback
- Newer commands (analyze, improve) tend to work better
- Documentation and examples are constantly being updated

**Need help?** Check the GitHub issues or create a new one if you're stuck! 🚀

---

*Happy coding! We hope these commands make your development workflow a bit smoother. 🙂*