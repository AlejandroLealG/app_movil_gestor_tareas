package com.gestor.backend.service;

import com.gestor.backend.repository.SesionRepository;
import com.gestor.backend.repository.TareaRepository;
import com.gestor.backend.repository.UsuarioRepository;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class DatabaseHealthService {

    private final UsuarioRepository usuarioRepository;
    private final TareaRepository tareaRepository;
    private final SesionRepository sesionRepository;

    public DatabaseHealthService(UsuarioRepository usuarioRepository,
                                 TareaRepository tareaRepository,
                                 SesionRepository sesionRepository) {
        this.usuarioRepository = usuarioRepository;
        this.tareaRepository = tareaRepository;
        this.sesionRepository = sesionRepository;
    }

    public Map<String, Object> getStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("usuarios", usuarioRepository.count());
        stats.put("tareas", tareaRepository.count());
        stats.put("sesiones", sesionRepository.count());
        stats.put("status", "OK");
        return stats;
    }
}

