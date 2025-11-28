package com.gestor.backend.service;

import com.gestor.backend.dto.LoginRequest;
import com.gestor.backend.dto.RegisterRequest;
import com.gestor.backend.entity.Sesion;
import com.gestor.backend.entity.Usuario;
import com.gestor.backend.repository.SesionRepository;
import com.gestor.backend.repository.UsuarioRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Service
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final SesionRepository sesionRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthService(UsuarioRepository usuarioRepository,
                       SesionRepository sesionRepository,
                       PasswordEncoder passwordEncoder) {
        this.usuarioRepository = usuarioRepository;
        this.sesionRepository = sesionRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public Usuario register(RegisterRequest request) {
        if (usuarioRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("El email ya está registrado");
        }
        if (usuarioRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("El nombre de usuario ya está en uso");
        }

        Usuario usuario = new Usuario();
        usuario.setNombre(request.getNombre());
        usuario.setEmail(request.getEmail().toLowerCase());
        usuario.setUsername(request.getUsername().toLowerCase());
        usuario.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        return usuarioRepository.save(usuario);
    }

    @Transactional
    public String login(LoginRequest request) {
        Optional<Usuario> usuarioOpt = usuarioRepository.findByEmail(request.getUsernameOrEmail().toLowerCase());
        if (usuarioOpt.isEmpty()) {
            usuarioOpt = usuarioRepository.findByUsername(request.getUsernameOrEmail().toLowerCase());
        }

        Usuario usuario = usuarioOpt.orElseThrow(() -> new IllegalArgumentException("Credenciales inválidas"));

        if (!passwordEncoder.matches(request.getPassword(), usuario.getPasswordHash())) {
            throw new IllegalArgumentException("Credenciales inválidas");
        }

        sesionRepository.deleteByUsuario(usuario);

        Sesion sesion = new Sesion();
        sesion.setUsuario(usuario);
        sesion.setToken(UUID.randomUUID().toString());
        sesion.setExpiresAt(LocalDateTime.now().plusHours(12));
        sesionRepository.save(sesion);
        return sesion.getToken();
    }

    public Usuario authenticate(String token) {
        if (token == null || token.isBlank()) {
            throw new IllegalArgumentException("Token de autenticación requerido");
        }

        Sesion sesion = sesionRepository.findByToken(token)
                .orElseThrow(() -> new IllegalArgumentException("Token inválido"));

        if (sesion.getExpiresAt().isBefore(LocalDateTime.now())) {
            sesionRepository.delete(sesion);
            throw new IllegalArgumentException("Token expirado");
        }

        return sesion.getUsuario();
    }
}

