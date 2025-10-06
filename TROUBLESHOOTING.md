# 🔧 Guía de Solución de Problemas

## Problemas con PowerShell

### Error: "No se puede cargar el archivo... porque la ejecución de scripts está deshabilitada"

**Síntomas:**
```
.\launcher.ps1 : No se puede cargar el archivo D:\Personal_Projects\MultiBranchTesting\launcher.ps1
porque la ejecución de scripts está deshabilitada en este sistema.
```

**Solución:**
```powershell
# Opción 1: Para el usuario actual (Recomendado)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Opción 2: Bypass para esta sesión solamente
powershell.exe -ExecutionPolicy Bypass -File .\launcher.ps1

# Verificar el estado actual
Get-ExecutionPolicy -List
```

### Error: "El término '...' no se reconoce como nombre de un cmdlet"

**Para Git:**
```powershell
# Verificar instalación
git --version

# Si no está instalado, descargar de:
# https://git-scm.com/download/win

# Agregar al PATH manualmente:
$env:Path += ";C:\Program Files\Git\cmd"

# Permanente (requiere reiniciar PowerShell):
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Git\cmd", "User")
```

**Para Flutter:**
```powershell
# Verificar instalación
flutter --version

# Si no está instalado:
# https://docs.flutter.dev/get-started/install/windows

# Agregar al PATH (ajustar ruta según tu instalación):
$env:Path += ";C:\src\flutter\bin"
```

## Problemas con Git

### Error: "fatal: not a git repository"

**Síntomas:**
```
fatal: not a git repository (or any of the parent directories): .git
```

**Solución:**
```powershell
# Verificar que estás en el directorio correcto
cd d:\Personal_Projects\MultiBranchTesting\palestra-app

# Si el repositorio no existe, clonarlo:
cd ..
git clone https://github.com/Adrielram/palestra-app
```

### Error: "fatal: Authentication failed"

**Solución para HTTPS:**
```powershell
# Opción 1: Usar GitHub CLI
gh auth login

# Opción 2: Configurar credenciales
git config --global credential.helper manager-core

# Opción 3: Usar SSH en lugar de HTTPS
git remote set-url origin git@github.com:Adrielram/palestra-app.git
```

### Error: "Your local changes... would be overwritten by checkout"

**Síntomas:**
```
error: Your local changes to the following files would be overwritten by checkout:
    lib/some_file.dart
Please commit your changes or stash them before you switch branches.
```

**Solución:**
```powershell
cd palestra-app

# Opción 1: Guardar cambios en stash
git stash
git checkout <branch>
git stash pop

# Opción 2: Descartar cambios locales (¡CUIDADO!)
git reset --hard HEAD
git checkout <branch>

# Opción 3: Limpiar completamente (¡CUIDADO!)
git clean -fd
git checkout <branch>
```

## Problemas con Flutter

### Error: "No devices found"

**Síntomas:**
```
No supported devices connected.
```

**Diagnóstico:**
```powershell
# Ver dispositivos disponibles
flutter devices

# Ver estado completo de Flutter
flutter doctor -v
```

**Soluciones:**

**Para Android Emulator:**
```powershell
# Listar emuladores disponibles
flutter emulators

# Crear un nuevo emulador (si no tienes ninguno)
# Primero abre Android Studio > Tools > Device Manager > Create Device

# Iniciar emulador específico
flutter emulators --launch <emulator_id>

# Ejemplo:
flutter emulators --launch Pixel_5_API_33
```

**Para Dispositivo Android Físico:**
1. Habilitar "Opciones de Desarrollador" en tu dispositivo
2. Habilitar "Depuración USB"
3. Conectar por USB
4. Aceptar el prompt de autorización en el dispositivo
5. Verificar: `flutter devices`

**Para Windows Desktop:**
```powershell
# Habilitar Windows Desktop support
flutter config --enable-windows-desktop

# Verificar
flutter devices
```

### Error: "Unable to locate Android SDK"

**Síntomas:**
```
Android sdkmanager not found. Update to the latest Android SDK
```

