# 🚀 Ver Información de Branch INMEDIATAMENTE

Si ejecutaste el launcher y **NO ves información** del branch y commit, es porque necesitas agregar el código a tu app Flutter.

---

## ⚡ Solución ULTRA RÁPIDA (2 minutos)

### Paso 1: Abre tu archivo `lib/main.dart`

### Paso 2: Agrega este código AL INICIO del build de tu MaterialApp

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AGREGAR ESTAS VARIABLES ↓
    const String branchName = String.fromEnvironment('BRANCH_NAME', defaultValue: 'No Info');
    const String commitHash = String.fromEnvironment('COMMIT_HASH', defaultValue: '');
    
    return MaterialApp(
      title: 'Palestra App',
      home: Scaffold(
        // AGREGAR ESTE BANNER ↓
        body: Column(
          children: [
            // ← BANNER SIMPLE - COPIA DESDE AQUÍ
            if (branchName != 'No Info')
              Container(
                width: double.infinity,
                color: Colors.blue.shade700,
                padding: const EdgeInsets.all(8),
                child: SafeArea(
                  bottom: false,
                  child: Text(
                    '🔵 Branch: $branchName ${commitHash.isNotEmpty ? "• $commitHash" : ""}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            // ← HASTA AQUÍ
            
            // Tu contenido existente aquí
            Expanded(
              child: YourExistingContent(), // Reemplaza con tu widget
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎯 Ejemplo Aún MÁS Simple

Si no quieres modificar tu estructura, solo agrega esto en CUALQUIER parte visible:

```dart
// En cualquier widget de tu app
const String branch = String.fromEnvironment('BRANCH_NAME', defaultValue: '');

// En el build:
Text('Branch actual: $branch')
```

---

## 📱 Resultado

Después de agregar el código, cuando ejecutes con el launcher verás:

```
🔵 Branch: vk/1365-inscripciones • a3b7f9e
```

---

## 🎨 Más Opciones Elegantes

Si quieres opciones más bonitas y completas (con modal, drawer, FAB, etc.), consulta:

📄 **`FLUTTER_COMMIT_INFO_EXAMPLES.md`**

Contiene 4 opciones completas y elegantes listas para copiar y pegar.

---

## ❓ Preguntas Frecuentes

**P: ¿Por qué no veo la información?**
R: Porque las variables `--dart-define` solo están disponibles si las usas en el código Flutter. No aparecen automáticamente.

**P: ¿Dónde exactamente pongo el código?**
R: En el widget principal de tu app, típicamente en `lib/main.dart` dentro del `Scaffold` o como parte de tu `AppBar`.

**P: ¿Funciona con mi app existente?**
R: ¡Sí! Solo agrega el código sin modificar nada más.

**P: ¿Puedo personalizarlo?**
R: ¡Por supuesto! Cambia colores, posición, estilo como quieras.

---

## 🔍 Verificar que las Variables Están Disponibles

Para asegurarte de que las variables llegan, agrega esto temporalmente:

```dart
void main() {
  const String branch = String.fromEnvironment('BRANCH_NAME', defaultValue: 'NO_BRANCH');
  print('🔍 Branch recibida: $branch');
  
  runApp(const MyApp());
}
```

Luego mira la consola cuando ejecutes la app. Deberías ver:
```
🔍 Branch recibida: vk/1365-inscripciones
```

---

## ✅ Checklist

- [ ] Abrí `lib/main.dart`
- [ ] Agregué las variables `const String branchName = String.fromEnvironment('BRANCH_NAME'...`
- [ ] Agregué el widget para mostrar la información
- [ ] Ejecuté la app con `.\launcher.ps1` opción [6]
- [ ] ¡Veo la información del branch en la app! 🎉

---

## 🆘 Si Aún No Funciona

1. **Verifica** que el script mostró la información en consola
2. **Asegúrate** de que agregaste el código en un lugar visible
3. **Reinicia** la app (hot reload no siempre funciona con `--dart-define`)
4. **Verifica** que usaste exactamente `'BRANCH_NAME'` (case sensitive)

---

¡Ahora ejecuta el launcher y verás la información! 🚀
