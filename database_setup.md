# Guía de Configuración de la Base de Datos

Esta guía te ayudará a configurar la base de datos MySQL para el Gestor de Tareas Académicas.

## Requisitos Previos

- MySQL Server instalado (versión 5.7 o superior, o MySQL 8.0+)
- Acceso de administrador a MySQL (usuario root o usuario con permisos de creación de bases de datos)

## Opción 1: Instalación Manual (Recomendada)

### Paso 1: Verificar que MySQL esté instalado

**Windows:**
```bash
mysql --version
```

**Linux/Mac:**
```bash
mysql --version
# o
mysql -V
```

Si no está instalado, descarga MySQL desde: https://dev.mysql.com/downloads/mysql/

### Paso 2: Iniciar el servicio MySQL

**Windows:**
- Abre "Servicios" (services.msc) y busca "MySQL80" o similar
- Asegúrate de que esté en estado "En ejecución"
- O desde la línea de comandos:
```bash
net start MySQL80
```

**Linux:**
```bash
sudo systemctl start mysql
# o
sudo service mysql start
```

**Mac:**
```bash
brew services start mysql
# o si usas MySQL directamente:
sudo /usr/local/mysql/support-files/mysql.server start
```

### Paso 3: Conectarse a MySQL

```bash
mysql -u root -p
```

Ingresa la contraseña del usuario root cuando se solicite.

### Paso 4: Ejecutar el script SQL

Una vez conectado a MySQL, ejecuta el script:

```sql
source database_schema.sql;
```

O desde la línea de comandos directamente:

```bash
mysql -u root -p < database_schema.sql
```

### Paso 5: Verificar la instalación

Conéctate a la base de datos y verifica las tablas:

```sql
USE gestor_tareas_academicas;
SHOW TABLES;
DESCRIBE usuarios;
DESCRIBE tareas;
DESCRIBE sesiones;
```

Deberías ver las tres tablas: `usuarios`, `tareas`, y `sesiones`.

### Paso 6: Verificar los datos de ejemplo

```sql
SELECT * FROM usuarios;
SELECT * FROM tareas;
```

## Opción 2: Usando Docker (Opcional)

Si prefieres usar Docker para tener un entorno aislado, puedes usar el archivo `docker-compose.yml` incluido.

### Requisitos:
- Docker Desktop instalado
- Docker Compose instalado

### Pasos:

1. Asegúrate de estar en el directorio raíz del proyecto
2. Ejecuta:
```bash
docker-compose up -d
```

Esto creará un contenedor MySQL con la base de datos configurada automáticamente.

3. Para detener el contenedor:
```bash
docker-compose down
```

4. Para ver los logs:
```bash
docker-compose logs mysql
```

## Configuración de Conexión

Una vez que la base de datos esté configurada, necesitarás estos datos para conectar desde el backend:

### Configuración Local (Sin Docker):
- **Host:** `localhost` o `127.0.0.1`
- **Puerto:** `3306` (puerto por defecto de MySQL)
- **Base de datos:** `gestor_tareas_academicas`
- **Usuario:** `root` (o el usuario que hayas configurado)
- **Contraseña:** La contraseña que configuraste para MySQL

### Configuración con Docker:
- **Host:** `localhost` o `127.0.0.1`
- **Puerto:** `3307` (configurado en docker-compose.yml para evitar conflictos)
- **Base de datos:** `gestor_tareas_academicas`
- **Usuario:** `gestor_user`
- **Contraseña:** `gestor_password`

## Crear un Usuario Dedicado (Recomendado para Producción)

Para mayor seguridad, es recomendable crear un usuario específico para la aplicación:

```sql
CREATE USER 'gestor_user'@'localhost' IDENTIFIED BY 'tu_contraseña_segura';
GRANT ALL PRIVILEGES ON gestor_tareas_academicas.* TO 'gestor_user'@'localhost';
FLUSH PRIVILEGES;
```

## Solución de Problemas

### Error: "Access denied for user"
- Verifica que estés usando el usuario y contraseña correctos
- Asegúrate de tener permisos para crear bases de datos

### Error: "Can't connect to MySQL server"
- Verifica que el servicio MySQL esté ejecutándose
- En Windows, verifica en "Servicios"
- En Linux, usa: `sudo systemctl status mysql`

### Error: "Table already exists"
- Si quieres recrear la base de datos, primero elimínala:
```sql
DROP DATABASE IF EXISTS gestor_tareas_academicas;
```
Luego ejecuta nuevamente el script `database_schema.sql`

### Error: "Unknown database"
- Asegúrate de ejecutar el script completo, incluyendo la línea `CREATE DATABASE`

## Próximos Pasos

Una vez que la base de datos esté configurada, puedes:

1. Configurar el backend Spring Boot para conectarse a la base de datos
2. Probar la conexión desde el backend
3. Comenzar a desarrollar los endpoints de la API

## Notas Importantes

- Los datos de ejemplo incluidos tienen contraseñas de ejemplo. **NO uses estas contraseñas en producción**
- El campo `password_hash` en los usuarios de ejemplo contiene valores de ejemplo. En producción, estos deben ser hashes bcrypt reales
- La tabla `sesiones` es opcional pero recomendada para manejar tokens de autenticación

