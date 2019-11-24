import java.sql.*;

// Class responsible for handling the user table in the database
public class UserDao {

	// Create the USER table in the database
	public static void create()
	{
		try
		{
			Connection con=DB.getConnection();
			Statement stmt = con.createStatement();
			String sql = "CREATE TABLE USER " +
							"(id_no CHAR(10) PRIMARY KEY    NOT NULL," +
							" name           TEXT    NOT NULL, " + 
							" password       CHAR(30)    NOT NULL, " + 
							" email          CHAR(30)    NOT NULL, " + 
							" residence     CHAR(30) NOT NULL," + 
							" contact         CHAR(10) NOT NULL)"; 
			stmt.executeUpdate(sql);
			stmt.close();
			con.close();
		}catch ( Exception e ) {
			System.err.println( e.getClass().getName() + ": " + e.getMessage() );
			System.exit(0);
		}
	}

	// Create a new user
	public static int save(String name,String password,String email,String id_no,String residence,String contact){
		int status=0;
		try{
			Connection con=DB.getConnection();
			PreparedStatement ps=con.prepareStatement("insert into USER(name,password,email,id_no,residence,contact) values(?,?,?,?,?,?)");
			ps.setString(1,name);
			ps.setString(2,password);
			ps.setString(3,email);
			ps.setString(4,id_no);
			ps.setString(5,residence);
			ps.setString(6,contact);
			status=ps.executeUpdate();
			con.close();
		}catch(Exception e){
			System.out.println(e);
		}
		return status;
	}

	// Delete the user with the particular ID
	public static int delete(String id){
		int status=0;
		try{
			Connection con=DB.getConnection();
			PreparedStatement ps=con.prepareStatement("delete from User where id_no=?");
			ps.setString(1,id);
			status=ps.executeUpdate();
			con.close();
		}catch(Exception e){System.out.println(e);}
		return status;
	}

	// Check if user and password match
	public static boolean validate(String id_no,String password){
		boolean status=false;
		try{
			Connection con=DB.getConnection();
			PreparedStatement ps=con.prepareStatement("select * from User where id_no=? and password=?");
			ps.setString(1,id_no);
			ps.setString(2,password);
			ResultSet rs=ps.executeQuery();
			status=rs.next();
			con.close();
		}catch(Exception e){System.out.println(e);}
		return status;
	}

	// Call to create the table
	public static void main(String[] args) {
		create();
	}
}
