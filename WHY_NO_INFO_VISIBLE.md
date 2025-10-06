# ℹ️ Información Importante sobre la Visualización del Branch

## 🔍 ¿Por Qué No Veo la Información?

Cuando ejecutas el launcher y seleccionas una branch, verás la información **EN LA CONSOLA**:

```
============================================================
              INFORMACION DEL COMMIT                        
============================================================
Branch:   vk/1365-inscripciones
Commit:   a3b7f9e
Autor:    Adrian Ram <adrian@example.com>
Fecha:    2025-10-06 14:23:45 (2 hours ago)
============================================================
```

**PERO** para ver esta información **DENTRO DE LA APP FLUTTER**, necesitas agregar código a tu app.

---

## ✅ Solución en 3 Pasos

### 1️⃣ La Información SE ESTÁ PASANDO a Flutter

El sistema **SÍ está funcionando**. Los scripts pasan la información mediante:

```powershell
flutter run --dart-define=BRANCH_NAME=vk/1365-inscripciones --dart-define=COMMIT_HASH=a3b7f9e ...
```

### 2️⃣ Flutter RECIBE la Información

Tu app Flutter **tiene acceso** a estas variables:
- `BRANCH_NAME`
- `COMMIT_HASH`
- `COMMIT_MESSAGE`
- `COMMIT_AUTHOR`
- `COMMIT_DATE`

### 3️⃣ Necesitas MOSTRAR la Información

Para ver los datos en la app, agrega este código simple:

```dart
// En tu lib/main.dart
const String branch = String.fromEnvironment('BRANCH_NAME', defaultValue: '');

// Luego muéstralo en algún lugar:
Text('Branch: $branch')
```

---

## 🚀 Guía Rápida

**VE A ESTE ARCHIVO:**

📄 **[FLUTTER_QUICKSTART_INFO.md](FLUTTER_QUICKSTART_INFO.md)**

Contiene:
- ✅ Código listo para copiar y pegar
- ✅ Ejemplo ultra simple (2 minutos)
- ✅ Instrucciones paso a paso
- ✅ Sin necesidad de modificar tu app existente

---

## 🎨 Opciones Avanzadas

Si quieres una presentación más elegante:

📄 **[FLUTTER_COMMIT_INFO_EXAMPLES.md](FLUTTER_COMMIT_INFO_EXAMPLES.md)**

Contiene 4 opciones completas:
1. Banner superior con modal
2. Floating Action Button con bottom sheet
3. Drawer lateral completo
4. Bottom banner siempre visible

---

## 📊 Comparación

| Dónde | ¿Se ve? | ¿Qué hacer? |
|-------|---------|-------------|
| **Consola PowerShell** | ✅ SÍ | Nada, ya funciona |
| **App Flutter** | ❌ NO (por defecto) | Agregar código al app |

---

## 🔧 ¿Cómo Verificar que Funciona?

### En la Consola:
```powershell
.\launcher.ps1
# Opción [6]
# Selecciona un branch
# ↓ DEBERÍAS VER:
# ============================================================
#               INFORMACION DEL COMMIT
# Branch:   vk/1365-inscripciones
# Commit:   a3b7f9e
# ...
```

### En la App Flutter:
```dart
// Agrega esto temporalmente en main():
void main() {
  const String test = String.fromEnvironment('BRANCH_NAME', defaultValue: 'NO RECIBIDO');
  print('🔍 Branch info: $test');
  runApp(MyApp());
}

// Ejecuta la app y mira la consola:
// Deberías ver: 🔍 Branch info: vk/1365-inscripciones
```

---

## ✨ Resumen

1. ✅ **El sistema FUNCIONA** - La info se está pasando correctamente
2. ✅ **La consola MUESTRA** - Ves toda la información en PowerShell
3. ❌ **La app NO muestra** - Porque no has agregado el código para mostrarla
4. 🚀 **Solución**: Agregar un simple `Text('Branch: ${String.fromEnvironment('BRANCH_NAME')}')`

---

## 📖 Siguiente Paso

👉 **Abre**: [FLUTTER_QUICKSTART_INFO.md](FLUTTER_QUICKSTART_INFO.md)

Copia el código simple y verás la información en tu app en menos de 2 minutos! 🎉
