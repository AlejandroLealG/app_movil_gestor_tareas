package com.gestor.backend.controller;

import com.gestor.backend.service.DatabaseHealthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/health")
public class HealthController {

    private final DatabaseHealthService databaseHealthService;

    public HealthController(DatabaseHealthService databaseHealthService) {
        this.databaseHealthService = databaseHealthService;
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> payload = new HashMap<>();
        payload.put("service", "backend");
        payload.put("timestamp", Instant.now().toString());
        payload.put("database", databaseHealthService.getStats());
        return ResponseEntity.ok(payload);
    }
}

