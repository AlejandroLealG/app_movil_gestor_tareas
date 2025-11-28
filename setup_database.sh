#!/bin/bash

# Script para configurar la base de datos MySQL
# Uso: ./setup_database.sh [usuario] [contraseña]

echo "=========================================="
echo "Configuración de Base de Datos MySQL"
echo "Gestor de Tareas Académicas"
echo "=========================================="
echo ""

# Configuración por defecto
DB_USER="${1:-root}"
DB_PASS="${2:-}"

# Verificar si MySQL está instalado
if ! command -v mysql &> /dev/null; then
    echo "❌ ERROR: MySQL no está instalado o no está en el PATH"
    echo "Por favor, instala MySQL primero"
    exit 1
fi

echo "✓ MySQL encontrado"
echo ""

# Verificar conexión
echo "Verificando conexión a MySQL..."
if [ -z "$DB_PASS" ]; then
    mysql -u "$DB_USER" -e "SELECT 1;" &> /dev/null
else
    mysql -u "$DB_USER" -p"$DB_PASS" -e "SELECT 1;" &> /dev/null
fi

if [ $? -ne 0 ]; then
    echo "❌ ERROR: No se pudo conectar a MySQL"
    echo "Verifica el usuario y contraseña"
    exit 1
fi

echo "✓ Conexión exitosa"
echo ""

# Ejecutar el script SQL
echo "Ejecutando script de creación de base de datos..."
if [ -z "$DB_PASS" ]; then
    mysql -u "$DB_USER" < database_schema.sql
else
    mysql -u "$DB_USER" -p"$DB_PASS" < database_schema.sql
fi

if [ $? -eq 0 ]; then
    echo "✓ Base de datos creada exitosamente"
    echo ""
    
    # Ejecutar script de verificación
    echo "Verificando la instalación..."
    if [ -z "$DB_PASS" ]; then
        mysql -u "$DB_USER" < verify_database.sql
    else
        mysql -u "$DB_USER" -p"$DB_PASS" < verify_database.sql
    fi
    
    echo ""
    echo "=========================================="
    echo "✓ Configuración completada"
    echo "=========================================="
    echo ""
    echo "Base de datos: gestor_tareas_academicas"
    echo "Usuario: $DB_USER"
    echo ""
    echo "Para conectarte manualmente:"
    if [ -z "$DB_PASS" ]; then
        echo "  mysql -u $DB_USER"
    else
        echo "  mysql -u $DB_USER -p"
    fi
    echo "  USE gestor_tareas_academicas;"
else
    echo "❌ ERROR: No se pudo crear la base de datos"
    exit 1
fi

