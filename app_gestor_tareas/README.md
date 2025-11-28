# App Gestor de Tareas

Aplicación Flutter que consume el backend Spring Boot del Gestor de Tareas Académicas.

## Configuración rápida
1. Asegúrate de que el backend esté corriendo en `http://localhost:8081` (o ajusta la URL en `lib/src/config/api_config.dart`).
2. Instala dependencias:
   ```bash
   flutter pub get
   ```
3. Ejecuta la app:
   ```bash
   flutter run
   ```
   - En emulador Android se usa `http://10.0.2.2:8081/api`.
   - Puedes sobrescribir la URL en tiempo de ejecución:
     ```bash
     flutter run --dart-define=API_BASE_URL=http://192.168.0.50:8081/api
     ```

## Funcionalidades
- Registro e inicio de sesión contra el backend.
- Gestión completa de tareas (listar, crear, editar, eliminar).
- Estado global con `provider` y manejo de tokens en memoria.
- Indicadores de prioridad, estado y fecha de entrega.

## Arquitectura
- `lib/main.dart`: registra `AuthProvider` y `TaskProvider` y arranca la app.
- `lib/src/services/api_service.dart`: cliente HTTP centralizado.
- `lib/src/screens/`: pantallas de login, registro, lista y formulario.
- `lib/src/widgets/task_card.dart`: componente reutilizable para mostrar cada tarea.

## Calidad
```bash
flutter analyze
```

## Próximos pasos sugeridos
- Guardar el token de sesión en almacenamiento seguro.
- Añadir filtros/búsquedas y notificaciones locales.
- Agregar pruebas widget/integración y automatizar builds.
