-- Script SQL para crear la base de datos del Gestor de Tareas Académicas
-- Base de datos: MySQL

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS gestor_tareas_academicas;
USE gestor_tareas_academicas;

-- Tabla USUARIOS
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email)
);

-- Tabla TAREAS (entidad principal)
CREATE TABLE tareas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    materia VARCHAR(100) NOT NULL,
    fecha_entrega DATE NOT NULL,
    prioridad ENUM('alta', 'media', 'baja') DEFAULT 'media',
    estado ENUM('pendiente', 'en_progreso', 'completada') DEFAULT 'pendiente',
    notas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_fecha_entrega (fecha_entrega),
    INDEX idx_estado (estado),
    INDEX idx_prioridad (prioridad)
);

-- Tabla SESIONES (opcional)
CREATE TABLE sesiones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_token (token),
    INDEX idx_usuario_id (usuario_id),
    INDEX idx_expires_at (expires_at)
);

-- Insertar datos de ejemplo para pruebas
INSERT INTO usuarios (nombre, email, usuario, password_hash) VALUES
('Juan Pérez', 'juan.perez@universidad.edu', 'juan.perez', '$2b$10$example_hash_1'),
('María García', 'maria.garcia@universidad.edu', 'maria.garcia', '$2b$10$example_hash_2'),
('Carlos López', 'carlos.lopez@universidad.edu', 'carlos.lopez', '$2b$10$example_hash_3');

INSERT INTO tareas (usuario_id, titulo, descripcion, materia, fecha_entrega, prioridad, estado) VALUES
(1, 'Proyecto Final de Programación', 'Desarrollar aplicación móvil con Flutter', 'Programación Móvil', '2024-12-15', 'alta', 'en_progreso'),
(1, 'Ensayo sobre Inteligencia Artificial', 'Redactar ensayo de 5 páginas sobre IA', 'Inteligencia Artificial', '2024-12-10', 'media', 'pendiente'),
(2, 'Presentación de Base de Datos', 'Preparar presentación sobre MySQL', 'Base de Datos', '2024-12-08', 'alta', 'completada'),
(2, 'Laboratorio de Redes', 'Configurar router y switches', 'Redes de Computadores', '2024-12-12', 'media', 'pendiente'),
(3, 'Examen de Cálculo', 'Estudiar para examen parcial', 'Cálculo Diferencial', '2024-12-05', 'alta', 'en_progreso');

-- Verificar la estructura de las tablas
DESCRIBE usuarios;
DESCRIBE tareas;
DESCRIBE sesiones;

-- Mostrar datos de ejemplo
SELECT 'USUARIOS' as tabla;
SELECT * FROM usuarios;

SELECT 'TAREAS' as tabla;
SELECT * FROM tareas;
