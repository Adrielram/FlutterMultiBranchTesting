# Script to run Flutter apps from each vk/* branch in PARALLEL
# Each execution will have the branch name for identification
# Each branch will run in a separate PowerShell window

param(
    [string]$RepoPath = ".\palestra-app"
)

# Colors for output
$SuccessColor = "Green"
$ErrorColor = "Red"
$InfoColor = "Cyan"

Write-Host "==================================================" -ForegroundColor $InfoColor
Write-Host "Flutter Multi-Branch PARALLEL Test Runner" -ForegroundColor $InfoColor
Write-Host "==================================================" -ForegroundColor $InfoColor
Write-Host ""

# Get absolute path
$AbsoluteRepoPath = (Resolve-Path $RepoPath).Path
Write-Host "Repository path: $AbsoluteRepoPath" -ForegroundColor $InfoColor

# Change to repository directory
Set-Location $AbsoluteRepoPath

# Get all remote branches starting with vk/
Write-Host "Fetching remote branches..." -ForegroundColor $InfoColor
git fetch --all

$vkBranches = git branch -r | Select-String "origin/vk/" | ForEach-Object {
    $_.ToString().Trim() -replace "origin/", ""
}

if ($vkBranches.Count -eq 0) {
    Write-Host "No branches starting with 'vk/' found." -ForegroundColor $ErrorColor
    exit 1
}

Write-Host "Found $($vkBranches.Count) branch(es) starting with 'vk/':" -ForegroundColor $SuccessColor
$vkBranches | ForEach-Object { Write-Host "  - $_" -ForegroundColor $InfoColor }
Write-Host ""

# Create a temporary directory for each branch
$TempBaseDir = "$env:TEMP\flutter_branch_testing"
if (Test-Path $TempBaseDir) {
    Write-Host "Cleaning up previous test directories..." -ForegroundColor $InfoColor
    Remove-Item $TempBaseDir -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "Starting parallel execution of all branches..." -ForegroundColor $SuccessColor
Write-Host "Each branch will open in a separate window." -ForegroundColor $InfoColor
Write-Host ""

# Process each branch in parallel
foreach ($branch in $vkBranches) {
    $branchSafe = $branch -replace '/', '-'
    $branchDir = "$TempBaseDir\$branchSafe"
    
    Write-Host "Preparing to launch branch: $branch" -ForegroundColor $SuccessColor
    
    # Create the script that will run in the new window
    $scriptContent = @"
`$ErrorActionPreference = 'Continue'
`$Host.UI.RawUI.WindowTitle = "Flutter App - Branch: $branch"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "BRANCH: $branch" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Clone repository to separate directory
Write-Host "Cloning repository for branch $branch..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "$branchDir" | Out-Null
Set-Location "$branchDir"
git clone $AbsoluteRepoPath .

if (`$LASTEXITCODE -ne 0) {
    Write-Host "Failed to clone repository. Press any key to exit..." -ForegroundColor Red
    `$null = `$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit 1
}

# Checkout the specific branch
Write-Host "Checking out branch '$branch'..." -ForegroundColor Yellow
git checkout $branch

if (`$LASTEXITCODE -ne 0) {
    Write-Host "Failed to checkout branch. Press any key to exit..." -ForegroundColor Red
    `$null = `$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit 1
}

# Pull latest changes
Write-Host "Pulling latest changes..." -ForegroundColor Yellow
git pull origin $branch

# Get Flutter dependencies
Write-Host "Getting Flutter dependencies..." -ForegroundColor Yellow
flutter pub get

if (`$LASTEXITCODE -ne 0) {
    Write-Host "Failed to get dependencies. Press any key to exit..." -ForegroundColor Red
    `$null = `$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "STARTING APP FOR BRANCH: $branch" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Run the app with branch name identification
flutter run --dart-define=BRANCH_NAME=$branch

Write-Host ""
Write-Host "App stopped. Press any key to close this window..." -ForegroundColor Yellow
`$null = `$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
"@

    # Save the script to a temporary file
    $scriptFile = "$env:TEMP\run_branch_$branchSafe.ps1"
    $scriptContent | Out-File -FilePath $scriptFile -Encoding UTF8
    
    # Launch in a new PowerShell window
    Start-Process powershell.exe -ArgumentList "-NoExit", "-ExecutionPolicy", "Bypass", "-File", "$scriptFile"
    
    Write-Host "  ✓ Launched window for: $branch" -ForegroundColor $SuccessColor
    
    # Small delay to avoid overwhelming the system
    Start-Sleep -Seconds 2
}

Write-Host ""
Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host "All branches launched successfully!" -ForegroundColor $SuccessColor
Write-Host "Check the individual windows for each branch." -ForegroundColor $InfoColor
Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host ""
Write-Host "Note: Each branch is running in its own directory:" -ForegroundColor $InfoColor
Write-Host "  $TempBaseDir" -ForegroundColor $InfoColor
Write-Host ""
Write-Host "Close the individual windows to stop each app." -ForegroundColor $InfoColor