**Solución:**
```powershell
# Establecer ANDROID_HOME
$env:ANDROID_HOME = "C:\Users\<TuUsuario>\AppData\Local\Android\Sdk"

# Permanente:
[Environment]::SetEnvironmentVariable("ANDROID_HOME", "C:\Users\<TuUsuario>\AppData\Local\Android\Sdk", "User")

# Agregar al PATH
$env:Path += ";$env:ANDROID_HOME\platform-tools;$env:ANDROID_HOME\tools"

# Verificar
flutter doctor
```

### Error: "Gradle build failed"

**Síntomas:**
```
FAILURE: Build failed with an exception.
```

**Soluciones:**

**1. Limpiar y reconstruir:**
```powershell
cd palestra-app
flutter clean
flutter pub get
flutter run
```

**2. Invalidar caché de Gradle:**
```powershell
cd android
.\gradlew clean
cd ..
flutter run
```

**3. Actualizar dependencias de Gradle:**
```powershell
# En android/build.gradle, actualizar:
# classpath 'com.android.tools.build:gradle:7.4.2'
# o la versión más reciente
```

**4. Problema de Java version:**
```powershell
# Verificar versión de Java
java -version

# Flutter requiere Java 11 o superior
# Descargar desde: https://www.oracle.com/java/technologies/downloads/
```

### Error: "Pub get failed"

**Síntomas:**
```
Running "flutter pub get" in palestra-app...
pub get failed (server unavailable)
```

**Soluciones:**

**1. Verificar conexión:**
```powershell
# Probar conexión a pub.dev
Test-NetConnection pub.dev -Port 443

# Intentar con un mirror si estás detrás de un firewall
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
flutter pub get
```

**2. Limpiar caché:**
```powershell
flutter pub cache repair
flutter pub get
```

**3. Eliminar pubspec.lock:**
```powershell
cd palestra-app
Remove-Item pubspec.lock
flutter pub get
```

### Error: "Hot reload not supported"

**Síntomas:**
```
Hot reload is not supported without a debug build
```

**Solución:**
```powershell
# Asegurarse de ejecutar en modo debug (por defecto)
flutter run

# No uses estos comandos durante testing:
# flutter run --release  # ❌
# flutter run --profile  # ❌
```

## Problemas con Scripts

### Los scripts no encuentran el repositorio

**Síntomas:**
```
Cannot find path 'palestra-app' because it does not exist
```

**Solución:**
```powershell
# Verificar que el repositorio está clonado
cd d:\Personal_Projects\MultiBranchTesting
ls

# Si no existe palestra-app, clonarlo:
git clone https://github.com/Adrielram/palestra-app
```

### El modo paralelo no abre ventanas

**Síntomas:**
- El script dice "Launched window" pero no se abren ventanas

**Solución:**
```powershell
# Verificar que PowerShell puede crear procesos
Start-Process notepad.exe  # Test básico

# Si hay problemas de permisos:
# Ejecutar PowerShell como Administrador

# Verificar política de ejecución
Get-ExecutionPolicy -List

# Si sigue sin funcionar, usar modo secuencial:
.\run_vk_branches.ps1
```

### Script se detiene en medio de la ejecución

**Posibles causas y soluciones:**

**1. Error en un branch específico:**
```powershell
# El script debería continuar automáticamente
# Si se detiene, ejecutar manualmente ese branch:
cd palestra-app
git checkout vk/<branch-problemático>
git pull
flutter pub get
flutter run
```

**2. Tiempo de espera agotado:**
```powershell
# Aumentar timeout en el script
# Editar run_vk_branches.ps1 y agregar:
# Start-Sleep -Seconds 30  # antes de cada flutter run
```

## Problemas de Rendimiento

### La app corre muy lenta

**Síntomas:**
- Lag, stuttering, respuesta lenta

**Causas y Soluciones:**

**1. Estás en modo Debug:**
```
Esto es NORMAL. El modo debug es más lento porque:
- Tiene assertions habilitadas
- No está optimizado
- Incluye información de debugging

Solución: Para pruebas de performance, usa:
flutter run --profile
```

