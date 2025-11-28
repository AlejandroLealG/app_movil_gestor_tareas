import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key, this.task});

  final Task? task;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _materiaController = TextEditingController();
  final _notasController = TextEditingController();

  DateTime? _fechaEntrega;
  String _prioridad = 'media';
  String _estado = 'pendiente';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    if (task != null) {
      _tituloController.text = task.titulo;
      _descripcionController.text = task.descripcion ?? '';
      _materiaController.text = task.materia;
      _notasController.text = task.notas ?? '';
      _fechaEntrega = task.fechaEntrega;
      _prioridad = task.prioridad;
      _estado = task.estado;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _materiaController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initialDate = _fechaEntrega ?? now;
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (selected != null) {
      setState(() => _fechaEntrega = selected);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _fechaEntrega == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos obligatorios')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final payload = TaskPayload(
      titulo: _tituloController.text.trim(),
      descripcion: _descripcionController.text.trim().isEmpty
          ? null
          : _descripcionController.text.trim(),
      materia: _materiaController.text.trim(),
      fechaEntrega: _fechaEntrega!,
      prioridad: _prioridad,
      estado: _estado,
      notas: _notasController.text.trim().isEmpty ? null : _notasController.text.trim(),
    );

    final taskProvider = context.read<TaskProvider>();
    final isEditing = widget.task != null;

    final success = isEditing
        ? await taskProvider.updateTask(widget.task!.id, payload)
        : await taskProvider.createTask(payload);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.of(context).pop();
    } else if (taskProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(taskProvider.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar tarea' : 'Nueva tarea'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    prefixIcon: Icon(Icons.title),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Campo obligatorio' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descripcionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    prefixIcon: Icon(Icons.description_outlined),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _materiaController,
                  decoration: const InputDecoration(
                    labelText: 'Materia',
                    prefixIcon: Icon(Icons.school),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Campo obligatorio' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          _fechaEntrega == null
                              ? 'Fecha de entrega'
                              : '${_fechaEntrega!.day}/${_fechaEntrega!.month}/${_fechaEntrega!.year}',
                        ),
                        onPressed: _pickDate,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _prioridad,
                        decoration: const InputDecoration(
                          labelText: 'Prioridad',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'alta', child: Text('Alta')),
                          DropdownMenuItem(value: 'media', child: Text('Media')),
                          DropdownMenuItem(value: 'baja', child: Text('Baja')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _prioridad = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _estado,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'pendiente', child: Text('Pendiente')),
                    DropdownMenuItem(value: 'en_progreso', child: Text('En progreso')),
                    DropdownMenuItem(value: 'completada', child: Text('Completada')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _estado = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notasController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Notas (opcional)',
                    prefixIcon: Icon(Icons.note_outlined),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            isEditing ? 'Guardar cambios' : 'Crear tarea',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

