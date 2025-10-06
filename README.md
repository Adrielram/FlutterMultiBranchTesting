# Flutter Multi-Branch Testing Project

Este proyecto automatiza el testing de múltiples branches de Flutter que comienzan con `vk/` desde el repositorio [palestra-app](https://github.com/Adrielram/palestra-app).

> 📚 **Navegación:** Para encontrar rápidamente lo que buscas, consulta el **[ÍNDICE DE DOCUMENTACIÓN](INDEX.md)**
> 
> 🚀 **¿Primera vez aquí?** Ve directo a **[QUICKSTART.md](QUICKSTART.md)**

## 📋 Requisitos

- Windows con PowerShell 5.1 o superior
- Flutter SDK instalado y configurado
- Git instalado
- Un dispositivo/emulador de prueba configurado

## 🚀 Scripts Disponibles

### 0. `launcher.ps1` (Menú Interactivo) ⭐ RECOMENDADO

Menú interactivo que te permite elegir entre los diferentes modos de testing.

**Uso:**
```powershell
# Desde la carpeta MultiBranchTesting
.\launcher.ps1
```

**Opciones del menú:**
- Modo Secuencial
- Modo Paralelo
- Ver branches disponibles
- Actualizar repositorio
- Salir

### 1. `run_vk_branches.ps1` (Secuencial)

Ejecuta las apps de cada branch **uno por uno**, permitiéndote probar cada branch completamente antes de pasar al siguiente.

**Ventajas:**
- Más fácil de seguir
- Menos consumo de recursos
- Ideal para testing detallado de cada branch

**Uso:**
```powershell
# Desde la carpeta MultiBranchTesting
.\run_vk_branches.ps1
```

### 2. `run_vk_branches_parallel.ps1` (Paralelo)

Ejecuta las apps de **todos los branches simultáneamente**, cada uno en su propia ventana de PowerShell.

**Ventajas:**
- Testing más rápido
- Ver todas las apps corriendo al mismo tiempo
- Cada branch tiene su NOMBRE visible en la ventana

**Desventajas:**
- Consume más recursos del sistema
- Requiere múltiples dispositivos/emuladores O ejecutarlos en secuencia en el mismo dispositivo

**Uso:**
```powershell
# Desde la carpeta MultiBranchTesting
.\run_vk_branches_parallel.ps1
```

## 📁 Estructura del Proyecto

```
MultiBranchTesting/
├── palestra-app/                    # Repositorio clonado
├── launcher.ps1                     # Menú interactivo (RECOMENDADO)
├── run_vk_branches.ps1             # Script secuencial
├── run_vk_branches_parallel.ps1    # Script paralelo
└── README.md                        # Este archivo
```

## 🔧 Cómo Funciona

### Script Secuencial:
1. Obtiene todos los branches remotos que empiezan con `vk/`
2. Para cada branch:
   - Hace checkout del branch
   - Ejecuta `git pull` para obtener los últimos cambios
   - Ejecuta `flutter pub get` para instalar dependencias
   - Ejecuta `flutter run` con el nombre del branch como identificador
   - Espera a que detengas la app antes de pasar al siguiente branch

### Script Paralelo:
1. Obtiene todos los branches remotos que empiezan con `vk/`
2. Para cada branch:
   - Crea una copia del repositorio en un directorio temporal
   - Hace checkout del branch específico
   - Lanza una nueva ventana de PowerShell
   - En cada ventana:
     - Actualiza el branch
     - Instala dependencias
     - Ejecuta la app con el nombre del branch visible en el título de la ventana

## 🏷️ Identificación de Branches

Cada ejecución de la app incluye el nombre del branch mediante:
- **Título de la ventana**: Muestra "Flutter App - Branch: vk/nombre-del-branch"
- **Variable DART_DEFINE**: Pasa `BRANCH_NAME` a la app de Flutter

Para usar el nombre del branch dentro de tu app Flutter:
```dart
const String branchName = String.fromEnvironment('BRANCH_NAME', defaultValue: 'unknown');

// Úsalo en tu UI
Text('Running branch: $branchName')
```

## 🔍 Branches Encontrados

Actualmente, el repositorio tiene estos branches `vk/`:
- `vk/1365-inscripciones`
- `vk/2cdd-fix-inscirpcione`
- `vk/abd7-fix-inscripcione`

## ⚙️ Configuración de Permisos

Si encuentras errores de ejecución de scripts, ejecuta:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 📝 Notas Importantes

1. **Dispositivos/Emuladores**: Asegúrate de tener al menos un dispositivo o emulador disponible antes de ejecutar los scripts.

2. **Modo Paralelo**: Si usas el script paralelo y solo tienes un dispositivo, necesitarás:
   - Detener cada app manualmente antes de que se lance la siguiente
   - O tener múltiples dispositivos/emuladores conectados

3. **Espacio en Disco**: El modo paralelo crea copias temporales del repositorio en `%TEMP%\flutter_branch_testing\`.

4. **Limpieza**: Los directorios temporales se limpian automáticamente en la próxima ejecución.

## 🐛 Solución de Problemas

### Error: "git no reconocido"
- Asegúrate de que Git esté instalado y en tu PATH

### Error: "flutter no reconocido"
- Asegúrate de que Flutter esté instalado y en tu PATH
- Ejecuta `flutter doctor` para verificar tu instalación

### Error: "No devices found"
- Conecta un dispositivo físico O
- Inicia un emulador de Android/iOS

### El script no se ejecuta
- Verifica los permisos de ejecución con `Set-ExecutionPolicy`

## 📚 Recursos Adicionales

- [Flutter Documentation](https://docs.flutter.dev/)
- [Git Documentation](https://git-scm.com/doc)
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)

## 👨‍💻 Autor

Proyecto creado para facilitar el testing de múltiples branches del repositorio palestra-app.

---

**¡Happy Testing!** 🚀
