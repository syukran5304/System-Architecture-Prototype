/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author adamr
 */
package com.recruitment.web;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import com.recruitment.event.EventDispatcher;
import com.recruitment.util.NotificationUtility;
import com.recruitment.util.ResumeParserUtility;
import com.recruitment.util.BackgroundCheckUtility;
import com.recruitment.util.AnalyticsUtility;

@WebListener
public class AppContextListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[Initialization Block] Bootstrap sequence started...");
        EventDispatcher dispatcher = EventDispatcher.getInstance();
        
        // 1. Existing application execution routes
        dispatcher.registerListener("APPLICATION_SUBMITTED", new ResumeParserUtility());
        dispatcher.registerListener("APPLICATION_SUBMITTED", new NotificationUtility());
        
        // 2. FIXED: Wire up Module 5 background listeners cleanly
        dispatcher.registerListener("APPLICATION_SUBMITTED", new BackgroundCheckUtility());
        dispatcher.registerListener("JOB_CREATED", new AnalyticsUtility());
        
        System.out.println("[Initialization Block] All event streams successfully hooked up.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[Teardown Block] Tearing down application resources.");
    }
}
