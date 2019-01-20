/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package listeners;

import Tools.PeriodicTask;
import Tools.ScheduledTask;
import java.util.Date;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * Web application lifecycle listener.
 *
 * @author Martin
 */
public class ExpirationJobManager implements ServletContextListener {

    private ScheduledExecutorService scheduler = null;
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.scheduleAtFixedRate(new ScheduledTask(sce), 0, 1, TimeUnit.MINUTES);
        scheduler.scheduleAtFixedRate(new PeriodicTask(sce), 0, 1, TimeUnit.MINUTES);
        
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
            System.out.println("Scheduler Shutting down successfully " + new Date());
            scheduler.shutdown();
    }
}


