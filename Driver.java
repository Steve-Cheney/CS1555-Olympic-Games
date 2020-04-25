/*
* Stephen Cheney sac295 4275535
* CS1555
*/

import java.util.Scanner;
import java.sql.*;

public class Driver {
  private static String username = "sac295";
  private static String password = "4275535";
    private static final String url = "jdbc:oracle:thin:@class3.cs.pitt.edu:1521:dbclass";
    private static String role_id = "";
    private static String user = "";
    private static String pass = "";


    public static void print_table(Connection conn, String query) throws SQLException{
      try {
        Statement state = conn.createStatement();
        ResultSet resultset = state.executeQuery(query);
        ResultSetMetaData rsmd1 = resultset.getMetaData();

        int columns = rsmd1.getColumnCount();

        // Iterate through the data in the result set and display it.

        while (resultset.next()) {
        //Print one row
          for(int i = 1 ; i <= columns; i++){
            System.out.print(resultset.getString(i) + " "); //Print one element of a row
          }
          System.out.println();//Move to the next line to print the next row.
        }
        System.out.println("\n\n");
      }
       catch (SQLException ex){
      System.out.println("Message = " + ex.getMessage());
      System.out.println("SQLState = " + ex.getSQLState());
      System.out.println("SQLState = " + ex.getErrorCode());
      ex = ex.getNextException();
    }
  }

    public static void main(String args[]) throws SQLException {

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

        Scanner sc = new Scanner(System.in);
        String input = "";
        System.out.println("User: " + user + " Pass: " + pass + " Role: " + role_id);
        login(connection,"admin","admin","1");
        System.out.println("User: " + user + " Pass: " + pass + " Role: " + role_id);

        String inp1 ="";
        String inp2 ="";
        String inp3 ="";
        String inp4 ="";
        String inp5 ="";
        String inp6 ="";

        System.out.println("1: Create User");

        print_table(connection, "SELECT * FROM USER_ACCOUNT");
        inp3 = "2";
        inp2 = "Passwordhere";
        inp1 = "NewUser";
        if(createUser(connection,inp1,inp2,inp3)) System.out.println("New user created successfully");
        print_table(connection, "SELECT * FROM USER_ACCOUNT");

        System.out.println("2: Drop User by username then UID");

        print_table(connection, "SELECT * FROM USER_ACCOUNT");
        inp1 = "NewUser";
        if(dropUser_UN(connection,inp1)) System.out.println("User dropped successfully");
        inp2 = "3";
        if(dropUser_UN(connection,inp2)) System.out.println("User dropped successfully");
        print_table(connection, "SELECT * FROM USER_ACCOUNT");

        System.out.println("3: Create Event");

        print_table(connection, "SELECT * FROM EVENT");
          inp1 = "1";
          inp2 = "2";
          inp3 = "12-Aug-2016 04:00";
          inp4 = "1";
          if(createEvent(connection,inp1,inp2,inp3,inp4)) System.out.println("New event created successfully");
          print_table(connection, "SELECT * FROM EVENT");


        System.out.println("4: Add Event Outcome");

        print_table(connection, "SELECT * FROM SCOREBOARD");
          inp1 = "1";
          inp2 = "2";
          inp3 = "2";
          inp4 = "15";
          inp5 = "3";
          if(addEventOutCome(connection,inp1,inp2,inp3,inp4,inp5)) System.out.println("New outcome created successfully");
          print_table(connection, "SELECT * FROM SCOREBOARD");

        System.out.println("5: Create Team");


        print_table(connection, "SELECT * FROM TEAM");
          inp1 = "Pittsburgh";
          inp2 = "2019";
          inp3 = "3";
          inp4 = "3";
          inp5 = "Pirates";
          inp6 = "6";
          if(createTeam(connection,inp1,inp2,inp3,inp4,inp5,inp6)) System.out.println("New Team created successfully");
          print_table(connection, "SELECT * FROM TEAM");

        System.out.println("6: Register Team");

        print_table(connection, "SELECT * FROM EVENT_PARTICIPATION");
          inp1 = "1";
          inp2 = "3";
          if(registerTeam(connection,inp1,inp2)) System.out.println("New Team registered successfully");
          print_table(connection, "SELECT * FROM EVENT_PARTICIPATION");

        System.out.println("7: Add Participant");

        print_table(connection, "SELECT * FROM PARTICIPANT");
          inp1 = "First";
          inp2 = "Last";
          inp3 = "Canada";
          inp4 = "Monrtreal";
          inp5 = "12-Jul-1950";
          if(addParticipant(connection,inp1,inp2,inp3,inp4,inp5)) System.out.println("New particpant created successfully");
          print_table(connection, "SELECT * FROM PARTICIPANT");

        System.out.println("8: Add Team Member");

        print_table(connection, "SELECT * FROM TEAM_MEMBER");
          inp1 = "2";
          inp2 = "19";
          if(addTeamMember(connection,inp1,inp2)) System.out.println("New team member created successfully");
          print_table(connection, "SELECT * FROM TEAM_MEMBER");


        System.out.println("9: Drop Team Member");

          print_table(connection, "SELECT * FROM TEAM_MEMBER");
          print_table(connection, "SELECT * FROM SCOREBOARD");
          inp1 = "19";
          if(dropTeamMember(connection,inp1)) System.out.println("Participant dropped successfully");
          print_table(connection, "SELECT * FROM TEAM_MEMBER");
          print_table(connection, "SELECT * FROM SCOREBOARD");


        System.out.println("10: Display Sport");

          inp1 = "Archery, Team";
          if(displaySport(connection,inp1)) System.out.println("Query successful");

        System.out.println("11: Display Event");

          inp1 = "London";
          inp2 = "2012";
          inp3 = "5";
          if(displayEvent(connection,inp1,inp2,inp3)) System.out.println("Query successful");

        System.out.println("12: Display Country Rankings");

          inp1 = "null";
          if(countryRanking(connection,inp1)) System.out.println("Query successful");

        System.out.println("13: Display Top Athletes");

          inp1 = "1";
          inp2 = "10";
          if(topkAthletes(connection,inp1,inp2)) System.out.println("Query successful");

        System.out.println("14: Six Degrees of Kevin Bacon (Connected Athletes)");

          inp1 = "null";
          inp2 = "null";
          inp3 = "null";
          if(topkAthletes(connection,inp1,inp2)) System.out.println("Query successful");

        System.out.println("logging out");
        logout(connection, user, pass);
        System.out.println("now exiting");
        exit(connection);

      }

