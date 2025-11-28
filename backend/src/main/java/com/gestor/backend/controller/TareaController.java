package com.gestor.backend.controller;

import com.gestor.backend.dto.TareaRequest;
import com.gestor.backend.dto.TareaResponse;
import com.gestor.backend.entity.Usuario;
import com.gestor.backend.service.AuthService;
import com.gestor.backend.service.TareaService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/tareas")
public class TareaController {

    private static final String TOKEN_HEADER = "X-Auth-Token";

    private final AuthService authService;
    private final TareaService tareaService;

    public TareaController(AuthService authService, TareaService tareaService) {
        this.authService = authService;
        this.tareaService = tareaService;
    }

    @GetMapping
    public ResponseEntity<List<TareaResponse>> list(@RequestHeader(TOKEN_HEADER) String token) {
        Usuario usuario = authService.authenticate(token);
        return ResponseEntity.ok(tareaService.listByUsuario(usuario));
    }

    @PostMapping
    public ResponseEntity<TareaResponse> create(@RequestHeader(TOKEN_HEADER) String token,
                                                @Valid @RequestBody TareaRequest request) {
        Usuario usuario = authService.authenticate(token);
        return ResponseEntity.ok(tareaService.create(usuario, request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<TareaResponse> update(@RequestHeader(TOKEN_HEADER) String token,
                                                @PathVariable Long id,
                                                @Valid @RequestBody TareaRequest request) {
        Usuario usuario = authService.authenticate(token);
        return ResponseEntity.ok(tareaService.update(usuario, id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@RequestHeader(TOKEN_HEADER) String token,
                                       @PathVariable Long id) {
        Usuario usuario = authService.authenticate(token);
        tareaService.delete(usuario, id);
        return ResponseEntity.noContent().build();
    }
}

