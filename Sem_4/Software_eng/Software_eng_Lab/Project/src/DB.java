import java.sql.Connection;
import java.sql.DriverManager;

// Class to access the database. Returns a connection to the database "test.db"

public class DB {
	public static Connection getConnection(){
		Connection con=null;
		try {
			Class.forName("org.sqlite.JDBC");
			con = DriverManager.getConnection("jdbc:sqlite:test.db");
		 } catch ( Exception e ) {
			System.err.println( e.getClass().getName() + ": " + e.getMessage() );
		 }
		 return con;
	}

}
