# Script to run Flutter apps from each vk/* branch
# Each execution will have the branch name for identification

param(
    [string]$RepoPath = ".\palestra-app"
)

# Colors for output
$SuccessColor = "Green"
$ErrorColor = "Red"
$InfoColor = "Cyan"

Write-Host "==================================" -ForegroundColor $InfoColor
Write-Host "Flutter Multi-Branch Test Runner" -ForegroundColor $InfoColor
Write-Host "==================================" -ForegroundColor $InfoColor
Write-Host ""

# Change to repository directory
Set-Location $RepoPath

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

# Process each branch
foreach ($branch in $vkBranches) {
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host "Processing branch: $branch" -ForegroundColor $SuccessColor
    Write-Host "========================================" -ForegroundColor $InfoColor
    
    # Checkout the branch
    Write-Host "Checking out branch '$branch'..." -ForegroundColor $InfoColor
    git checkout $branch
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to checkout branch '$branch'. Skipping..." -ForegroundColor $ErrorColor
        continue
    }
    
    # Pull latest changes
    Write-Host "Pulling latest changes..." -ForegroundColor $InfoColor
    git pull origin $branch
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to pull branch '$branch'. Continuing anyway..." -ForegroundColor $ErrorColor
    }
    
    # Get Flutter dependencies
    Write-Host "Getting Flutter dependencies..." -ForegroundColor $InfoColor
    flutter pub get
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to get dependencies for branch '$branch'. Skipping..." -ForegroundColor $ErrorColor
        continue
    }
    
    # Run the app with branch name as app-id suffix
    Write-Host "Running Flutter app for branch: $branch" -ForegroundColor $SuccessColor
    Write-Host "App will be identified as: palestra-app-$($branch -replace '/', '-')" -ForegroundColor $SuccessColor
    Write-Host ""
    
    # Build and run in debug mode with custom flavor/app-id
    # Using --dart-define to pass the branch name to the app
    Write-Host "Starting app... (Press Ctrl+C when you want to stop this instance)" -ForegroundColor $InfoColor
    Write-Host "Branch identifier: $branch" -ForegroundColor $SuccessColor
    Write-Host ""
    
    # Run the app with the branch name passed as a define
    flutter run --dart-define=BRANCH_NAME=$branch
    
    Write-Host ""
    Write-Host "Finished testing branch: $branch" -ForegroundColor $SuccessColor
    Write-Host ""
    
    # Ask if user wants to continue to next branch
    $continue = Read-Host "Do you want to test the next branch? (Y/N)"
    if ($continue -notmatch "^[Yy]") {
        Write-Host "Stopping test runner." -ForegroundColor $InfoColor
        break
    }
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host "All branch testing completed!" -ForegroundColor $SuccessColor
Write-Host "========================================" -ForegroundColor $InfoColor
