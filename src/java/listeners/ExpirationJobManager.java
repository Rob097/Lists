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
    /*
    **Executor-->An object that executes submitted Runnable tasks. 
        An Executor is normally used instead of explicitly creating threads
    **ExecutorService-->An Executor that provides methods to manage
        termination and methods that can produce a Future 
        for tracking progress of one or more asynchronous tasks.
    **ScheduledExecutorService-->An ExecutorService that can schedule commands 
        to run after a given delay, or to execute periodically.
    */
    private ScheduledExecutorService scheduler = null;
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        //manages the runnable periodically:(runnable class, delay, period , time-unit)  
        scheduler.scheduleAtFixedRate(new ScheduledTask(sce), 0, 3, TimeUnit.MINUTES);
        scheduler.scheduleAtFixedRate(new PeriodicTask(sce), 0, 3, TimeUnit.MINUTES);
        
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
            System.out.println("Scheduler Shutting down successfully " + new Date());
            scheduler.shutdown();
    }
}


