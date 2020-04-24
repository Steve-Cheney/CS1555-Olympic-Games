import java.sql.*;

public class Olympic {
  private static String username = "sac295";
  private static String password = "4275535";
    private static final String url = "jdbc:oracle:thin:@class3.cs.pitt.edu:1521:dbclass";

    public static void main(String args[]) throws
            SQLException {

        Connection connection = null;
        try {
            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
            connection = DriverManager.getConnection(url, username, password);
            connection.setAutoCommit(true);
            connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

        } catch (Exception e) {
            System.out.println(
                    "Error connecting to database. Printing stack trace: ");
            e.printStackTrace();
        }
        /*
        try{
          //Initialize the script runner
          ScriptRunner sr = new ScriptRunner(connection);
          //Creating a reader object
          Reader reader = new BufferedReader(new FileReader("./schema.sql"));
          //Running the script
          sr.runScript(reader);
          reader = new BufferedReader(new FileReader("./init.sql"));
          sr.runScript(reader);
          reader = new BufferedReader(new FileReader("./trigger.sql"));
          sr.runScript(reader);
        } catch (SQLException e){
          System.out.println("Initial schema does not exist, creating now");
        }
        */
        /*
        createUser(connection,"NewUser","Passworkssdsd","1");
        dropUser_UID(connection, "5");
        createEvent(connection,"1","1","10-AUG-2016 18:01","1");
        */


    }

/**************** 1 - 5 *******************/
    /*
    * Creates a new user in USER_ACCOUNT
    */
    public static void createUser(Connection connec, String _user, String _pass, String _role) throws SQLException{
      try {
       CallableStatement statement = connec.prepareCall("{call proc_create_user(?, ?, ?)}");

         statement.setString(1, _user);
         statement.setString(2, _pass);
         statement.setString(3, _role);

         statement.execute();
         statement.close();

         //System.out.println("Stored procedure called successfully within createUser!");

     } catch (SQLException ex) {
       System.out.println("Message = " + ex.getMessage());
       System.out.println("SQLState = " + ex.getSQLState());
       System.out.println("SQLState = " + ex.getErrorCode());
       ex = ex.getNextException();
     }
    }

    /*
    * Drops user based on username
    */
    public static void dropUser_UN(Connection connec, String _user) throws SQLException{
      try {
       CallableStatement statement = connec.prepareCall("{call proc_drop_user_usern(?)}");

         statement.setString(1, _user);

         statement.execute();
         statement.close();


     } catch (SQLException ex) {
       System.out.println("Message = " + ex.getMessage());
       System.out.println("SQLState = " + ex.getSQLState());
       System.out.println("SQLState = " + ex.getErrorCode());
       ex = ex.getNextException();
     }
    }

    /*
    * Drops user based on user ID
    */
    public static void dropUser_UID(Connection connec, String _userid) throws SQLException{
      try {
       CallableStatement statement = connec.prepareCall("{call proc_drop_user_userid(?)}");

         statement.setString(1, _userid);

         statement.execute();
         statement.close();


     } catch (SQLException ex) {
       System.out.println("Message = " + ex.getMessage());
       System.out.println("SQLState = " + ex.getSQLState());
       System.out.println("SQLState = " + ex.getErrorCode());
       ex = ex.getNextException();
     }
    }

    /*
    * Drops user based on user ID
    */
    public static void createEvent(Connection connec, String sid, String vid, String date, String gender) throws SQLException{
      try {
       CallableStatement statement = connec.prepareCall("{call proc_create_event(?, ?, TO_DATE(?,'dd-Mon-yyyy HH24:MI'), ?)}");

         statement.setString(1, sid);
         statement.setString(2, vid);
         statement.setString(3, date);
         statement.setString(4, gender);

         statement.execute();
         statement.close();

     } catch (SQLException ex) {
       System.out.println("Message = " + ex.getMessage());
       System.out.println("SQLState = " + ex.getSQLState());
       System.out.println("SQLState = " + ex.getErrorCode());
       ex = ex.getNextException();
     }
    }



/******************************************/
}
