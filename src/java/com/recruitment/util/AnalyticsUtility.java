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

public class AnalyticsUtility implements EventListener {
    @Override
    public void onEvent(String payload) throws Exception {
        System.out.println("[Asynchronous Workers] Extracting event payload attributes for streaming analytics...");
        Thread.sleep(500);
        System.out.println("[Asynchronous Workers] Core global hiring statistics successfully compiled.");
    }
}
