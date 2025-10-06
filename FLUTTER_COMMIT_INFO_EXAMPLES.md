# 🎨 Mostrar Información del Branch y Commit en Flutter

Este archivo contiene ejemplos de código Flutter para mostrar la información del branch y commit que se está testeando.

## 📋 Variables Disponibles

Los scripts pasan las siguientes variables mediante `--dart-define`:

```dart
const String branchName = String.fromEnvironment('BRANCH_NAME', defaultValue: 'unknown');
const String commitHash = String.fromEnvironment('COMMIT_HASH', defaultValue: '');
const String commitMessage = String.fromEnvironment('COMMIT_MESSAGE', defaultValue: '');
const String commitAuthor = String.fromEnvironment('COMMIT_AUTHOR', defaultValue: '');
const String commitDate = String.fromEnvironment('COMMIT_DATE', defaultValue: '');
```

---

## ✨ Opción 1: Banner Superior Simple (Recomendado)

```dart
import 'package:flutter/material.dart';

class CommitInfoBanner extends StatelessWidget {
  static const String branchName = String.fromEnvironment('BRANCH_NAME', defaultValue: 'unknown');
  static const String commitHash = String.fromEnvironment('COMMIT_HASH', defaultValue: '');
  static const String commitMessage = String.fromEnvironment('COMMIT_MESSAGE', defaultValue: '');
  
  const CommitInfoBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Solo mostrar si hay información de branch
    if (branchName == 'unknown' || branchName.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      color: Colors.blue.shade800,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Icon(Icons.route, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    branchName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (commitMessage.isNotEmpty)
                    Text(
                      '$commitHash • ${commitMessage.length > 50 ? '${commitMessage.substring(0, 50)}...' : commitMessage}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () => _showCommitDetails(context),
              tooltip: 'Ver detalles del commit',
            ),
          ],
        ),
      ),
    );
  }

  void _showCommitDetails(BuildContext context) {
    const commitAuthor = String.fromEnvironment('COMMIT_AUTHOR', defaultValue: '');
    const commitDate = String.fromEnvironment('COMMIT_DATE', defaultValue: '');
    const commitHashFull = String.fromEnvironment('COMMIT_HASH_FULL', defaultValue: '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.commit, color: Colors.blue),
            SizedBox(width: 8),
            Text('Información del Commit'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('Branch', branchName, Icons.route),
              const SizedBox(height: 12),
              _buildInfoRow('Commit', commitHash, Icons.tag),
              if (commitHashFull.isNotEmpty && commitHashFull != commitHash)
                Padding(
                  padding: const EdgeInsets.only(left: 32, top: 4),
                  child: SelectableText(
                    commitHashFull,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              _buildInfoRow('Autor', commitAuthor, Icons.person),
              const SizedBox(height: 12),
              _buildInfoRow('Fecha', commitDate, Icons.calendar_today),
              const Divider(height: 24),
              const Text(
                'Mensaje del Commit:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SelectableText(
                  commitMessage.isNotEmpty ? commitMessage : 'Sin mensaje',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              SelectableText(
                value.isNotEmpty ? value : 'N/A',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// USO EN TU APP:
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palestra App',
      home: Scaffold(
        body: Column(
          children: [
            const CommitInfoBanner(), // ← Agrega el banner aquí
            Expanded(
              child: YourMainContent(),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ✨ Opción 2: Floating Action Button Discreto

```dart
import 'package:flutter/material.dart';

class CommitInfoFAB extends StatelessWidget {
  static const String branchName = String.fromEnvironment('BRANCH_NAME', defaultValue: 'unknown');
  
  const CommitInfoFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Solo mostrar si hay información
    if (branchName == 'unknown' || branchName.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 50,
      right: 16,
      child: FloatingActionButton.small(
        heroTag: 'commit_info',
        onPressed: () => _showCommitInfo(context),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.info, size: 20),
      ),
    );
  }

  void _showCommitInfo(BuildContext context) {
    const commitHash = String.fromEnvironment('COMMIT_HASH', defaultValue: '');
    const commitMessage = String.fromEnvironment('COMMIT_MESSAGE', defaultValue: '');
    const commitAuthor = String.fromEnvironment('COMMIT_AUTHOR', defaultValue: '');
    const commitDate = String.fromEnvironment('COMMIT_DATE', defaultValue: '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Información de Testing',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildCard(
                icon: Icons.route,
                title: 'Branch',
                content: branchName,
                color: Colors.blue,
              ),
              const SizedBox(height: 12),
              _buildCard(
                icon: Icons.commit,
                title: 'Commit',
                content: commitHash,
                color: Colors.green,
              ),
              const SizedBox(height: 12),
              _buildCard(
                icon: Icons.person,
                title: 'Autor',
                content: commitAuthor,
                color: Colors.orange,
              ),
              const SizedBox(height: 12),
              _buildCard(
                icon: Icons.calendar_today,
                title: 'Fecha',
                content: commitDate,
                color: Colors.purple,
              ),
              const SizedBox(height: 12),
              _buildCard(
                icon: Icons.message,
                title: 'Mensaje del Commit',
                content: commitMessage.isNotEmpty ? commitMessage : 'Sin mensaje',
                color: Colors.teal,
                isExpandable: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
    bool isExpandable = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            content,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: isExpandable ? null : 2,
          ),
        ],
      ),
    );
  }
}

