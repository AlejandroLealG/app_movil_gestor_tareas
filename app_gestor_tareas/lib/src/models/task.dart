import 'package:intl/intl.dart';

class Task {
  Task({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.materia,
    required this.fechaEntrega,
    required this.prioridad,
    required this.estado,
    required this.notas,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String titulo;
  final String? descripcion;
  final String materia;
  final DateTime fechaEntrega;
  final String prioridad;
  final String estado;
  final String? notas;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Task.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? value) =>
        value == null ? null : DateTime.tryParse(value);

    return Task(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String?,
      materia: json['materia'] as String,
      fechaEntrega: DateTime.parse(json['fechaEntrega'] as String),
      prioridad: json['prioridad'] as String,
      estado: json['estado'] as String,
      notas: json['notas'] as String?,
      createdAt: parseDate(json['createdAt'] as String?),
      updatedAt: parseDate(json['updatedAt'] as String?),
    );
  }

  String get formattedDate => DateFormat('dd/MM/yyyy').format(fechaEntrega);
}

class TaskPayload {
  TaskPayload({
    required this.titulo,
    required this.descripcion,
    required this.materia,
    required this.fechaEntrega,
    required this.prioridad,
    required this.estado,
    required this.notas,
  });

  final String titulo;
  final String? descripcion;
  final String materia;
  final DateTime fechaEntrega;
  final String prioridad;
  final String estado;
  final String? notas;

  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'descripcion': descripcion,
        'materia': materia,
        'fechaEntrega': DateFormat('yyyy-MM-dd').format(fechaEntrega),
        'prioridad': prioridad,
        'estado': estado,
        'notas': notas,
      };
}

