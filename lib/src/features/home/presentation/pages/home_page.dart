import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Inventario'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  // TODO: Implementar perfil de usuario
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Perfil de usuario'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  break;
                case 'settings':
                  // TODO: Implementar configuración
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Configuración del sistema'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  break;
                case 'help':
                  // TODO: Implementar ayuda
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Centro de ayuda'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  break;
                case 'logout':
                  // TODO: Implementar lógica de cierre de sesión
                  Navigator.pushReplacementNamed(context, '/login');
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Mi Perfil'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Configuración'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Ayuda'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Cerrar Sesión'),
                  ],
                ),
              ),
            ],
            icon: const CircleAvatar(child: Icon(Icons.person_outline)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _MenuCard(
              icon: Icons.inventory_2,
              title: 'Productos',
              subtitle: 'Gestionar inventario',
              color: Colors.blue,
              onTap: () => Navigator.pushNamed(context, '/inventory'),
            ),
            _MenuCard(
              icon: Icons.store,
              title: 'Tiendas',
              subtitle: 'Gestionar tiendas',
              color: Colors.green,
              onTap: () => Navigator.pushNamed(context, '/stores'),
            ),
            _MenuCard(
              icon: Icons.warehouse,
              title: 'Almacenes',
              subtitle: 'Gestionar almacenes',
              color: Colors.orange,
              onTap: () => Navigator.pushNamed(context, '/warehouses'),
            ),
            _MenuCard(
              icon: Icons.shopping_cart,
              title: 'Ventas',
              subtitle: 'Registrar ventas',
              color: Colors.purple,
              onTap: () => Navigator.pushNamed(context, '/sales'),
            ),
            _MenuCard(
              icon: Icons.shopping_bag,
              title: 'Compras',
              subtitle: 'Registrar compras',
              color: Colors.teal,
              onTap: () => Navigator.pushNamed(context, '/purchases'),
            ),
            _MenuCard(
              icon: Icons.swap_horiz,
              title: 'Transferencias',
              subtitle: 'Transferir entre ubicaciones',
              color: Colors.indigo,
              onTap: () => Navigator.pushNamed(context, '/transfers'),
            ),
            _MenuCard(
              icon: Icons.people,
              title: 'Empleados',
              subtitle: 'Gestionar empleados',
              color: Colors.cyan,
              onTap: () => Navigator.pushNamed(context, '/employees'),
            ),
            _MenuCard(
              icon: Icons.assessment,
              title: 'Reportes',
              subtitle: 'Ver reportes y estadísticas',
              color: Colors.red,
              onTap: () => Navigator.pushNamed(context, '/reports'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
