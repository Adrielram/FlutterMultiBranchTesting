# Script para ejecutar una branch especifica con toda la informacion del commit
# Permite al usuario seleccionar exactamente cual branch quiere probar

param(
    [string]$BranchName = "",
    [string]$RepoPath = ".\palestra-app"
)

# Colores
$SuccessColor = "Green"
$ErrorColor = "Red"
$InfoColor = "Cyan"
$WarningColor = "Yellow"

Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host "  Ejecutar Branch Especifica" -ForegroundColor $SuccessColor
Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host ""

# Cambiar al directorio del repositorio
Set-Location $RepoPath

# Obtener todas las branches vk/
Write-Host "Obteniendo branches disponibles..." -ForegroundColor $InfoColor
git fetch --all 2>&1 | Out-Null

$vkBranches = git branch -r | Select-String "origin/vk/" | ForEach-Object {
    $_.ToString().Trim() -replace "origin/", ""
}

if ($vkBranches.Count -eq 0) {
    Write-Host "No se encontraron branches que empiecen con vk/" -ForegroundColor $ErrorColor
    Set-Location ..
    exit 1
}

# Si no se especifico branch, mostrar menu
if ([string]::IsNullOrEmpty($BranchName)) {
    Write-Host "Branches disponibles:" -ForegroundColor $SuccessColor
    Write-Host ""
    
    $index = 1
    $branchMap = @{}
    foreach ($branch in $vkBranches) {
        Write-Host "  [$index] $branch" -ForegroundColor $InfoColor
        $branchMap[$index] = $branch
        $index++
    }
    
    Write-Host ""
    Write-Host "  [0] Cancelar y volver" -ForegroundColor $WarningColor
    Write-Host ""
    
    $selection = Read-Host "Seleccione el numero de branch (0 para cancelar)"
    
    if ($selection -eq "0" -or [string]::IsNullOrEmpty($selection)) {
        Write-Host "Operacion cancelada." -ForegroundColor $WarningColor
        Set-Location ..
        return
    }
    
    $selectedIndex = [int]$selection
    if ($branchMap.ContainsKey($selectedIndex)) {
        $BranchName = $branchMap[$selectedIndex]
    } else {
        Write-Host "Seleccion invalida." -ForegroundColor $ErrorColor
        Set-Location ..
        exit 1
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host "Branch seleccionada: $BranchName" -ForegroundColor $SuccessColor
Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host ""

# Checkout del branch
Write-Host "Cambiando a branch: $BranchName..." -ForegroundColor $InfoColor
git checkout $BranchName 2>&1 | Out-Null

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al cambiar a branch $BranchName" -ForegroundColor $ErrorColor
    Set-Location ..
    exit 1
}

# Pull de cambios
Write-Host "Obteniendo ultimos cambios..." -ForegroundColor $InfoColor
git pull origin $BranchName 2>&1 | Out-Null

# Obtener informacion del commit
Write-Host "Obteniendo informacion del commit..." -ForegroundColor $InfoColor
Write-Host ""

$commitHash = git rev-parse --short HEAD
$commitHashFull = git rev-parse HEAD
$commitMessage = git log -1 --pretty=%B
$commitAuthor = git log -1 --pretty=%an
$commitEmail = git log -1 --pretty=%ae
$commitDate = git log -1 --pretty=%ad --date=iso
$commitDateRelative = git log -1 --pretty=%ar
$filesChanged = git diff-tree --no-commit-id --name-only -r HEAD

# Mostrar informacion del commit en consola
Write-Host "============================================================" -ForegroundColor $InfoColor
Write-Host "              INFORMACION DEL COMMIT                        " -ForegroundColor $InfoColor
Write-Host "============================================================" -ForegroundColor $InfoColor
Write-Host "Branch:   $BranchName" -ForegroundColor $SuccessColor
Write-Host "Commit:   $commitHash" -ForegroundColor $SuccessColor
Write-Host "Autor:    $commitAuthor <$commitEmail>" -ForegroundColor $SuccessColor
Write-Host "Fecha:    $commitDate ($commitDateRelative)" -ForegroundColor $SuccessColor
Write-Host "============================================================" -ForegroundColor $InfoColor
Write-Host "Mensaje del Commit:" -ForegroundColor $WarningColor
Write-Host ""

# Mostrar mensaje del commit (puede ser multilinea)
$commitMessage -split "`n" | ForEach-Object {
    $line = $_.Trim()
    if ($line.Length -gt 0) {
        Write-Host "  $line" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor $InfoColor
Write-Host "Archivos Modificados:" -ForegroundColor $WarningColor
Write-Host ""

if ($filesChanged) {
    $filesChanged -split "`n" | ForEach-Object {
        if ($_.Trim().Length -gt 0) {
            Write-Host "  - $_" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "  (No hay archivos modificados o es el primer commit)" -ForegroundColor Gray
}

Write-Host "============================================================" -ForegroundColor $InfoColor
Write-Host ""

# Instalar dependencias
Write-Host "Instalando dependencias de Flutter..." -ForegroundColor $InfoColor
flutter pub get 2>&1 | Out-Null

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al instalar dependencias." -ForegroundColor $ErrorColor
    Set-Location ..
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host "  INICIANDO APLICACION FLUTTER" -ForegroundColor $SuccessColor
Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host ""
Write-Host "La aplicacion mostrara la siguiente informacion:" -ForegroundColor $InfoColor
Write-Host "  - Nombre del branch: $BranchName" -ForegroundColor $SuccessColor
Write-Host "  - Hash del commit: $commitHash" -ForegroundColor $SuccessColor
$firstLineMessage = $commitMessage -split "`n" | Select-Object -First 1
Write-Host "  - Mensaje: $firstLineMessage..." -ForegroundColor $SuccessColor
Write-Host "  - Autor: $commitAuthor" -ForegroundColor $SuccessColor
Write-Host "  - Fecha: $commitDate" -ForegroundColor $SuccessColor
Write-Host ""
Write-Host "Presiona [q] en la terminal para detener la aplicacion" -ForegroundColor $WarningColor
Write-Host ""

# Ejecutar Flutter con toda la informacion del commit
# Escapar caracteres especiales para evitar problemas
$safeCommitMessage = $commitMessage -replace "`"", """""" -replace "`n", " " -replace "`r", ""
if ($safeCommitMessage.Length -gt 500) {
    $safeCommitMessage = $safeCommitMessage.Substring(0, 500)
}

flutter run --dart-define=BRANCH_NAME=$BranchName --dart-define=COMMIT_HASH=$commitHash --dart-define=COMMIT_HASH_FULL=$commitHashFull --dart-define=COMMIT_MESSAGE=$safeCommitMessage --dart-define=COMMIT_AUTHOR=$commitAuthor --dart-define=COMMIT_EMAIL=$commitEmail --dart-define=COMMIT_DATE=$commitDate --dart-define=COMMIT_DATE_RELATIVE=$commitDateRelative

Write-Host ""
Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host "Aplicacion detenida." -ForegroundColor $SuccessColor
Write-Host "========================================" -ForegroundColor $InfoColor
Write-Host ""

Set-Location ..
