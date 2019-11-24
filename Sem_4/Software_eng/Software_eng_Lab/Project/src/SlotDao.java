import java.sql.*;

// Class responsible for handling the slot table in the database
public class SlotDao {

	// The function that creates the SLOT Table
	public static void create()
	{
		try
		{
			Connection con=DB.getConnection();
			Statement stmt = con.createStatement();
			String sql = "CREATE TABLE SLOT " +
							"(sport CHAR(30) PRIMARY KEY    NOT NULL," +
							" sl1   INT    					NOT NULL, " + 
							" sl2   INT    					NOT NULL, " + 
							" sl3   INT    					NOT NULL, " + 
							" sl4   INT 					NOT NULL," + 
							" sl5   INT 					NOT NULL)"; 
			stmt.executeUpdate(sql);
			stmt.close();
			con.close();
		}catch ( Exception e ) {
			System.err.println( e.getClass().getName() + ": " + e.getMessage() );
			System.exit(0);
		}
	}
	
	// Intialise all sports with a default vacancy of 9
	public static void initialise(String sport)
	{
		int status = 0;
		try{
			Connection con=DB.getConnection();
			PreparedStatement ps=con.prepareStatement("insert into SLOT(sport,sl1,sl2,sl3,sl4,sl5) values(?,?,?,?,?,?)");
			ps.setString(1,sport);
			ps.setString(2,"9");
			ps.setString(3,"9");
			ps.setString(4,"9");
			ps.setString(5,"9");
			ps.setString(6,"9");
			status=ps.executeUpdate();
			con.close();
		}catch(Exception e){System.out.println(e);}
	}

	// returns all the vacancies for a particular sport
	public static int[] check(String sport)
	{
		int slot_vac[] = new int[]{0,0,0,0,0};
		try{
			Connection con=DB.getConnection();
			PreparedStatement ps=con.prepareStatement("select * from SLOT where sport=?");
			ps.setString(1, sport);
			ResultSet rs = ps.executeQuery();
			while( rs.next() )
			{
				slot_vac = new int[]{rs.getInt("sl1"),rs.getInt("sl2"),rs.getInt("sl3"),rs.getInt("sl4"),rs.getInt("sl5")};
			}
			con.close();
			return slot_vac;
		}
		catch(Exception e)
		{
			System.out.println(e);
		}
		return slot_vac;
	}

	// Function for handling the slot updates and reset. Pass task = -1 for reset, task = 1 for booking, task = 2 for cancelling
	// return 0 means slot not available
	// return 1 means successful operation
	// return -1 means sql error
	// return 2 means no cancellation possible

