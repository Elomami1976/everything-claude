<![CDATA[#!/bin/bash

# everything-claude installer for macOS/Linux
# Usage: ./install.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "███████╗██╗   ██╗███████╗██████╗ ██╗   ██╗████████╗██╗  ██╗██╗███╗   ██╗ ██████╗ "
echo "██╔════╝██║   ██║██╔════╝██╔══██╗╚██╗ ██╔╝╚══██╔══╝██║  ██║██║████╗  ██║██╔════╝ "
echo "█████╗  ██║   ██║█████╗  ██████╔╝ ╚████╔╝    ██║   ███████║██║██╔██╗ ██║██║  ███╗"
echo "██╔══╝  ╚██╗ ██╔╝██╔══╝  ██╔══██╗  ╚██╔╝     ██║   ██╔══██║██║██║╚██╗██║██║   ██║"
echo "███████╗ ╚████╔╝ ███████╗██║  ██║   ██║      ██║   ██║  ██║██║██║ ╚████║╚██████╔╝"
echo "╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ "
echo -e "${NC}"
echo ""
echo "Agent Harness Performance Optimization Kit"
echo "==========================================="
echo ""

# Determine installation directory
CLAUDE_DIR="${HOME}/.claude"

echo -e "${YELLOW}Installing to ${CLAUDE_DIR}...${NC}"
echo ""

# Create directories
echo -e "${BLUE}Creating directories...${NC}"
mkdir -p "${CLAUDE_DIR}/rules/common"
mkdir -p "${CLAUDE_DIR}/rules/javascript"
mkdir -p "${CLAUDE_DIR}/rules/python"
mkdir -p "${CLAUDE_DIR}/rules/typescript"
mkdir -p "${CLAUDE_DIR}/skills"
mkdir -p "${CLAUDE_DIR}/commands"
mkdir -p "${CLAUDE_DIR}/agents"
mkdir -p "${CLAUDE_DIR}/hooks"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy rules
echo -e "${BLUE}Copying rules...${NC}"
cp -r "${SCRIPT_DIR}/rules/common/"* "${CLAUDE_DIR}/rules/common/" 2>/dev/null || true
cp -r "${SCRIPT_DIR}/rules/javascript/"* "${CLAUDE_DIR}/rules/javascript/" 2>/dev/null || true
cp -r "${SCRIPT_DIR}/rules/python/"* "${CLAUDE_DIR}/rules/python/" 2>/dev/null || true
cp -r "${SCRIPT_DIR}/rules/typescript/"* "${CLAUDE_DIR}/rules/typescript/" 2>/dev/null || true

# Copy skills
echo -e "${BLUE}Copying skills...${NC}"
cp -r "${SCRIPT_DIR}/skills/"* "${CLAUDE_DIR}/skills/" 2>/dev/null || true

# Copy commands
echo -e "${BLUE}Copying commands...${NC}"
cp -r "${SCRIPT_DIR}/commands/"* "${CLAUDE_DIR}/commands/" 2>/dev/null || true

# Copy agents
echo -e "${BLUE}Copying agents...${NC}"
cp -r "${SCRIPT_DIR}/agents/"* "${CLAUDE_DIR}/agents/" 2>/dev/null || true

# Copy hooks
echo -e "${BLUE}Copying hooks...${NC}"
cp -r "${SCRIPT_DIR}/hooks/"* "${CLAUDE_DIR}/hooks/" 2>/dev/null || true

echo ""
echo -e "${GREEN}✓ Installation complete!${NC}"
echo ""
echo "Files installed to: ${CLAUDE_DIR}"
echo ""
echo "Installed components:"
echo "  - Rules: $(find "${CLAUDE_DIR}/rules" -name "*.md" 2>/dev/null | wc -l | tr -d ' ') files"
echo "  - Skills: $(find "${CLAUDE_DIR}/skills" -name "*.md" 2>/dev/null | wc -l | tr -d ' ') files"
echo "  - Commands: $(find "${CLAUDE_DIR}/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ') files"
echo "  - Agents: $(find "${CLAUDE_DIR}/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ') files"
echo "  - Hooks: $(find "${CLAUDE_DIR}/hooks" -name "*.json" 2>/dev/null | wc -l | tr -d ' ') files"
echo ""
echo -e "${YELLOW}Quick Start:${NC}"
echo "  /build <description>  - Generate build prompt"
echo "  /review <file>        - Review code"
echo "  /ship                 - Pre-launch checklist"
echo "  /launch               - Product Hunt kit"
echo ""
echo -e "${GREEN}Happy shipping! 🚀${NC}"
]]>