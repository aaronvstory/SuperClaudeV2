#!/usr/bin/env python3
"""
SuperClaude Framework Management Hub
Unified entry point for all SuperClaude operations

This is the main command-line interface for the SuperClaude framework,
providing a unified hub for installation, updates, backups, and management.

Usage:
    SuperClaude.py install [options]    # Install framework
    SuperClaude.py update [options]     # Update framework  
    SuperClaude.py uninstall [options]  # Uninstall framework
    SuperClaude.py backup [options]     # Backup/restore operations
    SuperClaude.py --help               # Show all available operations
"""

import sys
import argparse
import time
from pathlib import Path
from typing import Dict, Callable, Optional

# Add setup directory to Python path
setup_dir = Path(__file__).parent / "setup"
sys.path.insert(0, str(setup_dir))

from setup.utils.ui import (
    display_header, display_info, display_success, display_error, 
    display_warning, Colors
)
from setup.utils.logger import setup_logging, get_logger, LogLevel
from setup import DEFAULT_INSTALL_DIR


def create_global_parser() -> argparse.ArgumentParser:
    """Create parent parser with global arguments"""
    global_parser = argparse.ArgumentParser(add_help=False)
    
    # Global options available to all operations
    global_parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Enable verbose output (debug level logging)"
    )
    
    global_parser.add_argument(
        "--quiet", "-q", 
        action="store_true",
        help="Quiet mode - only show errors"
    )
    
    global_parser.add_argument(
        "--install-dir",
        type=Path,
        default=DEFAULT_INSTALL_DIR,
        help=f"Installation directory (default: {DEFAULT_INSTALL_DIR})"
    )
    
    global_parser.add_argument(
        "--dry-run",
        action="store_true", 
        help="Simulate operation without making changes"
    )
    
    global_parser.add_argument(
        "--force",
        action="store_true",
        help="Force operation, skip confirmations and checks"
    )
    
    global_parser.add_argument(
        "--yes", "-y",
        action="store_true",
        help="Automatically answer yes to all prompts"
    )
    
    return global_parser


def create_parser() -> argparse.ArgumentParser:
    """Create the main argument parser with subcommands"""
    # Create global parser for shared arguments
    global_parser = create_global_parser()
    
    parser = argparse.ArgumentParser(
        prog="SuperClaude",
        description="SuperClaude Framework Management Hub - Unified CLI for all operations",
        epilog="""
Examples:
  SuperClaude.py install --quick --dry-run    # Quick installation (dry-run)
  SuperClaude.py install --profile developer  # Developer profile
  SuperClaude.py backup --create              # Create backup
  SuperClaude.py update --verbose             # Update with verbose output
  SuperClaude.py uninstall --force            # Force removal
  
Global options can be used with any operation:
  --verbose, --quiet, --dry-run, --force, --yes, --install-dir

Use 'SuperClaude.py <operation> --help' for operation-specific options.
        """,
        formatter_class=argparse.RawDescriptionHelpFormatter,
        parents=[global_parser]
    )
    
    parser.add_argument(
        "--version",
        action="version",
        version="SuperClaude v3.0.0"
    )
    
    # Create subparsers for operations
    subparsers = parser.add_subparsers(
        dest="operation",
        title="Available operations",
        description="SuperClaude framework management operations",
        help="Operation to perform"
    )
    
    # Register operation parsers (will be populated by operation modules)
    # This design allows each operation to define its own CLI interface
    return parser, subparsers, global_parser


def setup_global_environment(args: argparse.Namespace) -> None:
    """Setup global environment configuration shared by all operations"""
    # Determine log level from global flags
    if args.quiet:
        console_level = LogLevel.ERROR
    elif args.verbose:
        console_level = LogLevel.DEBUG
    else:
        console_level = LogLevel.INFO
    
    # Setup logging system
    log_dir = args.install_dir / "logs" if not args.dry_run else None
    setup_logging(
        name="superclaude_hub",
        log_dir=log_dir,
        console_level=console_level
    )
    
    # Log the operation being performed
    logger = get_logger()
    logger.debug(f"SuperClaude.py called with operation: {args.operation}")
    logger.debug(f"Global options: verbose={args.verbose}, quiet={args.quiet}, "
                f"install_dir={args.install_dir}, dry_run={args.dry_run}, force={args.force}")


