/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author adamr
 */
package com.recruitment.event;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.*;
import java.util.concurrent.*;
import com.recruitment.config.DBConnection;

public class EventDispatcher {
    private static EventDispatcher instance;
    private final ExecutorService threadPool;
    private final Map<String, List<EventListener>> listeners;
    private final ScheduledExecutorService retryScheduler;

    private EventDispatcher() {
        this.threadPool = Executors.newFixedThreadPool(10);
        this.listeners = new ConcurrentHashMap<>();
        this.retryScheduler = Executors.newSingleThreadScheduledExecutor();
        
        // Automated recovery loop running every 30 seconds
        this.retryScheduler.scheduleAtFixedRate(this::retryFailedEvents, 30, 30, TimeUnit.SECONDS);
    }

    public static synchronized EventDispatcher getInstance() {
        if (instance == null) {
            instance = new EventDispatcher();
        }
        return instance;
    }

    public synchronized void registerListener(String eventType, EventListener listener) {
        listeners.computeIfAbsent(eventType, k -> new ArrayList<>()).add(listener);
    }

    public void dispatch(String eventId, String eventType, String payload) {
        List<EventListener> eventTargets = listeners.get(eventType);
        if (eventTargets == null || eventTargets.isEmpty()) {
            updateEventState(eventId, "PROCESSED", null);
            return;
        }

        for (EventListener listener : eventTargets) {
            threadPool.submit(() -> {
                try {
                    listener.onEvent(payload);
                    updateEventState(eventId, "PROCESSED", null);
                } catch (Exception ex) {
                    handleFailure(eventId, ex.getMessage());
                }
            });
        }
    }

    private void updateEventState(String eventId, String state, String error) {
        String sql = "UPDATE event_log SET state = ?, exception_context = ? WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, state);
            ps.setString(2, error);
            ps.setString(3, eventId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void handleFailure(String eventId, String errorMessage) {
        String sql = "UPDATE event_log SET state = 'FAILED', retry_count = retry_count + 1, exception_context = ? WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, errorMessage);
            ps.setString(2, eventId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void retryFailedEvents() {
        String sql = "SELECT event_id, event_type, payload FROM event_log WHERE state = 'FAILED' AND retry_count < 3";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             java.sql.ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String eventId = rs.getString("event_id");
                String eventType = rs.getString("event_type");
                String payload = rs.getString("payload");
                System.out.println("Retrying failed event: " + eventId);
                dispatch(eventId, eventType, payload);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