**2. Emulador lento:**
```powershell
# Usar emulador con aceleración de hardware
# En Android Studio:
# Tools > AVD Manager > Edit > Show Advanced Settings
# Habilitar: Hardware - GLES 2.0
# Graphics: Hardware - GLES 2.0
```

**3. Múltiples apps corriendo:**
```
Si usas modo paralelo, cada app consume recursos.
Solución: Usa modo secuencial o cierra apps que no estés probando.
```

### El sistema se queda sin memoria

**Síntomas:**
- Sistema lento
- Aplicaciones cerrándose
- Error "Out of memory"

**Solución:**
```powershell
# Usar modo secuencial en lugar de paralelo
.\run_vk_branches.ps1

# O ejecutar solo 1-2 branches a la vez en paralelo
# Editar run_vk_branches_parallel.ps1 y comentar branches no necesarios
```

## Problemas Específicos de Windows

### Error: "Path too long"

**Síntomas:**
```
The specified path, file name, or both are too long
```

**Solución:**
```powershell
# Habilitar long paths en Windows
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force

# Reiniciar Windows

# Usar rutas más cortas:
cd C:\Testing
git clone https://github.com/Adrielram/palestra-app
```

### Antivirus bloquea los scripts

**Síntomas:**
- Scripts no se ejecutan
- Archivos desaparecen
- Windows Defender alerta

**Solución:**
```powershell
# Agregar exclusión en Windows Defender:
# Settings > Update & Security > Windows Security > Virus & threat protection
# > Manage settings > Add or remove exclusions
# Agregar: d:\Personal_Projects\MultiBranchTesting
```

## Comandos de Diagnóstico

### Verificar estado completo del sistema

```powershell
# Crear script de diagnóstico
Write-Host "=== System Diagnostic ===" -ForegroundColor Cyan

Write-Host "`nGit:" -ForegroundColor Yellow
git --version

Write-Host "`nFlutter:" -ForegroundColor Yellow
flutter --version

Write-Host "`nFlutter Doctor:" -ForegroundColor Yellow
flutter doctor

Write-Host "`nDevices:" -ForegroundColor Yellow
flutter devices

Write-Host "`nEmulators:" -ForegroundColor Yellow
flutter emulators

Write-Host "`nBranches:" -ForegroundColor Yellow
cd palestra-app
git branch -a
cd ..

Write-Host "`nDisk Space:" -ForegroundColor Yellow
Get-PSDrive C

Write-Host "`nPowerShell Version:" -ForegroundColor Yellow
$PSVersionTable.PSVersion
```

### Limpiar completamente el proyecto

```powershell
# WARNING: Esto borrará todos los cambios locales
cd d:\Personal_Projects\MultiBranchTesting\palestra-app

# Descartar todos los cambios
git reset --hard HEAD
git clean -fd

# Limpiar Flutter
flutter clean

# Obtener dependencias frescas
flutter pub get

# Volver a main branch
git checkout main
```

## ¿Aún tienes problemas?

### Crear un reporte de error

```powershell
# Ejecutar diagnóstico completo y guardar salida
.\diagnostic_script.ps1 > diagnostic_output.txt 2>&1

# El archivo diagnostic_output.txt contendrá toda la información
# Compártelo para obtener ayuda
```

### Reset completo (último recurso)

```powershell
# ⚠️ CUIDADO: Esto borrará todo
cd d:\Personal_Projects\MultiBranchTesting

# Eliminar repositorio
Remove-Item -Recurse -Force palestra-app

# Clonar de nuevo
git clone https://github.com/Adrielram/palestra-app

# Ejecutar launcher nuevamente
.\launcher.ps1
```

## Recursos Adicionales

- [Flutter Official Docs](https://docs.flutter.dev/)
- [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)
- [Flutter Community](https://flutter.dev/community)
- [Git Documentation](https://git-scm.com/doc)
- [PowerShell Documentation](https://docs.microsoft.com/powershell/)
