# Script de Verificacion de Requisitos
# Verifica que todo este configurado correctamente antes de ejecutar los tests

$Host.UI.RawUI.WindowTitle = "System Requirements Checker"

# Colores
$SuccessColor = "Green"
$ErrorColor = "Red"
$WarningColor = "Yellow"
$InfoColor = "Cyan"

$allGood = $true

function Test-Command {
    param([string]$Command)
    try {
        $null = Get-Command $Command -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

function Write-CheckResult {
    param(
        [string]$Name,
        [bool]$Result,
        [string]$SuccessMessage,
        [string]$ErrorMessage,
        [string]$FixSuggestion
    )
    
    Write-Host -NoNewline "  [" 
    if ($Result) {
        Write-Host -NoNewline "OK" -ForegroundColor $SuccessColor
        Write-Host -NoNewline "] "
        Write-Host "$Name " -NoNewline
        Write-Host "- $SuccessMessage" -ForegroundColor $SuccessColor
    } else {
        Write-Host -NoNewline "!!" -ForegroundColor $ErrorColor
        Write-Host -NoNewline "] "
        Write-Host "$Name " -NoNewline -ForegroundColor $ErrorColor
        Write-Host "- $ErrorMessage" -ForegroundColor $ErrorColor
        if ($FixSuggestion) {
            Write-Host "      Fix: $FixSuggestion" -ForegroundColor $WarningColor
        }
        $script:allGood = $false
    }
}

Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host "  Flutter Multi-Branch Testing" -ForegroundColor $InfoColor
Write-Host "  System Requirements Checker" -ForegroundColor $InfoColor
Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host ""

# 1. PowerShell Version
Write-Host "1. Checking PowerShell..." -ForegroundColor $InfoColor
$psVersion = $PSVersionTable.PSVersion
$psVersionOk = $psVersion.Major -ge 5
Write-CheckResult -Name "PowerShell Version" -Result $psVersionOk `
    -SuccessMessage "Version $($psVersion.Major).$($psVersion.Minor)" `
    -ErrorMessage "Version $($psVersion.Major).$($psVersion.Minor) (requires 5.1+)" `
    -FixSuggestion "Update PowerShell from Microsoft"

# 2. Execution Policy
$execPolicy = Get-ExecutionPolicy
$execPolicyOk = $execPolicy -ne "Restricted"
Write-CheckResult -Name "Execution Policy" -Result $execPolicyOk `
    -SuccessMessage "$execPolicy" `
    -ErrorMessage "$execPolicy (too restrictive)" `
    -FixSuggestion "Run: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"

Write-Host ""

# 3. Git
Write-Host "2. Checking Git..." -ForegroundColor $InfoColor
$gitInstalled = Test-Command "git"
if ($gitInstalled) {
    $gitVersion = (git --version) -replace "git version ", ""
    Write-CheckResult -Name "Git Installed" -Result $true `
        -SuccessMessage "Version $gitVersion" `
        -ErrorMessage "" `
        -FixSuggestion ""
} else {
    Write-CheckResult -Name "Git Installed" -Result $false `
        -SuccessMessage "" `
        -ErrorMessage "Not found" `
        -FixSuggestion "Install from: https://git-scm.com/download/win"
}

Write-Host ""

# 4. Flutter
Write-Host "3. Checking Flutter..." -ForegroundColor $InfoColor
$flutterInstalled = Test-Command "flutter"
if ($flutterInstalled) {
    try {
        $flutterVersionOutput = flutter --version 2>&1 | Out-String
        $flutterVersionLine = ($flutterVersionOutput -split "`n" | Select-String "Flutter" | Select-Object -First 1).ToString()
        Write-CheckResult -Name "Flutter Installed" -Result $true `
            -SuccessMessage "Found" `
            -ErrorMessage "" `
            -FixSuggestion ""
    } catch {
        Write-CheckResult -Name "Flutter Installed" -Result $true `
            -SuccessMessage "Found" `
            -ErrorMessage "" `
            -FixSuggestion ""
    }
} else {
    Write-CheckResult -Name "Flutter Installed" -Result $false `
        -SuccessMessage "" `
        -ErrorMessage "Not found" `
        -FixSuggestion "Install from: https://docs.flutter.dev/get-started/install/windows"
}

Write-Host ""

# 5. Devices
Write-Host "4. Checking Devices/Emulators..." -ForegroundColor $InfoColor
if ($flutterInstalled) {
    $devices = flutter devices 2>&1 | Out-String
    $hasDevices = $devices -match "(\d+) connected device"
    $deviceCount = if ($matches) { $matches[1] } else { "0" }
    
    Write-CheckResult -Name "Available Devices" -Result $hasDevices `
        -SuccessMessage "$deviceCount device(s) found" `
        -ErrorMessage "No devices found" `
        -FixSuggestion "Start an emulator or connect a device"
}

Write-Host ""

# 6. Repository
Write-Host "5. Checking Repository..." -ForegroundColor $InfoColor
$repoPath = ".\palestra-app"
$repoExists = Test-Path $repoPath
Write-CheckResult -Name "Repository Cloned" -Result $repoExists `
    -SuccessMessage "Found at $repoPath" `
    -ErrorMessage "Not found" `
    -FixSuggestion "Already cloned - OK"

if ($repoExists) {
    # Check if it's a git repository
    $isGitRepo = Test-Path "$repoPath\.git"
    Write-CheckResult -Name "Valid Git Repository" -Result $isGitRepo `
        -SuccessMessage "Yes" `
        -ErrorMessage "No .git folder found" `
        -FixSuggestion "Repository is valid"
    
    if ($isGitRepo) {
        # Check for vk/ branches
        Push-Location $repoPath
        git fetch --all 2>&1 | Out-Null
        $vkBranches = git branch -r | Select-String "origin/vk/" 
        $vkCount = ($vkBranches | Measure-Object).Count
        Pop-Location
        
        $hasVkBranches = $vkCount -gt 0
        Write-CheckResult -Name "VK Branches Found" -Result $hasVkBranches `
            -SuccessMessage "$vkCount branch(es)" `
            -ErrorMessage "No branches starting with 'vk/' found" `
            -FixSuggestion "Check remote repository"
        
        if ($hasVkBranches) {
            Write-Host ""
            Write-Host "    Available vk/ branches:" -ForegroundColor Gray
            $vkBranches | ForEach-Object {
                $branch = $_.ToString().Trim() -replace "origin/", ""
                Write-Host "      - $branch" -ForegroundColor Gray
            }
        }
    }
}

Write-Host ""

# 7. Scripts
Write-Host "6. Checking Scripts..." -ForegroundColor $InfoColor
$scriptsExist = (Test-Path ".\launcher.ps1") -and 
                (Test-Path ".\run_vk_branches.ps1") -and 
                (Test-Path ".\run_vk_branches_parallel.ps1")
Write-CheckResult -Name "Scripts Available" -Result $scriptsExist `
    -SuccessMessage "All scripts present" `
    -ErrorMessage "Some scripts missing" `
    -FixSuggestion "Ensure all .ps1 files are present"

Write-Host ""
Write-Host "========================================" -ForegroundColor $InfoColor

if ($allGood) {
    Write-Host "ALL CHECKS PASSED!" -ForegroundColor $SuccessColor
    Write-Host ""
    Write-Host "You're ready to start testing!" -ForegroundColor $SuccessColor
    Write-Host "Run: .\launcher.ps1" -ForegroundColor $InfoColor
} else {
    Write-Host "Some checks failed" -ForegroundColor $ErrorColor
    Write-Host ""
    Write-Host "Please fix the issues above before running tests." -ForegroundColor $WarningColor
    Write-Host "For help, see: TROUBLESHOOTING.md" -ForegroundColor $InfoColor
}

Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host ""
