import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  Future<void> _refreshTasks(BuildContext context) async {
    await context.read<TaskProvider>().fetchTasks();
  }

  void _openForm(BuildContext context, {Task? task}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)),
    );
  }

  void _logout(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final taskProvider = context.read<TaskProvider>();
    authProvider.logout();
    // Actualizar TaskProvider para limpiar las tareas
    taskProvider.updateAuth(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshTasks(context),
          child: Builder(
            builder: (context) {
              if (taskProvider.isLoading && !taskProvider.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (taskProvider.error != null && !taskProvider.hasData) {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            taskProvider.error!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => _refreshTasks(context),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              final tasks = taskProvider.tasks;

              if (tasks.isEmpty) {
                return ListView(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No tienes tareas registradas. Pulsa el botón "+" para añadir la primera.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    task: task,
                    onTap: () => _openForm(context, task: task),
                    onDelete: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar tarea'),
                          content: const Text('¿Estás seguro de eliminar esta tarea?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true && context.mounted) {
                        await context.read<TaskProvider>().deleteTask(task.id);
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

