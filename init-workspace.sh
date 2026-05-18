#!/bin/bash
# Workshop Workspace Initialisation Script
# Run this once before the workshop starts.
# Usage: bash init-workspace.sh

echo "Initialising workshop workspace..."

mkdir -p docs/requirements
mkdir -p docs/design
mkdir -p docs/reports
mkdir -p docs/test-reports
mkdir -p issues
mkdir -p src
mkdir -p e2e

echo "Workspace folders created:"
echo "  docs/requirements/"
echo "  docs/design/"
echo "  docs/reports/"
echo "  docs/test-reports/"
echo "  issues/"
echo "  src/"
echo "  e2e/"
echo ""
echo "Next step: Fill in workshop-stack.md with your tech stack configuration."
echo "Then open VS Code and invoke @brd-agent to begin."
