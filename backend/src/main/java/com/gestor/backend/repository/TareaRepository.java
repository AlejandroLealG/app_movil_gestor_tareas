package com.gestor.backend.repository;

import com.gestor.backend.entity.Tarea;
import com.gestor.backend.entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface TareaRepository extends JpaRepository<Tarea, Long> {
    List<Tarea> findByUsuario(Usuario usuario);
    List<Tarea> findByUsuarioAndFechaEntregaBetween(Usuario usuario, LocalDate start, LocalDate end);
}