// USO EN TU APP:
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YourMainContent(),
          const CommitInfoFAB(), // ← Agrega el FAB aquí
        ],
      ),
    );
  }
}
```

---

## ✨ Opción 3: Drawer Lateral Completo

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommitInfoDrawer extends StatelessWidget {
  static const String branchName = String.fromEnvironment('BRANCH_NAME', defaultValue: 'unknown');
  static const String commitHash = String.fromEnvironment('COMMIT_HASH', defaultValue: '');
  static const String commitMessage = String.fromEnvironment('COMMIT_MESSAGE', defaultValue: '');
  static const String commitAuthor = String.fromEnvironment('COMMIT_AUTHOR', defaultValue: '');
  static const String commitDate = String.fromEnvironment('COMMIT_DATE', defaultValue: '');
  static const String commitHashFull = String.fromEnvironment('COMMIT_HASH_FULL', defaultValue: '');

  const CommitInfoDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade700,
              Colors.deepPurple.shade900,
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.bug_report,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Información de Testing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Branch Testing Mode',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildInfoTile(
              context,
              icon: Icons.route,
              title: 'Branch',
              value: branchName,
              canCopy: true,
            ),
            _buildInfoTile(
              context,
              icon: Icons.tag,
              title: 'Commit Hash',
              value: commitHash,
              subtitle: commitHashFull.isNotEmpty ? commitHashFull : null,
              canCopy: true,
            ),
            _buildInfoTile(
              context,
              icon: Icons.person,
              title: 'Autor',
              value: commitAuthor,
            ),
            _buildInfoTile(
              context,
              icon: Icons.calendar_today,
              title: 'Fecha',
              value: commitDate,
            ),
            const Divider(color: Colors.white24, height: 32),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.message, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Mensaje del Commit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: SelectableText(
                      commitMessage.isNotEmpty 
                          ? commitMessage 
                          : 'Sin mensaje de commit',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 32),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.white),
              title: const Text(
                'Cerrar',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    bool canCopy = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 12,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value.isNotEmpty ? value : 'N/A',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 10,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ],
      ),
      trailing: canCopy && value.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.copy, color: Colors.white70, size: 18),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title copiado al portapapeles'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            )
          : null,
    );
  }
}

// USO EN TU APP:
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Palestra App'),
      ),
      drawer: const CommitInfoDrawer(), // ← Agrega el drawer aquí
      body: YourMainContent(),
    );
  }
}
```

---

## ✨ Opción 4: Bottom Banner (Siempre Visible)

```dart
import 'package:flutter/material.dart';

class CommitInfoBottomBanner extends StatelessWidget {
  static const String branchName = String.fromEnvironment('BRANCH_NAME', defaultValue: 'unknown');
  static const String commitHash = String.fromEnvironment('COMMIT_HASH', defaultValue: '');
  
  const CommitInfoBottomBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (branchName == 'unknown' || branchName.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade700, Colors.deepOrange.shade700],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            const Text(
              'TESTING: ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Flexible(
              child: Text(
                '$branchName ${commitHash.isNotEmpty ? '($commitHash)' : ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// USO EN TU APP:
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: YourMainContent()),
          const CommitInfoBottomBanner(), // ← Banner inferior
        ],
      ),
    );
  }
}
```

---

## 🎯 Implementación Recomendada (Combinación)

La mejor experiencia combina **Opción 1 (Banner Superior) + FAB para detalles**:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palestra App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Palestra App'),
      ),
      body: Column(
        children: [
          const CommitInfoBanner(), // Banner superior con info básica
          Expanded(
            child: YourMainContent(),
          ),
        ],
      ),
    );
  }
}

class YourMainContent extends StatelessWidget {
  const YourMainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tu contenido aquí'),
    );
  }
}
```

---

## 📝 Notas Importantes

1. **Solo en Modo Debug**: Puedes envolver los widgets en una condición:
   ```dart
   if (kDebugMode) const CommitInfoBanner(),
   ```

2. **Personalización**: Todos los ejemplos son personalizables en colores, tamaños y posiciones.

3. **Performance**: Los widgets son ligeros y no afectan el rendimiento.

4. **Selectabilidad**: Usa `SelectableText` para permitir copiar texto.

---

¡Elige el estilo que más te guste y personalízalo según tus necesidades! 🚀
