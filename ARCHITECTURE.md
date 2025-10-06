# 🎯 Arquitectura del Sistema de Testing

## Flujo de Trabajo

```
┌─────────────────────────────────────────────────────────────┐
│                     USUARIO EJECUTA                          │
│                      launcher.ps1                            │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
        ┌────────────────┐
        │  Menú Interactivo│
        └────────┬────────┘
                 │
        ┌────────┴────────┐
        │                 │
        ▼                 ▼
┌──────────────┐  ┌──────────────────┐
│  Secuencial  │  │    Paralelo      │
│  (Opción 1)  │  │   (Opción 2)     │
└──────┬───────┘  └────────┬─────────┘
       │                   │
       ▼                   ▼
```

## Modo Secuencial

```
┌─────────────────────────────────────────────────────┐
│         run_vk_branches.ps1                         │
└─────────────────────────────────────────────────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │  git fetch --all       │
        └────────────┬───────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │  Obtener branches vk/* │
        └────────────┬───────────┘
                     │
        ┌────────────▼───────────┐
        │  Para cada branch:     │
        │  1. git checkout       │
        │  2. git pull           │
        │  3. flutter pub get    │
        │  4. flutter run        │
        │  5. Esperar usuario    │
        │  6. Siguiente branch   │
        └────────────────────────┘
```

## Modo Paralelo

```
┌─────────────────────────────────────────────────────┐
│       run_vk_branches_parallel.ps1                  │
└─────────────────────────────────────────────────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │  git fetch --all       │
        └────────────┬───────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │  Obtener branches vk/* │
        └────────────┬───────────┘
                     │
        ┌────────────▼────────────┐
        │  Para cada branch:      │
        │  - Crear dir temporal   │
        │  - Clonar repo          │
        │  - Crear script branch  │
        │  - Lanzar nueva ventana │
        └─────────────────────────┘
                     │
        ┌────────────▼─────────────────┬──────────────┐
        │                              │              │
        ▼                              ▼              ▼
┌──────────────┐           ┌──────────────┐  ┌──────────────┐
│  Ventana 1   │           │  Ventana 2   │  │  Ventana 3   │
│  Branch: vk/ │           │  Branch: vk/ │  │  Branch: vk/ │
│  1365-...    │           │  2cdd-...    │  │  abd7-...    │
│              │           │              │  │              │
│  - checkout  │           │  - checkout  │  │  - checkout  │
│  - pull      │           │  - pull      │  │  - pull      │
│  - pub get   │           │  - pub get   │  │  - pub get   │
│  - flutter   │           │  - flutter   │  │  - flutter   │
│    run       │           │    run       │  │    run       │
└──────────────┘           └──────────────┘  └──────────────┘
```

## Estructura de Directorios

### Durante Ejecución Secuencial:
```
d:\Personal_Projects\MultiBranchTesting\
├── palestra-app\              ← Repositorio único
│   ├── lib\
│   ├── android\
│   ├── ios\
│   └── pubspec.yaml
├── launcher.ps1
├── run_vk_branches.ps1
└── run_vk_branches_parallel.ps1
```

### Durante Ejecución Paralela:
```
d:\Personal_Projects\MultiBranchTesting\
├── palestra-app\              ← Repositorio original
│   └── ...
│
%TEMP%\flutter_branch_testing\
├── vk-1365-inscripciones\     ← Copia para branch 1
│   ├── lib\
│   └── ...
├── vk-2cdd-fix-inscirpcione\  ← Copia para branch 2
│   ├── lib\
│   └── ...
└── vk-abd7-fix-inscripcione\  ← Copia para branch 3
    ├── lib\
    └── ...
```

## Identificación de Branches

Cada app en ejecución se identifica mediante:

```
┌─────────────────────────────────────┐
│  Ventana PowerShell                 │
│  Título: "Flutter App - Branch:    │
│           vk/1365-inscripciones"    │
├─────────────────────────────────────┤
│                                     │
│  flutter run --dart-define=         │
│    BRANCH_NAME=vk/1365-inscripciones│
│                                     │
│  ↓ Dentro de la App Flutter         │
│                                     │
│  const branchName = String.from     │
│    Environment('BRANCH_NAME');      │
│                                     │
│  Text('Branch: $branchName')        │
└─────────────────────────────────────┘
```

## Branches Detectados

El sistema automáticamente detecta y procesa:

```
origin/vk/1365-inscripciones
origin/vk/2cdd-fix-inscirpcione  
origin/vk/abd7-fix-inscripcione

Total: 3 branches
```

## Flujo de Datos

```
GitHub Repository
       │
       ├─ git fetch/pull
       │
       ▼
Local Repository
       │
       ├─ git checkout <branch>
       │
       ▼
Flutter Dependencies
       │
       ├─ flutter pub get
       │
       ▼
Flutter Build System
       │
       ├─ flutter run
       │    --dart-define=BRANCH_NAME=<branch>
       │
       ▼
App Running on Device
       │
       └─ Display branch identifier
```

## Casos de Uso

### Caso 1: Testing Individual Detallado
```
Usuario → launcher.ps1 → Opción 1 (Secuencial)
       → Prueba branch 1 completamente
       → Prueba branch 2 completamente
       → Prueba branch 3 completamente
```

### Caso 2: Comparación Visual Rápida
```
Usuario → launcher.ps1 → Opción 2 (Paralelo)
       → 3 ventanas abiertas simultáneamente
       → Ver diferencias entre branches en tiempo real
```

### Caso 3: Verificación de Branch Específico
```
Usuario → cd palestra-app
       → git checkout vk/<branch-específico>
       → flutter run
```

## Ventajas del Sistema

✅ **Automatización completa**: No necesitas cambiar manualmente de branch
✅ **Identificación clara**: Cada ejecución muestra su branch
✅ **Flexibilidad**: Elige modo secuencial o paralelo
✅ **Limpieza automática**: Directorios temporales se limpian
✅ **Interfaz amigable**: Menú interactivo fácil de usar
✅ **Documentación completa**: README y QUICKSTART detallados
