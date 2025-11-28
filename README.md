# Proyecto Final - Aplicación Móvil Cliente/Servidor

## Objetivo General

Desarrollar una aplicación móvil cliente/servidor orientada al usuario común, que permita el registro e inicio de sesión y la gestión básica (crear, ver, editar y eliminar) de una entidad principal relacionada con una temática de interés.

El proyecto debe incluir una aplicación móvil nativa o multiplataforma no híbrida y un backend con base de datos relacional. La conexión entre ambos componentes se podrá realizar directamente en red local o mediante herramientas de túnel (LocalTunnel, ngrok, Expose o similares).

## Estructura General

### 1. Aplicación Móvil (Frontend)

**Tecnología seleccionada:** Flutter (Dart)

**Características:**
- Debe ser nativa o multiplataforma compilada a código nativo, no híbrida
- Conectarse al backend mediante servicios REST (formato JSON)
- Presentar al menos tres pantallas:
  - Registro e inicio de sesión
  - Lista de elementos
  - Detalle o formulario de creación o edición

**Opciones permitidas:**
- Android (Java o Kotlin)
- iOS (Swift o SwiftUI)
- Jetpack Compose Multiplatform (JCM)
- Flutter (Dart) ✅ **SELECCIONADO**

### 2. Backend (Servidor)

**Opciones permitidas:**
- PHP (Slim o Laravel)
- Node.js (Express)
- Java (Spring Boot) ✅ **SELECCIONADO**
- Swift (Vapor)

**Características requeridas:**
- Endpoints REST para registro, inicio de sesión y CRUD de una entidad principal
- Validación básica de datos en el servidor
- Persistencia en una base de datos relacional
- Conexión mediante red local o herramientas de túnel (LocalTunnel, ngrok, Expose)

**Nota:** No se requiere implementar roles, paneles de administración ni autenticación avanzada.

### 3. Base de Datos Relacional

**Opciones permitidas:**
- MySQL ✅ **SELECCIONADO**
- MariaDB
- PostgreSQL
- Oracle
- SQL Server

**Estructura requerida:**
- Al menos tres tablas relacionadas:
  - `usuarios`
  - `sesiones` o `tokens` (opcional)
  - `entidad principal` (tareas académicas)

### 4. Conexión entre App y Backend

**Método seleccionado:** Configuración local

**Opciones disponibles:**
- Configurar el backend en la misma red local y usar la dirección IP del equipo
- Exponer el servicio mediante herramientas como LocalTunnel, ngrok o Expose

**Implementación:** Configuración local con pruebas en dispositivo móvil conectado al computador

### 5. Opciones de Despliegue

**Método seleccionado:** Opción A - Sin contenedores (entorno local directo)

**Opciones disponibles:**
- **Opción A:** Sin contenedores (entorno local directo) ✅ **SELECCIONADO**
- **Opción B:** Con contenedores mediante Docker Compose o Podman Compose
- **Opción C:** Con Podman, kind y kubectl

## Temática del Proyecto

**Temática seleccionada:** Gestor de tareas académicas

**Temáticas sugeridas disponibles:**
- Gestión de eventos académicos
- Citas médicas universitarias
- Turismo local
- Control de asistencia
- Gestor de tareas académicas ✅ **SELECCIONADO**
- Voluntariado universitario
- Inventario de laboratorios
- Registro de actividad física
- Aplicación tipo Rappi (pedidos y entregas)
- Aplicación de rastreo de encomiendas

## Funcionalidades Mínimas Requeridas

### Registro de Usuario
- Validación básica de campos
- Contraseña cifrada (bcrypt o equivalente)

### Inicio de Sesión
- Validación de credenciales
- Manejo de sesión o token simple

### Gestión Principal (CRUD)
- Crear, listar, editar y eliminar registros de la entidad principal
- Interfaz móvil funcional con mínimo tres pantallas conectadas al backend

## Tecnologías a Utilizar

- **Frontend:** Flutter (Dart) ✅
- **Backend:** Java (Spring Boot) ✅
- **Base de datos:** MySQL ✅
- **Comunicación:** REST API (JSON)
- **Túnel:** LocalTunnel, ngrok, Expose o similar

## Endpoints Mínimos Requeridos

```
POST   /api/register
POST   /api/login
GET    /api/items
POST   /api/items
PUT    /api/items/{id}
DELETE /api/items/{id}
```

## Calendario de Entregables

| Semana | Entregable | Descripción |
|--------|------------|-------------|
| 1 | Diseño y modelo entidad-relación | Boceto de pantallas y estructura de base de datos |
| 2 | Backend y base de datos funcional | API REST con endpoints básicos |
| 3 | Aplicación móvil conectada al backend | Registro, inicio de sesión y CRUD funcional |
| 4 | Pruebas, documentación y demostración final | Presentación o video del sistema completo |

## Estado del Proyecto

- [x] Diseño y modelo entidad-relación ✅ **COMPLETADO**
- [ ] Configuración inicial del proyecto Flutter
- [ ] Desarrollo del backend (Spring Boot)
- [ ] Implementación de la autenticación
- [ ] Desarrollo de las pantallas principales
- [ ] Integración frontend-backend
- [ ] Pruebas en dispositivo móvil
- [ ] Documentación final

## Documentación de Diseño

- **[Diagrama Entidad-Relación](database_design.md)** - Estructura de la base de datos MySQL
- **[Script SQL](database_schema.sql)** - Script para crear las tablas y datos de ejemplo
- **[Bocetos de Pantallas](screen_mockups.md)** - Diseño de las 3 pantallas principales

## Configuración de Conexión

**Método:** Configuración local
**URLs de prueba:** Por definir (se documentarán las URLs de prueba una vez configurado el backend)

---

*Documento creado para el proyecto final de la materia de Aplicaciones Móviles*