def get_operation_modules() -> Dict[str, str]:
    """Get available operation modules and their descriptions"""
    return {
        "install": "Install SuperClaude framework components",
        "update": "Update existing SuperClaude installation", 
        "uninstall": "Remove SuperClaude framework installation",
        "backup": "Backup and restore SuperClaude installations"
    }


def load_operation_module(operation_name: str):
    """Dynamically load an operation module"""
    try:
        module_path = f"setup.operations.{operation_name}"
        module = __import__(module_path, fromlist=[operation_name])
        return module
    except ImportError as e:
        logger = get_logger()
        logger.error(f"Could not load operation module '{operation_name}': {e}")
        return None


def register_operation_parsers(subparsers, global_parser) -> Dict[str, Callable]:
    """Register all operation parsers and return operation functions"""
    operations = {}
    operation_modules = get_operation_modules()
    
    for operation_name, description in operation_modules.items():
        try:
            # Try to load the operation module
            module = load_operation_module(operation_name)
            
            if module and hasattr(module, 'register_parser') and hasattr(module, 'run'):
                # Register the parser for this operation with global parser inheritance
                module.register_parser(subparsers, global_parser)
                operations[operation_name] = module.run
            else:
                # Create placeholder parser for operations not yet implemented
                parser = subparsers.add_parser(
                    operation_name,
                    help=f"{description} (not yet implemented in unified CLI)",
                    parents=[global_parser]
                )
                parser.add_argument(
                    "--legacy",
                    action="store_true",
                    help=f"Use legacy {operation_name}.py script"
                )
                operations[operation_name] = None
                
        except Exception as e:
            logger = get_logger()
            logger.warning(f"Could not register operation '{operation_name}': {e}")
    
    return operations


def handle_legacy_fallback(operation_name: str, args: argparse.Namespace) -> int:
    """Handle fallback to legacy scripts when operation module not available"""
    legacy_script = Path(__file__).parent / f"{operation_name}.py"
    
    if legacy_script.exists():
        logger = get_logger()
        logger.info(f"Falling back to legacy script: {legacy_script}")
        
        # Build command to execute legacy script
        import subprocess
        cmd = [sys.executable, str(legacy_script)]
        
        # Convert unified args back to legacy format
        for arg, value in vars(args).items():
            if arg in ['operation', 'install_dir'] or value in [False, None]:
                continue
            if value is True:
                cmd.append(f"--{arg.replace('_', '-')}")
            else:
                cmd.extend([f"--{arg.replace('_', '-')}", str(value)])
        
        try:
            return subprocess.call(cmd)
        except Exception as e:
            logger.error(f"Failed to execute legacy script: {e}")
            return 1
    else:
        logger = get_logger()
        logger.error(f"Operation '{operation_name}' not implemented and no legacy script found")
        return 1


def main() -> int:
    """Main entry point for SuperClaude CLI hub"""
    try:
        # Create parser and subparsers
        parser, subparsers, global_parser = create_parser()
        
        # Register operation parsers
        operations = register_operation_parsers(subparsers, global_parser)
        
        # Parse arguments
        args = parser.parse_args()
        
        # Show help if no operation specified
        if not args.operation:
            if not args.quiet:
                display_header(
                    "SuperClaude Framework Management Hub v3.0",
                    "Unified CLI for all SuperClaude operations"
                )
                print(f"\n{Colors.CYAN}Available operations:{Colors.RESET}")
                for op_name, op_desc in get_operation_modules().items():
                    print(f"  {op_name:<12} {op_desc}")
                print(f"\nUse 'SuperClaude.py <operation> --help' for operation-specific options.")
                print(f"Use 'SuperClaude.py --help' for global options.")
            return 0
        
        # Setup global environment
        setup_global_environment(args)
        logger = get_logger()
        
        # Execute the requested operation
        if args.operation in operations and operations[args.operation]:
            # Operation module is available
            logger.info(f"Executing operation: {args.operation}")
            return operations[args.operation](args)
        else:
            # Fall back to legacy script
            logger.warning(f"Operation module for '{args.operation}' not available, trying legacy fallback")
            return handle_legacy_fallback(args.operation, args)
            
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}Operation cancelled by user{Colors.RESET}")
        return 130
    except Exception as e:
        try:
            logger = get_logger()
            logger.exception(f"Unexpected error in SuperClaude hub: {e}")
        except:
            print(f"{Colors.RED}[ERROR] Unexpected error: {e}{Colors.RESET}")
        return 1


if __name__ == "__main__":
    sys.exit(main())