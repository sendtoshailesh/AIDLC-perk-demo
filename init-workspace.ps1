# Workshop Workspace Initialisation Script
# Run this once before the workshop starts.
# Usage: .\init-workspace.ps1

Write-Host "Initialising workshop workspace..."

$folders = @(
    "docs\requirements",
    "docs\design",
    "docs\reports",
    "docs\test-reports",
    "issues",
    "src",
    "e2e"
)

foreach ($folder in $folders) {
    New-Item -ItemType Directory -Force -Path $folder | Out-Null
}

Write-Host "Workspace folders created:"
foreach ($folder in $folders) {
    Write-Host "  $folder"
}

Write-Host ""
Write-Host "Next step: Fill in workshop-stack.md with your tech stack configuration."
Write-Host "Then open VS Code and invoke @brd-agent to begin."