      /**************** 1 - 4 *******************/
          /*
          * Creates a new user in USER_ACCOUNT
          */
          public static boolean createUser(Connection connec, String _user, String _pass, String _role) throws SQLException{
            try {
             CallableStatement statement = connec.prepareCall("{call proc_create_user(?, ?, ?)}");

               statement.setString(1, _user);
               statement.setString(2, _pass);
               statement.setString(3, _role);

               statement.execute();
               statement.close();

               return true;
               //System.out.println("Stored procedure called successfully within createUser!");

           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Drops user based on username
          */
          public static boolean dropUser_UN(Connection connec, String _user) throws SQLException{
            try {
             CallableStatement statement = connec.prepareCall("{call proc_drop_user_usern(?)}");

               statement.setString(1, _user);

               statement.execute();
               statement.close();
               return true;

           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Drops user based on user ID
          */
          public static boolean dropUser_UID(Connection connec, String _userid) throws SQLException{
            try {
             CallableStatement statement = connec.prepareCall("{call proc_drop_user_userid(?)}");

               statement.setString(1, _userid);

               statement.execute();
               statement.close();
               return true;

           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Drops user based on user ID
          */
          public static boolean createEvent(Connection connec, String sid, String vid, String date, String gender) throws SQLException{
            try {
             CallableStatement statement = connec.prepareCall("{call proc_create_event(?, ?, TO_DATE(?,'dd-Mon-yyyy HH24:MI'), ?)}");

               statement.setString(1, sid);
               statement.setString(2, vid);
               statement.setString(3, date);
               statement.setString(4, gender);

               statement.execute();
               statement.close();
               return true;
           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Adds to scoreboard based on inputs
          */
          public static boolean addEventOutCome(Connection connec, String oid, String tid, String eid, String pid, String pos) throws SQLException{
            try {
             CallableStatement statement = connec.prepareCall("{call proc_add_Event_Outcome(?,?,?,?,?)}");

               statement.setString(1, oid);
               statement.setString(2, tid);
               statement.setString(3, eid);
               statement.setString(4, pid);
               statement.setString(5, pos);

               statement.execute();
               statement.close();
               return true;
           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }
      /******************************************/
      /**************** 5 - 9 *******************/

          /*
          * Creates team
          */
          public static boolean createTeam(Connection connec, String city, String year, String sid, String cid, String name, String coachid) throws SQLException{
            try {
             CallableStatement statement = connec.prepareCall("{call proc_create_team(?,?,?,?,?,?)}");

               statement.setString(1, city);
               statement.setString(2, year);
               statement.setString(3, sid);
               statement.setString(4, cid);
               statement.setString(5, name);
               statement.setString(6, coachid);

               statement.execute();
               statement.close();
               return true;
           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Registers team, defaults to eligible.
          */
          public static boolean registerTeam(Connection connec, String tid, String eid) throws SQLException{
            try {
             CallableStatement statement = connec.prepareCall("{call proc_register_team(?,?)}");

               statement.setString(1, tid);
               statement.setString(2, eid);

               statement.execute();
               statement.close();
               return true;
           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Adds participant, only worries about PK and FK constraints being caught
          */
          public static boolean addParticipant(Connection connec, String fname, String lname, String nat, String bp, String dob) throws SQLException{
            try {
             CallableStatement statement = connec.prepareCall("{call proc_add_participant(?,?,?,?)}");

               statement.setString(1, fname);
               statement.setString(2, lname);
               statement.setString(3, nat);
               statement.setString(4, bp);
               statement.setString(5, dob);

               statement.execute();
               statement.close();
               return true;
           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Adds team member
          */
          public static boolean addTeamMember(Connection connec, String tid, String pid) throws SQLException{
            try {
             CallableStatement statement = connec.prepareCall("{call proc_add_team_member(?,?)}");

               statement.setString(1, tid);
               statement.setString(2, pid);

               statement.execute();
               statement.close();
               return true;

           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Removes particpant tuple entirely drom DBs
          */
          public static boolean dropTeamMember(Connection connec, String pid) throws SQLException{
            try {
             CallableStatement statement = connec.prepareCall("{call proc_drop_team_member(?)}");

               statement.setString(1, pid);

               statement.execute();
               statement.close();
               return true;
           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

      /******************************************/
      /**************** 10 - 17 *******************/

          /*
          * Returns true if successfully logged in, false otherwise. Used for control flow
          */
          public static boolean login(Connection connec, String user, String pass, String role) throws SQLException{
            try {
             CallableStatement statement = connec.prepareCall("{call proc_login(?,?,?)}");

               statement.setString(1, user);
               statement.setString(2, pass);
               statement.setString(3, role);


               statement.execute();
               statement.close();
               return true;
           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Dsiplays info for Sports
          */
          public static boolean displaySport(Connection connec, String name) throws SQLException{
            try {

              connec.setAutoCommit (false);
              DbmsOutput dbmsOutput = new DbmsOutput(connec);
              dbmsOutput.enable( 1000000 );

             CallableStatement statement = connec.prepareCall("{call proc_display_sport(?)}");
               statement.setString(1, name);

               statement.execute();
               statement.close();
               dbmsOutput.show();

               dbmsOutput.close();
               connec.close();
               return true;
           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Dsiplays info for Event
          */
          public static boolean displayEvent(Connection connec, String city, String year, String eid) throws SQLException{
            try {

              connec.setAutoCommit (false);
              DbmsOutput dbmsOutput = new DbmsOutput(connec);
              dbmsOutput.enable( 1000000 );
             CallableStatement statement = connec.prepareCall("{call proc_display_event(?,?,?)}");

               statement.setString(1, city);
               statement.setString(2, year);
               statement.setString(3, eid);

               statement.execute();
               statement.close();
               dbmsOutput.show();

               dbmsOutput.close();
               connec.close();
               return true;
           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Incomplete on DB
          */
          public static boolean countryRanking(Connection connec, String oid) throws SQLException{
            try {
             CallableStatement statement = connec.prepareCall("{call proc_country_ranking(?)}");

               statement.setString(1, oid);

               statement.execute();
               statement.close();
               return true;
           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Dsiplays info for top k athletes
          */
          public static boolean topkAthletes(Connection connec, String oid, String k) throws SQLException{
            try {

              connec.setAutoCommit (false);
              DbmsOutput dbmsOutput = new DbmsOutput(connec);
              dbmsOutput.enable( 1000000 );

             CallableStatement statement = connec.prepareCall("{call proc_topk_athletes(?,?)}");

               statement.setString(1, oid);
               statement.setString(2, k);

               statement.execute();
               statement.close();
               dbmsOutput.show();

               dbmsOutput.close();
               connec.close();
               return true;
           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Incomplete on DB
          */
          public static boolean connectedAthletes(Connection connec, String pid, String oid, String n) throws SQLException{
            try {
             CallableStatement statement = connec.prepareCall("{call proc_topk_atheletes(?,?,?)}");

               statement.setString(1, pid);
               statement.setString(2, oid);
               statement.setString(3, n);

               statement.execute();
               statement.close();
               return true;
           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          /*
          * Returns true if successfully logged in, false otherwise. Used for control flow
          */
          public static boolean logout(Connection connec, String user, String pass) throws SQLException{
            try {

             CallableStatement statement = connec.prepareCall("{call proc_logout(?,?)}");

               statement.setString(1, user);
               statement.setString(2, pass);

               statement.execute();
               statement.close();

               return true;
           } catch (SQLException ex) {
             System.out.println("Message = " + ex.getMessage());
             System.out.println("SQLState = " + ex.getSQLState());
             System.out.println("SQLState = " + ex.getErrorCode());
             ex = ex.getNextException();
             return false;
           }
          }

          public static void exit(Connection connec) throws SQLException{
            try{
              connec.close();
              System.exit(0);
            }
            catch (SQLException ex){
            }
          }

      }

          class DbmsOutput
              {

              private CallableStatement enable_stmt;
              private CallableStatement disable_stmt;
              private CallableStatement show_stmt;

              public DbmsOutput( Connection conn ) throws SQLException{
                enable_stmt = conn.prepareCall( "begin dbms_output.enable(:1); end;" );
                disable_stmt = conn.prepareCall( "begin dbms_output.disable; end;" );

                show_stmt = conn.prepareCall(
                "declare " +
                " l_line varchar2(255); " +
                " l_done number; " +
                " l_buffer long; " +
                "begin " +
                " loop " +
                " exit when length(l_buffer)+255 > :maxbytes OR l_done = 1; " +
                " dbms_output.get_line( l_line, l_done ); " +
                " l_buffer := l_buffer || l_line || chr(10); " +
                " end loop; " +
                " :done := l_done; " +
                " :buffer := l_buffer; " +
                "end;" );
              }

              public void enable( int size ) throws SQLException{
                enable_stmt.setInt( 1, size );
                enable_stmt.executeUpdate();
              }

              public void disable() throws SQLException{
                disable_stmt.executeUpdate();
              }

              public void show() throws SQLException{
              int done = 0;

              show_stmt.registerOutParameter( 2, java.sql.Types.INTEGER );
              show_stmt.registerOutParameter( 3, java.sql.Types.VARCHAR );

              for(;;){
                show_stmt.setInt( 1, 32000 );
                show_stmt.executeUpdate();
                System.out.print( show_stmt.getString(3) );
                if ( (done = show_stmt.getInt(2)) == 1 ) break;
                }
              }

              public void close() throws SQLException{
                enable_stmt.close();
                disable_stmt.close();
                show_stmt.close();
              }
          }
