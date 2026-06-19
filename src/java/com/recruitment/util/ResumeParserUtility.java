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

public class ResumeParserUtility implements EventListener {
    @Override
    public void onEvent(String payload) throws Exception {
        System.out.println("[Asynchronous Workers] Parsing resume metadata from payload: " + payload);
        // Simulate high computational parsing overhead
        Thread.sleep(2500);
        System.out.println("[Asynchronous Workers] Parsing completed successfully.");
    }
}