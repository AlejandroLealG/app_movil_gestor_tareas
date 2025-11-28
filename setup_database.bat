@echo off
REM Script para configurar la base de datos MySQL en Windows
REM Uso: setup_database.bat [usuario] [contraseña]

echo ==========================================
echo Configuracion de Base de Datos MySQL
echo Gestor de Tareas Academicas
echo ==========================================
echo.

REM Configuración por defecto
set DB_USER=%1
if "%DB_USER%"=="" set DB_USER=root
set DB_PASS=%2

REM Verificar si MySQL está instalado
where mysql >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: MySQL no esta instalado o no esta en el PATH
    echo Por favor, instala MySQL primero
    exit /b 1
)

echo MySQL encontrado
echo.

REM Verificar conexión
echo Verificando conexion a MySQL...
if "%DB_PASS%"=="" (
    mysql -u %DB_USER% -e "SELECT 1;" >nul 2>&1
) else (
    mysql -u %DB_USER% -p%DB_PASS% -e "SELECT 1;" >nul 2>&1
)

if %errorlevel% neq 0 (
    echo ERROR: No se pudo conectar a MySQL
    echo Verifica el usuario y contrasena
    exit /b 1
)

echo Conexion exitosa
echo.

REM Ejecutar el script SQL
echo Ejecutando script de creacion de base de datos...
if "%DB_PASS%"=="" (
    mysql -u %DB_USER% < database_schema.sql
) else (
    mysql -u %DB_USER% -p%DB_PASS% < database_schema.sql
)

if %errorlevel% equ 0 (
    echo Base de datos creada exitosamente
    echo.
    
    REM Ejecutar script de verificación
    echo Verificando la instalacion...
    if "%DB_PASS%"=="" (
        mysql -u %DB_USER% < verify_database.sql
    ) else (
        mysql -u %DB_USER% -p%DB_PASS% < verify_database.sql
    )
    
    echo.
    echo ==========================================
    echo Configuracion completada
    echo ==========================================
    echo.
    echo Base de datos: gestor_tareas_academicas
    echo Usuario: %DB_USER%
    echo.
    echo Para conectarte manualmente:
    if "%DB_PASS%"=="" (
        echo   mysql -u %DB_USER%
    ) else (
        echo   mysql -u %DB_USER% -p
    )
    echo   USE gestor_tareas_academicas;
) else (
    echo ERROR: No se pudo crear la base de datos
    exit /b 1
)

pause

