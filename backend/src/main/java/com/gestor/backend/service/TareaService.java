package com.gestor.backend.service;

import com.gestor.backend.dto.TareaRequest;
import com.gestor.backend.dto.TareaResponse;
import com.gestor.backend.entity.Tarea;
import com.gestor.backend.entity.Usuario;
import com.gestor.backend.repository.TareaRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class TareaService {

    private final TareaRepository tareaRepository;

    public TareaService(TareaRepository tareaRepository) {
        this.tareaRepository = tareaRepository;
    }

    public List<TareaResponse> listByUsuario(Usuario usuario) {
        return tareaRepository.findByUsuario(usuario)
                .stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public TareaResponse create(Usuario usuario, TareaRequest request) {
        Tarea tarea = new Tarea();
        tarea.setUsuario(usuario);
        applyChanges(tarea, request);
        return toResponse(tareaRepository.save(tarea));
    }

    @Transactional
    public TareaResponse update(Usuario usuario, Long id, TareaRequest request) {
        Tarea tarea = tareaRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Tarea no encontrada"));
        if (!tarea.getUsuario().getId().equals(usuario.getId())) {
            throw new IllegalArgumentException("No tienes permiso para modificar esta tarea");
        }
        applyChanges(tarea, request);
        return toResponse(tareaRepository.save(tarea));
    }

    @Transactional
    public void delete(Usuario usuario, Long id) {
        Tarea tarea = tareaRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Tarea no encontrada"));
        if (!tarea.getUsuario().getId().equals(usuario.getId())) {
            throw new IllegalArgumentException("No tienes permiso para eliminar esta tarea");
        }
        tareaRepository.delete(tarea);
    }

    private void applyChanges(Tarea tarea, TareaRequest request) {
        tarea.setTitulo(request.getTitulo());
        tarea.setDescripcion(request.getDescripcion());
        tarea.setMateria(request.getMateria());
        tarea.setFechaEntrega(request.getFechaEntrega());
        tarea.setPrioridad(request.getPrioridad());
        tarea.setEstado(request.getEstado());
        tarea.setNotas(request.getNotas());
    }

    private TareaResponse toResponse(Tarea tarea) {
        TareaResponse response = new TareaResponse();
        response.setId(tarea.getId());
        response.setTitulo(tarea.getTitulo());
        response.setDescripcion(tarea.getDescripcion());
        response.setMateria(tarea.getMateria());
        response.setFechaEntrega(tarea.getFechaEntrega());
        response.setPrioridad(tarea.getPrioridad());
        response.setEstado(tarea.getEstado());
        response.setNotas(tarea.getNotas());
        response.setCreatedAt(tarea.getCreatedAt());
        response.setUpdatedAt(tarea.getUpdatedAt());
        return response;
    }
}

