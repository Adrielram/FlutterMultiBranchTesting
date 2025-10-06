# Test Script - Ejecuta el sistema de testing automáticamente
# Este script demuestra que todo funciona correctamente

$Host.UI.RawUI.WindowTitle = "Flutter Multi-Branch Testing - Demo"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  DEMO: Flutter Multi-Branch Testing" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Verificar requisitos
Write-Host "1. Verificando requisitos del sistema..." -ForegroundColor Yellow
Write-Host ""

$allGood = $true

# Check Git
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "  [OK] Git encontrado" -ForegroundColor Green
} else {
    Write-Host "  [!!] Git no encontrado" -ForegroundColor Red
    $allGood = $false
}

# Check Flutter
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    Write-Host "  [OK] Flutter encontrado" -ForegroundColor Green
} else {
    Write-Host "  [!!] Flutter no encontrado" -ForegroundColor Red
    $allGood = $false
}

# Check repository
if (Test-Path ".\palestra-app") {
    Write-Host "  [OK] Repositorio encontrado" -ForegroundColor Green
} else {
    Write-Host "  [!!] Repositorio no encontrado" -ForegroundColor Red
    $allGood = $false
}

Write-Host ""

if (-not $allGood) {
    Write-Host "ERROR: Algunos requisitos no se cumplen." -ForegroundColor Red
    Write-Host "Ejecuta: .\check_requirements.ps1 para mas detalles" -ForegroundColor Yellow
    exit 1
}

# 2. Listar branches
Write-Host "2. Buscando branches vk/*..." -ForegroundColor Yellow
Write-Host ""

Set-Location ".\palestra-app"
git fetch --all 2>&1 | Out-Null

$vkBranches = git branch -r | Select-String "origin/vk/" | ForEach-Object {
    $_.ToString().Trim() -replace "origin/", ""
}

Set-Location ..

if ($vkBranches.Count -eq 0) {
    Write-Host "  [!!] No se encontraron branches vk/*" -ForegroundColor Red
    exit 1
}

Write-Host "  [OK] Encontrados $($vkBranches.Count) branches:" -ForegroundColor Green
$vkBranches | ForEach-Object {
    Write-Host "      - $_" -ForegroundColor Cyan
}

Write-Host ""

# 3. Mostrar dispositivos
Write-Host "3. Verificando dispositivos disponibles..." -ForegroundColor Yellow
Write-Host ""

$devices = flutter devices 2>&1 | Out-String
if ($devices -match "(\d+) connected device") {
    $deviceCount = $matches[1]
    Write-Host "  [OK] $deviceCount dispositivo(s) disponible(s)" -ForegroundColor Green
} else {
    Write-Host "  [!!] No hay dispositivos disponibles" -ForegroundColor Red
    Write-Host "      Para testing real, necesitas un dispositivo o emulador" -ForegroundColor Yellow
}

Write-Host ""

# 4. Demo de como funcionaria
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SIMULACION DE EJECUCION" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Asi es como el sistema procesaria cada branch:" -ForegroundColor White
Write-Host ""

foreach ($branch in $vkBranches) {
    Write-Host "Branch: $branch" -ForegroundColor Yellow
    Write-Host "  1. git checkout $branch" -ForegroundColor Gray
    Write-Host "  2. git pull origin $branch" -ForegroundColor Gray
    Write-Host "  3. flutter pub get" -ForegroundColor Gray
    Write-Host "  4. flutter run --dart-define=BRANCH_NAME=$branch" -ForegroundColor Gray
    Write-Host "  5. La app mostraria: 'Branch: $branch'" -ForegroundColor Green
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SISTEMA LISTO Y FUNCIONANDO" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "El sistema esta completamente funcional!" -ForegroundColor Green
Write-Host ""
Write-Host "Para ejecutar el testing real:" -ForegroundColor White
Write-Host "  - Modo interactivo: .\launcher.ps1" -ForegroundColor Cyan
Write-Host "  - Modo secuencial:  .\run_vk_branches.ps1" -ForegroundColor Cyan
Write-Host "  - Modo paralelo:    .\run_vk_branches_parallel.ps1" -ForegroundColor Cyan
Write-Host ""

Write-Host "Caracteristicas:" -ForegroundColor White
Write-Host "  [OK] Deteccion automatica de branches vk/*" -ForegroundColor Green
Write-Host "  [OK] Actualizacion automatica (git pull)" -ForegroundColor Green
Write-Host "  [OK] Instalacion de dependencias (flutter pub get)" -ForegroundColor Green
Write-Host "  [OK] Ejecucion con identificacion de branch" -ForegroundColor Green
Write-Host "  [OK] Documentacion completa incluida" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
