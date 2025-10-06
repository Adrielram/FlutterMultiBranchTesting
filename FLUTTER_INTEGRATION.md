# 🎨 Integración del Nombre del Branch en Flutter

## Cómo Mostrar el Nombre del Branch en tu App

Los scripts pasan el nombre del branch mediante `--dart-define=BRANCH_NAME=<branch>`. Aquí tienes ejemplos de cómo usarlo en tu app Flutter:

## Opción 1: Banner Simple en Modo Debug

```dart
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  // Obtener el nombre del branch de las variables de entorno
  static const String branchName = String.fromEnvironment(
    'BRANCH_NAME',
    defaultValue: 'unknown',
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palestra App',
      // Mostrar banner con el nombre del branch en modo debug
      debugShowCheckedModeBanner: true,
      // Agregar banner personalizado
      builder: (context, child) {
        return Banner(
          message: 'Branch: $branchName',
          location: BannerLocation.topEnd,
          child: child!,
        );
      },
      home: MyHomePage(),
    );
  }
}
```

## Opción 2: Overlay Persistente

```dart
import 'package:flutter/material.dart';

class BranchOverlay extends StatelessWidget {
  static const String branchName = String.fromEnvironment(
    'BRANCH_NAME',
    defaultValue: 'unknown',
  );

  final Widget child;

  const BranchOverlay({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        // Overlay en la esquina superior derecha
        Positioned(
          top: 40,
          right: 10,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.git_branch, color: Colors.amber, size: 16),
                SizedBox(width: 6),
                Text(
                  branchName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Uso en MaterialApp
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palestra App',
      builder: (context, child) {
        return BranchOverlay(child: child!);
      },
      home: MyHomePage(),
    );
  }
}
```

## Opción 3: Widget Dedicado para Información de Desarrollo

```dart
import 'package:flutter/material.dart';

class DevInfo extends StatelessWidget {
  static const String branchName = String.fromEnvironment(
    'BRANCH_NAME',
    defaultValue: 'unknown',
  );

  @override
  Widget build(BuildContext context) {
    // Solo mostrar en modo debug
    if (!const bool.fromEnvironment('dart.vm.product')) {
      return Container(
        padding: EdgeInsets.all(8),
        color: Colors.blue.withOpacity(0.8),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'DEV MODE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Branch: $branchName',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }
}

// Uso en tu página principal
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DevInfo(), // Widget de información de desarrollo
          Expanded(
            child: YourMainContent(),
          ),
        ],
      ),
    );
  }
}
```

## Opción 4: Drawer con Información Detallada

```dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DevDrawer extends StatelessWidget {
  static const String branchName = String.fromEnvironment(
    'BRANCH_NAME',
    defaultValue: 'unknown',
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Development Info',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Testing Environment',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildInfoTile(
            icon: Icons.git_branch,
            title: 'Branch',
            value: branchName,
          ),
          _buildInfoTile(
            icon: Icons.mode,
            title: 'Mode',
            value: kDebugMode ? 'Debug' : 'Release',
          ),
          _buildInfoTile(
            icon: Icons.phone_android,
            title: 'Platform',
            value: Theme.of(context).platform.toString().split('.').last,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.close),
            title: Text('Close'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}

// Uso en Scaffold
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Palestra App'),
      ),
      drawer: DevDrawer(), // Drawer con info de desarrollo
      body: YourMainContent(),
    );
  }
}
```

## Opción 5: Floating Action Button para Información

```dart
import 'package:flutter/material.dart';

class BranchInfoFAB extends StatelessWidget {
  static const String branchName = String.fromEnvironment(
    'BRANCH_NAME',
    defaultValue: 'unknown',
  );

  void _showBranchInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.git_branch, color: Colors.blue),
            SizedBox(width: 8),
            Text('Branch Information'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Branch:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Text(
                branchName,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  color: Colors.blue[900],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showBranchInfo(context),
      tooltip: 'Branch Info',
      child: Icon(Icons.info),
      mini: true,
    );
  }
}

// Uso en Scaffold
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Palestra App')),
      body: YourMainContent(),
      floatingActionButton: BranchInfoFAB(), // FAB con info del branch
    );
  }
}
```

## Opción 6: Bottom Banner

```dart
import 'package:flutter/material.dart';

class BranchBottomBanner extends StatelessWidget {
  static const String branchName = String.fromEnvironment(
    'BRANCH_NAME',
    defaultValue: 'unknown',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Testing: ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              branchName,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Uso en Scaffold
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Palestra App')),
      body: Column(
        children: [
          Expanded(child: YourMainContent()),
          BranchBottomBanner(), // Banner inferior
        ],
      ),
    );
  }
}
```

## Configuración Completa de Ejemplo

```dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String branchName = String.fromEnvironment(
    'BRANCH_NAME',
    defaultValue: 'main',
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palestra App - $branchName',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Agregar overlay solo en modo debug
      builder: (context, child) {
        if (kDebugMode && branchName != 'main') {
          return BranchOverlay(child: child!);
        }
        return child!;
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Palestra App'),
        actions: [
          // Mostrar información del branch en el AppBar
          if (kDebugMode)
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Chip(
                  avatar: Icon(Icons.git_branch, size: 16),
                  label: Text(
                    MyApp.branchName,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
        ],
      ),
      drawer: DevDrawer(),
      body: YourMainContent(),
      floatingActionButton: kDebugMode ? BranchInfoFAB() : null,
    );
  }
}

class YourMainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Your app content here'),
    );
  }
}
```

## Testing del Branch Name

Para probar que funciona correctamente:

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Branch name is set correctly', () {
    const branchName = String.fromEnvironment('BRANCH_NAME');
    
    // En testing sin definir, debería ser vacío
    expect(branchName, isNotEmpty);
    
    print('Current branch: $branchName');
  });
}
```

## Recomendaciones

1. **Solo en Debug**: Muestra el branch name solo en modo debug
2. **No Intrusivo**: No debe interferir con la funcionalidad de la app
3. **Visible**: Debe ser fácilmente visible para identificar qué branch estás probando
4. **Opcional**: Considera hacer que sea fácil de ocultar/mostrar

## Elige Tu Opción

- **Opción 1** (Banner): Simple, estándar de Flutter
- **Opción 2** (Overlay): Siempre visible, no intrusivo
- **Opción 3** (DevInfo): Información completa en la parte superior
- **Opción 4** (Drawer): Para información detallada cuando la necesites
- **Opción 5** (FAB): Acceso rápido pero discreto
- **Opción 6** (Bottom Banner): Muy visible pero en la parte inferior
