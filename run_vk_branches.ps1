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
    
    # Get commit information
    $commitHash = git rev-parse --short HEAD
    $commitMessage = (git log -1 --pretty=%B) -replace '"', '\"' -replace "`n", " " -replace "`r", ""
    $commitMessage = $commitMessage.Substring(0, [Math]::Min($commitMessage.Length, 500))
    $commitAuthor = git log -1 --pretty=%an
    $commitDate = git log -1 --pretty=%ad --date=format:'%Y-%m-%d %H:%M'
    
    # Display commit info
    Write-Host "Commit Info:" -ForegroundColor $InfoColor
    Write-Host "  Hash: $commitHash" -ForegroundColor Gray
    Write-Host "  Message: $commitMessage" -ForegroundColor Gray
    Write-Host "  Author: $commitAuthor" -ForegroundColor Gray
    Write-Host "  Date: $commitDate" -ForegroundColor Gray
    Write-Host ""
    
    # Run the app with branch name and commit info
    Write-Host "Starting app... (Press Ctrl+C when you want to stop this instance)" -ForegroundColor $InfoColor
    Write-Host ""
    
    # Run the app with the branch name and commit info passed as defines
    flutter run `
        --dart-define=BRANCH_NAME=$branch `
        --dart-define=COMMIT_HASH=$commitHash `
        --dart-define=COMMIT_MESSAGE=$commitMessage `
        --dart-define=COMMIT_AUTHOR=$commitAuthor `
        --dart-define=COMMIT_DATE=$commitDate
    
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
