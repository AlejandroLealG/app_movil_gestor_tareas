# Base de Datos - Gestor de Tareas Académicas

## Inicio Rápido

### Opción 1: Script Automático (Recomendado)

**Windows:**
```bash
setup_database.bat
```

**Linux/Mac:**
```bash
./setup_database.sh
```

### Opción 2: Manual

1. Conéctate a MySQL:
```bash
mysql -u root -p
```

2. Ejecuta el script:
```sql
source database_schema.sql;
```

O desde la línea de comandos:
```bash
mysql -u root -p < database_schema.sql
```

### Opción 3: Docker

```bash
docker-compose up -d
```

## Verificación

Después de crear la base de datos, verifica que todo esté correcto:

```bash
mysql -u root -p < verify_database.sql
```

## Archivos Incluidos

- `database_schema.sql` - Script principal para crear la base de datos
- `verify_database.sql` - Script de verificación
- `database_setup.md` - Guía completa de instalación
- `docker-compose.yml` - Configuración Docker (opcional)
- `setup_database.sh` - Script automático para Linux/Mac
- `setup_database.bat` - Script automático para Windows

## Estructura de la Base de Datos

- **usuarios** - Información de usuarios del sistema
- **tareas** - Tareas académicas (entidad principal)
- **sesiones** - Tokens de sesión para autenticación

## Configuración para el Backend

Una vez configurada la base de datos, usa estos valores en tu `application.properties` de Spring Boot:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/gestor_tareas_academicas
spring.datasource.username=root
spring.datasource.password=tu_contraseña
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

Para más detalles, consulta `database_setup.md`.

