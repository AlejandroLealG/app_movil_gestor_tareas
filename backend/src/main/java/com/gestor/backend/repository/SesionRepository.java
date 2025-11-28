package com.gestor.backend.repository;

import com.gestor.backend.entity.Sesion;
import com.gestor.backend.entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SesionRepository extends JpaRepository<Sesion, Long> {
    Optional<Sesion> findByToken(String token);
    void deleteByUsuario(Usuario usuario);
}

