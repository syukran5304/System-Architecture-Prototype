/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author adamr
 */
package com.recruitment.util;

import com.recruitment.event.EventListener;

public class NotificationUtility implements EventListener {
    @Override
    public void onEvent(String payload) throws Exception {
        System.out.println("[Asynchronous Workers] Sending Real-Time Communication alerts... Payload: " + payload);
        // Simulate remote networking/SMTP I/O delay bounds
        Thread.sleep(1000);
        System.out.println("[Asynchronous Workers] Notifications pushed to candidate and recruiter.");
    }
}