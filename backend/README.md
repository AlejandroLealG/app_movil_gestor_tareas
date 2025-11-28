## Backend - Gestor de Tareas Académicas

### Requisitos
- Java 17+ (el proyecto se generó con Spring Boot 4 / Java 17)
- Maven Wrapper incluido (`./mvnw`)
- Base de datos MySQL corriendo con el schema `gestor_tareas_academicas`

### Variables de conexión (archivo `src/main/resources/application.properties`)
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/gestor_tareas_academicas
spring.datasource.username=root
spring.datasource.password=admin
```
Modifica `username` y `password` si usas otro usuario.

### Ejecución
```bash
cd backend
./mvnw spring-boot:run
```
En Windows también puedes usar `mvnw.cmd spring-boot:run`.

### Endpoint disponible
- `GET http://localhost:8080/api/health` → Devuelve estadísticas básicas de la base de datos (conteo de usuarios, tareas y sesiones). Sirve para validar que la conexión a MySQL está funcionando.

### Pruebas
```bash
./mvnw test
```

### Próximos pasos
1. Implementar DTOs y servicios para registro/login.
2. Exponer CRUD completo de tareas.
3. Añadir pruebas unitarias/integración para los endpoints.

