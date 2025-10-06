# 🚀 Guía de Inicio Rápido

## RESUMEN
Tener flutter instalado.
Git pull <repo>.
En powershell: .\launcher.ps1

## Configuración Inicial (Solo una vez)

### 1. Verificar Requisitos

Abre PowerShell y verifica que tengas todo instalado:

```powershell
# Verificar Git
git --version

# Verificar Flutter
flutter --version

# Verificar dispositivos disponibles
flutter devices
```

### 2. Configurar Permisos de PowerShell

Si es la primera vez que ejecutas scripts de PowerShell:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 3. Navegar al Directorio del Proyecto

```powershell
cd d:\Personal_Projects\MultiBranchTesting
```

## 🎯 Ejecutar Testing

### Opción 1: Usar el Launcher (Recomendado)

```powershell
.\launcher.ps1
```

Luego selecciona la opción que desees del menú interactivo.

### Opción 2: Ejecutar Directamente

**Para testing secuencial:**
```powershell
.\run_vk_branches.ps1
```

**Para testing paralelo:**
```powershell
.\run_vk_branches_parallel.ps1
```

## 📱 Preparar Dispositivo/Emulador

### Android

**Emulador:**
```powershell
# Listar emuladores disponibles
flutter emulators

# Iniciar un emulador
flutter emulators --launch <nombre_emulador>
```

**Dispositivo físico:**
1. Habilita "Depuración USB" en tu dispositivo Android
2. Conecta el dispositivo por USB
3. Verifica: `flutter devices`

### iOS (Solo en macOS)

**Simulador:**
```bash
open -a Simulator
```

**Dispositivo físico:**
1. Conecta el dispositivo por USB
2. Confía en la computadora desde el dispositivo
3. Verifica: `flutter devices`

## 🎮 Durante la Ejecución

### Modo Secuencial:
- La app se ejecutará para cada branch
- Presiona `q` en la terminal para detener la app actual
- Se te preguntará si deseas continuar con el siguiente branch

### Modo Paralelo:
- Se abrirá una ventana separada para cada branch
- Cada ventana mostrará el nombre del branch en el título
- Cierra cada ventana individual cuando termines de probar ese branch

## 🛑 Detener una App

En la terminal donde corre la app, presiona:
- `q` + Enter (detiene la app pero mantiene la terminal abierta)
- `Ctrl + C` (fuerza el cierre)

## ⚡ Tips Útiles

1. **Ver branches disponibles antes de ejecutar:**
   - Usa la opción 3 del launcher
   - O ejecuta: `cd palestra-app; git branch -r | Select-String "vk/"`

2. **Actualizar branches antes de testing:**
   - Usa la opción 4 del launcher
   - O ejecuta: `cd palestra-app; git fetch --all`

3. **Testing rápido de un solo branch:**
   ```powershell
   cd palestra-app
   git checkout vk/<nombre-del-branch>
   git pull
   flutter pub get
   flutter run --dart-define=BRANCH_NAME=vk/<nombre-del-branch>
   ```

4. **Limpiar cache de Flutter si hay problemas:**
   ```powershell
   cd palestra-app
   flutter clean
   flutter pub get
   ```

## 🔍 Verificar Qué Branch Está Corriendo

En tu app Flutter, puedes mostrar el nombre del branch usando:

```dart
// En tu código Dart
const String branchName = String.fromEnvironment('BRANCH_NAME', defaultValue: 'unknown');

// Ejemplo de uso en un widget
Text('Branch: $branchName')
```

## 📞 Solución de Problemas Comunes

### "No se puede ejecutar el script"
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "No devices found"
1. Verifica dispositivos: `flutter devices`
2. Si no hay ninguno, inicia un emulador
3. Si hay problemas, ejecuta: `flutter doctor`

### "git no reconocido"
- Instala Git desde: https://git-scm.com/download/win
- Reinicia PowerShell después de instalar

### "flutter no reconocido"
- Instala Flutter desde: https://docs.flutter.dev/get-started/install/windows
- Añade Flutter al PATH
- Reinicia PowerShell

### Error de dependencias
```powershell
cd palestra-app
flutter clean
flutter pub get
```

## 📊 Ejemplo Completo de Flujo

```powershell
# 1. Abrir PowerShell en el directorio correcto
cd d:\Personal_Projects\MultiBranchTesting

# 2. Iniciar un emulador (si usas Android)
flutter emulators --launch <nombre_emulador>

# 3. Ejecutar el launcher
.\launcher.ps1

# 4. Seleccionar opción 1 (Secuencial) o 2 (Paralelo)

# 5. Esperar a que se ejecuten las apps

# 6. Probar cada app

# 7. Detener cuando termines (q + Enter)
```

---

**¿Listo para empezar?** Ejecuta `.\launcher.ps1` y ¡comienza a probar! 🎉
