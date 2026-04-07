<![CDATA[# Python Scripts Rules

Best practices for Python CLI tools and automation scripts.

## 1. Script Structure

**Standard script layout:**

```python
#!/usr/bin/env python3
"""
Script description: What this script does and why.

Usage:
    python script.py <input_file> --output <output_file>
    python script.py --help
"""

import argparse
import logging
import sys
from pathlib import Path

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument('input', type=Path, help='Input file path')
    parser.add_argument('-o', '--output', type=Path, help='Output file path')
    parser.add_argument('-v', '--verbose', action='store_true', help='Verbose output')
    parser.add_argument('--dry-run', action='store_true', help='Dry run mode')
    return parser.parse_args()


def main():
    """Main entry point."""
    args = parse_args()
    
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    
    try:
        process(args.input, args.output, dry_run=args.dry_run)
        logger.info("Completed successfully")
    except FileNotFoundError as e:
        logger.error(f"File not found: {e}")
        sys.exit(1)
    except Exception as e:
        logger.exception(f"Unexpected error: {e}")
        sys.exit(1)


def process(input_path: Path, output_path: Path = None, dry_run: bool = False):
    """Main processing logic."""
    logger.info(f"Processing {input_path}")
    
    if not input_path.exists():
        raise FileNotFoundError(input_path)
    
    # Your logic here
    content = input_path.read_text()
    result = transform(content)
    
    if dry_run:
        logger.info("Dry run - no changes made")
        print(result)
        return
    
    output = output_path or input_path.with_suffix('.out')
    output.write_text(result)
    logger.info(f"Output written to {output}")


def transform(content: str) -> str:
    """Transform content."""
    return content.upper()


if __name__ == '__main__':
    main()
```

---

## 2. Argument Parsing

**Use argparse for complex scripts:**

```python
import argparse

def create_parser():
    parser = argparse.ArgumentParser(
        prog='mytool',
        description='Tool description',
        epilog='Examples:\n  %(prog)s file.txt --format json'
    )
    
    # Positional arguments
    parser.add_argument('file', type=Path)
    
    # Optional arguments
    parser.add_argument('-f', '--format', choices=['json', 'csv', 'yaml'], default='json')
    parser.add_argument('-o', '--output', type=Path)
    parser.add_argument('-n', '--count', type=int, default=10)
    parser.add_argument('-v', '--verbose', action='count', default=0)  # -v, -vv, -vvv
    parser.add_argument('--debug', action='store_true')
    
    # Mutually exclusive options
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--fast', action='store_true')
    group.add_argument('--thorough', action='store_true')
    
    # Subcommands
    subparsers = parser.add_subparsers(dest='command', required=True)
    
    # Init subcommand
    init_parser = subparsers.add_parser('init', help='Initialize project')
    init_parser.add_argument('--force', action='store_true')
    
    # Run subcommand
    run_parser = subparsers.add_parser('run', help='Run process')
    run_parser.add_argument('--workers', type=int, default=4)
    
    return parser

args = create_parser().parse_args()
```

**For simple scripts, use click:**
```python
import click

@click.command()
@click.argument('input_file', type=click.Path(exists=True))
@click.option('-o', '--output', type=click.Path())
@click.option('-v', '--verbose', is_flag=True)
def main(input_file, output, verbose):
    """Process INPUT_FILE and optionally save to OUTPUT."""
    click.echo(f'Processing {input_file}')
```

---

## 3. Error Handling & Exit Codes

**Use proper exit codes:**

```python
import sys

EXIT_SUCCESS = 0
EXIT_ERROR = 1
EXIT_USAGE = 2

def main():
    try:
        result = run()
        sys.exit(EXIT_SUCCESS if result else EXIT_ERROR)
    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(EXIT_USAGE)
    except KeyboardInterrupt:
        print("\nCancelled by user", file=sys.stderr)
        sys.exit(130)  # Convention for Ctrl+C
    except Exception as e:
        print(f"Unexpected error: {e}", file=sys.stderr)
        sys.exit(EXIT_ERROR)
```

---

## 4. Configuration

**Support multiple config sources:**

```python
import os
from pathlib import Path
from dataclasses import dataclass
from dotenv import load_dotenv
import json

@dataclass
class Config:
    api_key: str
    base_url: str = "https://api.example.com"
    timeout: int = 30
    debug: bool = False
    
    @classmethod
    def load(cls):
        """Load config from env vars, config file, then defaults."""
        # Load .env file if present
        load_dotenv()
        
        # Check for config file
        config_file = Path.home() / ".config" / "mytool" / "config.json"
        file_config = {}
        if config_file.exists():
            file_config = json.loads(config_file.read_text())
        
        # Priority: env > file > defaults
        return cls(
            api_key=os.getenv("API_KEY") or file_config.get("api_key") or "",
            base_url=os.getenv("BASE_URL") or file_config.get("base_url", cls.base_url),
            timeout=int(os.getenv("TIMEOUT") or file_config.get("timeout", cls.timeout)),
            debug=os.getenv("DEBUG", "").lower() == "true" or file_config.get("debug", cls.debug),
        )
```

---

## 5. Progress Indicators

**For long-running operations:**

```python
from tqdm import tqdm
import time

# Simple progress bar
for item in tqdm(items, desc="Processing"):
    process(item)

# With custom updates
with tqdm(total=100, desc="Downloading") as pbar:
    for chunk in download_chunks():
        save_chunk(chunk)
        pbar.update(len(chunk))

# Without tqdm (basic)
total = len(items)
for i, item in enumerate(items, 1):
    process(item)
    print(f"\rProcessing: {i}/{total}", end="", flush=True)
print()  # Newline after completion
```

---

## 6. File Operations

**Safe file handling:**

```python
from pathlib import Path
import tempfile
import shutil

def safe_write(filepath: Path, content: str):
    """Write to file atomically."""
    filepath = Path(filepath)
    
    # Write to temp file first
    with tempfile.NamedTemporaryFile(
        mode='w',
        dir=filepath.parent,
        delete=False
    ) as tmp:
        tmp.write(content)
        tmp_path = Path(tmp.name)
    
    # Atomic rename
    tmp_path.replace(filepath)

def process_files(input_dir: Path, output_dir: Path):
    """Process all files in directory."""
    output_dir.mkdir(parents=True, exist_ok=True)
    
    for input_file in input_dir.glob("*.txt"):
        output_file = output_dir / input_file.name
        content = input_file.read_text()
        result = transform(content)
        output_file.write_text(result)

def backup_file(filepath: Path) -> Path:
    """Create backup of file."""
    backup_path = filepath.with_suffix(f"{filepath.suffix}.bak")
    shutil.copy2(filepath, backup_path)
    return backup_path
```

---

## 7. Subprocess Execution

**Running external commands:**

```python
import subprocess

def run_command(cmd: list[str], capture: bool = True) -> subprocess.CompletedProcess:
    """Run command and return result."""
    result = subprocess.run(
        cmd,
        capture_output=capture,
        text=True,
        check=False  # Don't raise on non-zero exit
    )
    
    if result.returncode != 0:
        logger.error(f"Command failed: {' '.join(cmd)}")
        logger.error(f"stderr: {result.stderr}")
        raise subprocess.CalledProcessError(
            result.returncode, cmd, result.stdout, result.stderr
        )
    
    return result

# Execute
result = run_command(["git", "status", "--porcelain"])
print(result.stdout)

# With timeout
result = subprocess.run(
    ["long-running-command"],
    timeout=30,
    capture_output=True
)

# Streaming output
process = subprocess.Popen(
    ["tail", "-f", "logfile.log"],
    stdout=subprocess.PIPE,
    text=True
)
for line in process.stdout:
    print(line, end="")
```

---

## 8. Testing Scripts

**Make scripts testable:**

```python
# script.py
def process_data(data: str) -> str:
    """Pure function - easy to test."""
    return data.upper()

def main(args):
    """Main logic - takes parsed args."""
    content = args.input.read_text()
    result = process_data(content)
    if args.output:
        args.output.write_text(result)
    else:
        print(result)

if __name__ == '__main__':
    args = parse_args()
    main(args)

# test_script.py
import pytest
from script import process_data

def test_process_data():
    assert process_data("hello") == "HELLO"

def test_main(tmp_path):
    input_file = tmp_path / "input.txt"
    input_file.write_text("test")
    output_file = tmp_path / "output.txt"
    
    from argparse import Namespace
    args = Namespace(input=input_file, output=output_file)
    main(args)
    
    assert output_file.read_text() == "TEST"
```

---

## Script Checklist

- [ ] Proper shebang: `#!/usr/bin/env python3`
- [ ] Docstring at top explaining usage
- [ ] argparse or click for arguments
- [ ] Proper exit codes (0 success, 1+ errors)
- [ ] Logging instead of print (for errors/debug)
- [ ] Configuration from env/file
- [ ] Progress indicators for long operations
- [ ] Graceful handling of Ctrl+C
- [ ] `if __name__ == '__main__'` guard
]]>