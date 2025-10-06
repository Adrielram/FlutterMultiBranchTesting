# Flutter Multi-Branch Test Launcher
# Interactive menu to choose which testing mode to use

$Host.UI.RawUI.WindowTitle = "Flutter Multi-Branch Test Launcher"

function Show-Menu {
    Clear-Host
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host "   Flutter Multi-Branch Test Launcher" -ForegroundColor Green
    Write-Host "   Repository: palestra-app" -ForegroundColor Yellow
    Write-Host "=============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Seleccione el modo de testing:" -ForegroundColor White
    Write-Host ""
    Write-Host "  [1] Modo Secuencial" -ForegroundColor Green
    Write-Host "      - Ejecuta un branch a la vez" -ForegroundColor Gray
    Write-Host "      - Menor consumo de recursos" -ForegroundColor Gray
    Write-Host "      - Ideal para testing detallado" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [2] Modo Paralelo" -ForegroundColor Green
    Write-Host "      - Ejecuta todos los branches simultáneamente" -ForegroundColor Gray
    Write-Host "      - Cada branch en su propia ventana" -ForegroundColor Gray
    Write-Host "      - Testing más rápido" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [3] Ver información de branches disponibles" -ForegroundColor Green
    Write-Host ""
    Write-Host "  [4] Actualizar repositorio (git fetch)" -ForegroundColor Green
    Write-Host ""
    Write-Host "  [5] Verificar requisitos del sistema" -ForegroundColor Green
    Write-Host ""
    Write-Host "  [Q] Salir" -ForegroundColor Red
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Cyan
}

function Show-Branches {
    Write-Host ""
    Write-Host "Obteniendo información de branches..." -ForegroundColor Yellow
    
    Set-Location ".\palestra-app"
    git fetch --all | Out-Null
    
    $branches = git branch -r | Select-String "origin/vk/" | ForEach-Object {
        $_.ToString().Trim() -replace "origin/", ""
    }
    
    Write-Host ""
    Write-Host "Branches disponibles que comienzan con 'vk/':" -ForegroundColor Green
    Write-Host ""
    
    if ($branches.Count -eq 0) {
        Write-Host "  No se encontraron branches con el prefijo 'vk/'" -ForegroundColor Red
    } else {
        $branches | ForEach-Object { 
            Write-Host "  - $_" -ForegroundColor Cyan 
        }
        Write-Host ""
        Write-Host "Total: $($branches.Count) branch(es)" -ForegroundColor Yellow
    }
    
    Set-Location ..
    Write-Host ""
    Write-Host "Presione cualquier tecla para volver al menu..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Update-Repository {
    Write-Host ""
    Write-Host "Actualizando repositorio..." -ForegroundColor Yellow
    
    Set-Location ".\palestra-app"
    git fetch --all
    
    Set-Location ..
    Write-Host ""
    Write-Host "Repositorio actualizado." -ForegroundColor Green
    Write-Host ""
    Write-Host "Presione cualquier tecla para volver al menu..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Main loop
do {
    Show-Menu
    $choice = Read-Host "Ingrese su opcion"
    
    switch ($choice) {
        '1' {
            Write-Host ""
            Write-Host "Iniciando modo secuencial..." -ForegroundColor Green
            Write-Host ""
            Start-Sleep -Seconds 1
            & ".\run_vk_branches.ps1"
            Write-Host ""
            Write-Host "Presione cualquier tecla para volver al menu..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        '2' {
            Write-Host ""
            Write-Host "Iniciando modo paralelo..." -ForegroundColor Green
            Write-Host ""
            Start-Sleep -Seconds 1
            & ".\run_vk_branches_parallel.ps1"
            Write-Host ""
            Write-Host "Presione cualquier tecla para volver al menu..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        '3' {
            Show-Branches
        }
        '4' {
            Update-Repository
        }
        '5' {
            Write-Host ""
            Write-Host "Verificando requisitos del sistema..." -ForegroundColor Green
            Write-Host ""
            Start-Sleep -Seconds 1
            & ".\check_requirements.ps1"
        }
        'Q' {
            Write-Host ""
            Write-Host "Hasta luego!" -ForegroundColor Green
            Write-Host ""
            return
        }
        default {
            Write-Host ""
            Write-Host "Opcion invalida. Presione cualquier tecla para continuar..." -ForegroundColor Red
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    }
} while ($true)
