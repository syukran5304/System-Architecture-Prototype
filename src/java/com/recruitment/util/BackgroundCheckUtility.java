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

public class BackgroundCheckUtility implements EventListener {
    @Override
    public void onEvent(String payload) throws Exception {
        System.out.println("[Asynchronous Workers] Triggering automatic background data checks for payload: " + payload);
        // Simulate background profile verification logic
        Thread.sleep(1500);
        System.out.println("[Asynchronous Workers] Verification checks completed cleanly.");
    }
}