	public static int update(String sport,int task,int slot)
	{
		boolean status=false;
		try
		{
			Connection con=DB.getConnection();

			// Resetting all slots to 9 vacancies
			if( task == -1)
			{
				PreparedStatement ps=con.prepareStatement("UPDATE SLOT set sl1 = 9, sl2 = 9, sl3 = 9, sl4 = 9, sl5 = 9  where sport=?");
				ps.setString(1,sport);
				if( ps.executeUpdate() == 0)
				{
					con.close();
					return -1;
				}
				con.close();
				return 1;
			}
	  
			// book for the particular slot
			else if(task  == 1)
			{
				PreparedStatement ps=con.prepareStatement("select * from SLOT where sport=?");
				ps.setString(1,sport);
				ResultSet rs=ps.executeQuery();

				// Check if there are vacancies
				while ( rs.next() ) 
				{
					if(slot == 1)
					{
						int number_vacant = rs.getInt("sl1");
						if( number_vacant == 0)
						{
							rs.close();
							con.close();
							return 0;
						}
					}
					else if(slot == 2)
					{
						int number_vacant = rs.getInt("sl2");
						if( number_vacant == 0)
						{
							rs.close();
							con.close();
							return 0;
						}
					}
					else if(slot == 3)
					{
						int number_vacant = rs.getInt("sl3");
						if( number_vacant == 0)
						{
							rs.close();
							con.close();
							return 0;
						}
					}
					else if(slot == 4)
					{
						int number_vacant = rs.getInt("sl4");
						if( number_vacant == 0)
						{
							rs.close();
							con.close();
							return 0;
						}
					}
					else if(slot == 5)
					{
						int number_vacant = rs.getInt("sl5");
						if( number_vacant == 0)
						{
							rs.close();
							con.close();
							return 0;
						}
					}
				}
				rs.close();

				// Handle the update and decrease vacancy by 1
				if( slot == 1)
				{
					ps=con.prepareStatement("UPDATE SLOT set sl1 = sl1 - 1 where sport=?");
					ps.setString(1,sport);
					if(ps.executeUpdate() == 0)
					{
						con.close();
						return -1;
					}
					con.close();
					return 1;
				}

				else if( slot == 2)
				{
					ps=con.prepareStatement("UPDATE SLOT set sl2 = sl2 - 1 where sport=?");
					ps.setString(1,sport);
					if(ps.executeUpdate() == 0)
					{
						con.close();
						return -1;
					}
					con.close();
					return 1;
				}

				else if( slot == 3)
				{
					ps=con.prepareStatement("UPDATE SLOT set sl3 = sl3 - 1 where sport=?");
					ps.setString(1,sport);
					if(ps.executeUpdate() == 0)
					{
						con.close();
						return -1;
					}
					con.close();
					return 1;
				}

				else if( slot == 4)
				{
					ps=con.prepareStatement("UPDATE SLOT set sl4 = sl4 - 1 where sport=?");
					ps.setString(1,sport);
					if(ps.executeUpdate() == 0)
					{
						con.close();
						return -1;
					}
					con.close();
					return 1;
				}

				else if( slot == 5)
				{
					ps=con.prepareStatement("UPDATE SLOT set sl5 = sl5 - 1 where sport=?");
					ps.setString(1,sport);
					if(ps.executeUpdate() == 0)
					{
						con.close();
						return -1;
					}
					con.close();
					return 1;
				}
			}

			// cancel sot
			else if(task  == 2)
			{
				PreparedStatement ps=con.prepareStatement("select * from SLOT where sport=?");
				ps.setString(1,sport);
				ResultSet rs=ps.executeQuery();

				// Check if there are vacancies
				while ( rs.next() ) 
				{
					if(slot == 1)
					{
						int number_vacant = rs.getInt("sl1");
						if( number_vacant == 9)
						{
							rs.close();
							con.close();
							return 2;
						}
					}
					else if(slot == 2)
					{
						int number_vacant = rs.getInt("sl2");
						if( number_vacant == 9)
						{
							rs.close();
							con.close();
							return 2;
						}
					}
					else if(slot == 3)
					{
						int number_vacant = rs.getInt("sl3");
						if( number_vacant == 9)
						{
							rs.close();
							con.close();
							return 2;
						}
					}
					else if(slot == 4)
					{
						int number_vacant = rs.getInt("sl4");
						if( number_vacant == 9)
						{
							rs.close();
							con.close();
							return 2;
						}
					}
					else if(slot == 5)
					{
						int number_vacant = rs.getInt("sl5");
						if( number_vacant == 9)
						{
							rs.close();
							con.close();
							return 2;
						}
					}
				}
				rs.close();

				// Handle the update and increase vacancy by 1
				if( slot == 1)
				{
					ps=con.prepareStatement("UPDATE SLOT set sl1 = sl1 + 1 where sport=?");
					ps.setString(1,sport);
					if(ps.executeUpdate() == 0)
					{
						con.close();
						return -1;
					}
					con.close();
					return 1;
				}

				else if( slot == 2)
				{
					ps=con.prepareStatement("UPDATE SLOT set sl2 = sl2 + 1 where sport=?");
					ps.setString(1,sport);
					if(ps.executeUpdate() == 0)
					{
						con.close();
						return -1;
					}
					con.close();
					return 1;
				}

				else if( slot == 3)
				{
					ps=con.prepareStatement("UPDATE SLOT set sl3 = sl3 + 1 where sport=?");
					ps.setString(1,sport);
					if(ps.executeUpdate() == 0)
					{
						con.close();
						return -1;
					}
					con.close();
					return 1;
				}

				else if( slot == 4)
				{
					ps=con.prepareStatement("UPDATE SLOT set sl4 = sl4 + 1 where sport=?");
					ps.setString(1,sport);
					if(ps.executeUpdate() == 0)
					{
						con.close();
						return -1;
					}
					con.close();
					return 1;
				}

				else if( slot == 5)
				{
					ps=con.prepareStatement("UPDATE SLOT set sl5 = sl5 + 1 where sport=?");
					ps.setString(1,sport);
					if(ps.executeUpdate() == 0)
					{
						con.close();
						return -1;
					}
					con.close();
					return 1;
				}
			}
		}
		catch(Exception e)
		{
			System.out.println(e);
			return -1;
		}
		return 1;
	}

	// Call to create table from scratch
	public static void main(String[] args) {

		initialise("Badminton");
		initialise("Gym");
		initialise("Squash");
		initialise("Swimming");
		initialise("Tennis");
		initialise("Table Tennis");
		initialise("Basket Ball");
	}
}
