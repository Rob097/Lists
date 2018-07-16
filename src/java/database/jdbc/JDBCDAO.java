
package database.jdbc;

import java.sql.Connection;


public abstract class JDBCDAO {
    
     // The JDBC {@link Connection} used to access the persistence system.
    protected final Connection CON;
   
    //costruttore a usare la connessione nei JDBC_DAO
    protected JDBCDAO(Connection con) {
        super();
        this.CON = con;
    }
    
}
