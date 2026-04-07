<![CDATA[# everything-claude installer for Windows
# Usage: .\install.ps1

$ErrorActionPreference = "Stop"

Write-Host @"
███████╗██╗   ██╗███████╗██████╗ ██╗   ██╗████████╗██╗  ██╗██╗███╗   ██╗ ██████╗ 
██╔════╝██║   ██║██╔════╝██╔══██╗╚██╗ ██╔╝╚══██╔══╝██║  ██║██║████╗  ██║██╔════╝ 
█████╗  ██║   ██║█████╗  ██████╔╝ ╚████╔╝    ██║   ███████║██║██╔██╗ ██║██║  ███╗
██╔══╝  ╚██╗ ██╔╝██╔══╝  ██╔══██╗  ╚██╔╝     ██║   ██╔══██║██║██║╚██╗██║██║   ██║
███████╗ ╚████╔╝ ███████╗██║  ██║   ██║      ██║   ██║  ██║██║██║ ╚████║╚██████╔╝
╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
"@ -ForegroundColor Blue

Write-Host ""
Write-Host "Agent Harness Performance Optimization Kit" -ForegroundColor White
Write-Host "===========================================" -ForegroundColor White
Write-Host ""

# Determine installation directory
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"

Write-Host "Installing to $ClaudeDir..." -ForegroundColor Yellow
Write-Host ""

# Create directories
Write-Host "Creating directories..." -ForegroundColor Cyan
$directories = @(
    "rules\common",
    "rules\javascript",
    "rules\python",
    "rules\typescript",
    "skills",
    "commands",
    "agents",
    "hooks"
)

foreach ($dir in $directories) {
    $fullPath = Join-Path $ClaudeDir $dir
    if (-not (Test-Path $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
    }
}

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Copy function
function Copy-Files {
    param (
        [string]$Source,
        [string]$Destination
    )
    
    if (Test-Path $Source) {
        $files = Get-ChildItem -Path $Source -File
        foreach ($file in $files) {
            Copy-Item -Path $file.FullName -Destination $Destination -Force
        }
    }
}

# Copy rules
Write-Host "Copying rules..." -ForegroundColor Cyan
Copy-Files -Source (Join-Path $ScriptDir "rules\common") -Destination (Join-Path $ClaudeDir "rules\common")
Copy-Files -Source (Join-Path $ScriptDir "rules\javascript") -Destination (Join-Path $ClaudeDir "rules\javascript")
Copy-Files -Source (Join-Path $ScriptDir "rules\python") -Destination (Join-Path $ClaudeDir "rules\python")
Copy-Files -Source (Join-Path $ScriptDir "rules\typescript") -Destination (Join-Path $ClaudeDir "rules\typescript")

# Copy skills
Write-Host "Copying skills..." -ForegroundColor Cyan
Copy-Files -Source (Join-Path $ScriptDir "skills") -Destination (Join-Path $ClaudeDir "skills")

# Copy commands
Write-Host "Copying commands..." -ForegroundColor Cyan
Copy-Files -Source (Join-Path $ScriptDir "commands") -Destination (Join-Path $ClaudeDir "commands")

# Copy agents
Write-Host "Copying agents..." -ForegroundColor Cyan
Copy-Files -Source (Join-Path $ScriptDir "agents") -Destination (Join-Path $ClaudeDir "agents")

# Copy hooks
Write-Host "Copying hooks..." -ForegroundColor Cyan
Copy-Files -Source (Join-Path $ScriptDir "hooks") -Destination (Join-Path $ClaudeDir "hooks")

# Count installed files
$rulesCount = (Get-ChildItem -Path (Join-Path $ClaudeDir "rules") -Recurse -Filter "*.md" -ErrorAction SilentlyContinue | Measure-Object).Count
$skillsCount = (Get-ChildItem -Path (Join-Path $ClaudeDir "skills") -Filter "*.md" -ErrorAction SilentlyContinue | Measure-Object).Count
$commandsCount = (Get-ChildItem -Path (Join-Path $ClaudeDir "commands") -Filter "*.md" -ErrorAction SilentlyContinue | Measure-Object).Count
$agentsCount = (Get-ChildItem -Path (Join-Path $ClaudeDir "agents") -Filter "*.md" -ErrorAction SilentlyContinue | Measure-Object).Count
$hooksCount = (Get-ChildItem -Path (Join-Path $ClaudeDir "hooks") -Filter "*.json" -ErrorAction SilentlyContinue | Measure-Object).Count

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Files installed to: $ClaudeDir" -ForegroundColor White
Write-Host ""
Write-Host "Installed components:" -ForegroundColor White
Write-Host "  - Rules: $rulesCount files" -ForegroundColor White
Write-Host "  - Skills: $skillsCount files" -ForegroundColor White
Write-Host "  - Commands: $commandsCount files" -ForegroundColor White
Write-Host "  - Agents: $agentsCount files" -ForegroundColor White
Write-Host "  - Hooks: $hooksCount files" -ForegroundColor White
Write-Host ""
Write-Host "Quick Start:" -ForegroundColor Yellow
Write-Host "  /build <description>  - Generate build prompt" -ForegroundColor White
Write-Host "  /review <file>        - Review code" -ForegroundColor White
Write-Host "  /ship                 - Pre-launch checklist" -ForegroundColor White
Write-Host "  /launch               - Product Hunt kit" -ForegroundColor White
Write-Host ""
Write-Host "Happy shipping!" -ForegroundColor Green
]]>