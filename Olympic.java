/*
* Stephen Cheney sac295 4275535
* CS1555
*/

import java.util.Scanner;
import java.sql.*;

public class Olympic {
  private static String username = "sac295";
  private static String password = "4275535";
    private static final String url = "jdbc:oracle:thin:@class3.cs.pitt.edu:1521:dbclass";
    private static String role_id = "";
    private static String user = "";
    private static String pass = "";

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
        Scanner sc = new Scanner(System.in);
        String input = "";
        welcome(connection,sc);

          System.out.println("Hello, " + user);
          System.out.println("Select from below what you'd like to do. 0 logs out, -1 quits");
          boolean loop = true;
          while(loop){
            String inp1 ="";
            String inp2 ="";
            String inp3 ="";
            String inp4 ="";
            String inp5 ="";
            String inp6 ="";
          if(role_id.equals("1")){ // Organizers
            System.out.println("Select from below what you'd like to do. 0 logs out, -1 quits");
              System.out.println("1: Create User");
              System.out.println("2: Drop User");
              System.out.println("3: Create Event");
              System.out.println("4: Add Event Outcome");
              System.out.println("5: Create Team");
              System.out.println("6: Register Team");
              System.out.println("7: Add Participant");
              System.out.println("8: Add Team Member");
              System.out.println("9: Drop Team Member");
              System.out.println("10: Display Sport");
              System.out.println("11: Display Event");
              System.out.println("12: Display Country Rankings");
              System.out.println("13: Display Top Athletes");
              System.out.println("14: Six Degrees of Kevin Bacon (Connected Athletes)");
              input = sc.next(); sc.nextLine();
              if(input.equals("0")){
                logout(connection, user, pass);
                welcome(connection,sc);
              }
              if(input.equals("-1")) exit(connection);

              switch(Integer.parseInt(input)){
              case 1:
                System.out.println("New role ID: ");
                inp3 = sc.next(); sc.nextLine();
                if(inp3.equals("3")){
                  inp2 = "GUEST";
                  System.out.println("New username: ");
                  inp1 = sc.next(); sc.nextLine();
                  System.out.println("GUEST assigned as password.");
                }else{
                System.out.println("New username: ");
                inp1 = sc.next(); sc.nextLine();
                System.out.println("New password: ");
                inp2 = sc.next(); sc.nextLine();
              }

                if(createUser(connection,inp1,inp2,inp3)) System.out.println("New user created successfully");
                break;
              case 2:
                System.out.println("Drop by username (1) or by user ID (2) ");
                inp1 = sc.next(); sc.nextLine();
                if(inp1.equals("1")){
                  System.out.println("Username to drop: ");
                  inp2 = sc.next(); sc.nextLine();
                  if(dropUser_UN(connection,inp2)) System.out.println("User dropped successfully");
                }
                else if(inp2.equals("2")){
                  System.out.println("User ID to drop: ");
                   inp2 = sc.next(); sc.nextLine();
                  if(dropUser_UID(connection,inp2)) System.out.println("User dropped successfully");
                }
                else System.out.println("Bad input");
                break;
              case 3:
                System.out.println("Sport ID: ");
                inp1 = sc.next(); sc.nextLine();
                System.out.println("Venue ID: ");
                inp2 = sc.next(); sc.nextLine();
                System.out.println("Date (dd-Mon-yyyy hh:mm): ");
                inp3 = sc.nextLine();
                System.out.println("Gender [0=Male, 1=Female]: ");
                inp4 = sc.next(); sc.nextLine();
                if(createEvent(connection,inp1,inp2,inp3,inp4)) System.out.println("New event created successfully");
                break;
                case 4:
                  System.out.println("Olympic ID: ");
                  inp1 = sc.next(); sc.nextLine();
                  System.out.println("Team ID: ");
                  inp2 = sc.next(); sc.nextLine();
                  System.out.println("Event ID: ");
                  inp3 = sc.next(); sc.nextLine();
                  System.out.println("Participant ID: ");
                  inp4 = sc.next(); sc.nextLine();
                  System.out.println("Position: ");
                  inp5 = sc.next(); sc.nextLine();
                  if(addEventOutCome(connection,inp1,inp2,inp3,inp4,inp5)) System.out.println("New outcome created successfully");
                  break;
                  case 5:
                    System.out.println("City name: ");
                    inp1 = sc.nextLine();
                    System.out.println("Year: ");
                    inp2 = sc.next(); sc.nextLine();
                    System.out.println("Sport ID: ");
                    inp3 = sc.next(); sc.nextLine();
                    System.out.println("Country ID: ");
                    inp4 = sc.next(); sc.nextLine();
                    System.out.println("Team Name: ");
                    inp5 = sc.nextLine();
                    System.out.println("Coach ID: ");
                    inp6 = sc.next(); sc.nextLine();
                    if(createTeam(connection,inp1,inp2,inp3,inp4,inp5,inp6)) System.out.println("New Team created successfully");
                    break;
                    case 6:
                      System.out.println("Team ID: ");
                      inp1 = sc.next(); sc.nextLine();
                      System.out.println("Event ID: ");
                      inp2 = sc.next(); sc.nextLine();
                      if(registerTeam(connection,inp1,inp2)) System.out.println("New Team registered successfully");
                      break;
                      case 7:
                        System.out.println("First Name: ");
                        inp1 = sc.nextLine();
                        System.out.println("Last Name: ");
                        inp2 = sc.nextLine();
                        System.out.println("Nationality: ");
                        inp3 = sc.nextLine();
                        System.out.println("Birth Place: ");
                        inp4 = sc.nextLine();
                        System.out.println("DOB (dd-Mon-yyyy): ");
                        inp5 = sc.nextLine();
                        if(addParticipant(connection,inp1,inp2,inp3,inp4,inp5)) System.out.println("New particpant created successfully");
                        break;
                        case 8:
                          System.out.println("Team ID: ");
                          inp1 = sc.next(); sc.nextLine();
                          System.out.println("Participant ID: ");
                          inp2 = sc.next(); sc.nextLine();
                          if(addTeamMember(connection,inp1,inp2)) System.out.println("New team member created successfully");
                          break;
                          case 9:
                            System.out.println("Participant ID: ");
                            inp1 = sc.next(); sc.nextLine();
                            if(dropTeamMember(connection,inp1)) System.out.println("Participant dropped successfully");
                            break;
                            case 10:
                              System.out.println("Name of Sport ([Sport], [Team | Ind.]): ");
                              inp1 = sc.nextLine();
                              if(displaySport(connection,inp1)) System.out.println("Query successful");
                              break;
                              case 11:
                                System.out.println("Olympic City: ");
                                inp1 = sc.nextLine();
                                System.out.println("Year: ");
                                inp2 = sc.next(); sc.nextLine();
                                System.out.println("Event ID: ");
                                inp3 = sc.next(); sc.nextLine();
                                if(displayEvent(connection,inp1,inp2,inp3)) System.out.println("Query successful");
                                break;
                                case 12:
                                  System.out.println("Olympic ID: ");
                                  inp1 = sc.next(); sc.nextLine();
                                  if(countryRanking(connection,inp1)) System.out.println("Query successful");
                                  break;
                                  case 13:
                                    System.out.println("Olympic ID: ");
                                    inp1 = sc.next(); sc.nextLine();
                                    System.out.println("Top #: ");
                                    inp2 = sc.next(); sc.nextLine();
                                    if(topkAthletes(connection,inp1,inp2)) System.out.println("Query successful");
                                    break;
                                    case 14:
                                      System.out.println("Particpant ID: ");
                                      inp1 = sc.next(); sc.nextLine();
                                      System.out.println("Olympic ID: ");
                                      inp2 = sc.next(); sc.nextLine();
                                      System.out.println("# apart: ");
                                      inp3 = sc.next(); sc.nextLine();
                                      if(topkAthletes(connection,inp1,inp2)) System.out.println("Query successful");
                                      break;
                                      default: System.out.println("Selection not found");
              }
              connection.commit();
          }
          else if(role_id.equals("2")){ // Coach
            System.out.println("Select from below what you'd like to do. 0 logs out, -1 quits");
            System.out.println("1: Create Team");
            System.out.println("2: Register Team");
            System.out.println("3: Add Participant");
            System.out.println("4: Add Team Member");
            System.out.println("5: Drop Team Member");
            System.out.println("6: Display Sport");
            System.out.println("7: Display Event");
            System.out.println("8: Display Country Rankings");
            System.out.println("9: Display Top Athletes");
            System.out.println("10: Six Degrees of Kevin Bacon (Connected Athletes)");
            input = sc.next(); sc.nextLine();
            if(input.equals("0")){
              logout(connection, user, pass);
              welcome(connection,sc);
            }
            if(input.equals("-1")) exit(connection);

            switch(Integer.parseInt(input)){
            case 1:
              System.out.println("City name: ");
              inp1 = sc.nextLine();
              System.out.println("Year: ");
              inp2 = sc.next(); sc.nextLine();
              System.out.println("Sport ID: ");
              inp3 = sc.next(); sc.nextLine();
              System.out.println("Country ID: ");
              inp4 = sc.next(); sc.nextLine();
              System.out.println("Team Name: ");
              inp5 = sc.nextLine();
              System.out.println("Coach ID: ");
              inp6 = sc.next(); sc.nextLine();
              if(createTeam(connection,inp1,inp2,inp3,inp4,inp5,inp6)) System.out.println("New Team created successfully");
              break;
              case 2:
                System.out.println("Team ID: ");
                inp1 = sc.next(); sc.nextLine();
                System.out.println("Event ID: ");
                inp2 = sc.next(); sc.nextLine();
                if(registerTeam(connection,inp1,inp2)) System.out.println("New Team registered successfully");
                break;
                case 3:
                  System.out.println("First Name: ");
                  inp1 = sc.nextLine();
                  System.out.println("Last Name: ");
                  inp2 = sc.nextLine();
                  System.out.println("Nationality: ");
                  inp3 = sc.nextLine();
                  System.out.println("Birth Place: ");
                  inp4 = sc.nextLine();
                  System.out.println("DOB (dd-Mon-yyyy): ");
                  inp5 = sc.nextLine();
                  if(addParticipant(connection,inp1,inp2,inp3,inp4,inp5)) System.out.println("New particpant created successfully");
                  break;
                  case 4:
                    System.out.println("Team ID: ");
                    inp1 = sc.next(); sc.nextLine();
                    System.out.println("Participant ID: ");
                    inp2 = sc.next(); sc.nextLine();
                    if(addTeamMember(connection,inp1,inp2)) System.out.println("New team member created successfully");
                    break;
                    case 5:
                      System.out.println("Participant ID: ");
                      inp1 = sc.next(); sc.nextLine();
                      if(dropTeamMember(connection,inp1)) System.out.println("Participant dropped successfully");
                      break;
                      case 6:
                        System.out.println("Name of Sport ([Sport], [Team | Ind.]): ");
                        inp1 = sc.nextLine();
                        if(displaySport(connection,inp1)) System.out.println("Query successful");
                        break;
                        case 7:
                          System.out.println("Olympic City: ");
                          inp1 = sc.nextLine();
                          System.out.println("Year: ");
                          inp2 = sc.next(); sc.nextLine();
                          System.out.println("Event ID: ");
                          inp3 = sc.next(); sc.nextLine();
                          if(displayEvent(connection,inp1,inp2,inp3)) System.out.println("Query successful");
                          break;
                          case 8:
                            System.out.println("Olympic ID: ");
                            inp1 = sc.next(); sc.nextLine();
                            if(countryRanking(connection,inp1)) System.out.println("Query successful");
                            break;
                            case 9:
                              System.out.println("Olympic ID: ");
                              inp1 = sc.next(); sc.nextLine();
                              System.out.println("Top #: ");
                              inp2 = sc.next(); sc.nextLine();
                              if(topkAthletes(connection,inp1,inp2)) System.out.println("Query successful");
                              break;
                              case 10:
                                System.out.println("Particpant ID: ");
                                inp1 = sc.next(); sc.nextLine();
                                System.out.println("Olympic ID: ");
                                inp2 = sc.next(); sc.nextLine();
                                System.out.println("# apart: ");
                                inp3 = sc.next(); sc.nextLine();
                                if(topkAthletes(connection,inp1,inp2)) System.out.println("Query successful");
                                break;
                                default: System.out.println("Selection not found");
                              }
                              connection.commit();
          }
          else if(role_id.equals("3")){ // Guest
            System.out.println("Select from below what you'd like to do. 0 logs out, -1 quits");
            System.out.println("1: Display Sport");
            System.out.println("2: Display Event");
            System.out.println("3: Display Country Rankings");
            System.out.println("4: Display Top Athletes");
            System.out.println("5: Six Degrees of Kevin Bacon (Connected Athletes)");
            input = sc.next(); sc.nextLine();
            if(input.equals("0")){
              logout(connection, user, pass);
              welcome(connection,sc);
            }
            if(input.equals("-1")) exit(connection);
            switch(Integer.parseInt(input)){
            case 1:
              System.out.println("Name of Sport ([Sport], [Team | Ind.]): ");
              inp1 = sc.nextLine();
              if(displaySport(connection,inp1)) System.out.println("Query successful");
              break;
              case 2:
                System.out.println("Olympic City: ");
                inp1 = sc.nextLine();
                System.out.println("Year: ");
                inp2 = sc.next(); sc.nextLine();
                System.out.println("Event ID: ");
                inp3 = sc.next(); sc.nextLine();
                if(displayEvent(connection,inp1,inp2,inp3)) System.out.println("Query successful");
                break;
                case 3:
                  System.out.println("Olympic ID: ");
                  inp1 = sc.next(); sc.nextLine();
                  if(countryRanking(connection,inp1)) System.out.println("Query successful");
                  break;
                  case 4:
                    System.out.println("Olympic ID: ");
                    inp1 = sc.next(); sc.nextLine();
                    System.out.println("Top #: ");
                    inp2 = sc.next(); sc.nextLine();
                    if(topkAthletes(connection,inp1,inp2)) System.out.println("Query successful");
                    break;
                    case 5:
                      System.out.println("Particpant ID: ");
                      inp1 = sc.next(); sc.nextLine();
                      System.out.println("Olympic ID: ");
                      inp2 = sc.next(); sc.nextLine();
                      System.out.println("# apart: ");
                      inp3 = sc.next(); sc.nextLine();
                      if(topkAthletes(connection,inp1,inp2)) System.out.println("Query successful");
                      break;
                      default: System.out.println("Selection not found");
                    }
                    connection.commit();
            }

        }



    }

public static void welcome(Connection connection, Scanner sc) throws SQLException{
try{  System.out.println("Welcome to the Olympic Database.");
  String input = "";
  while(!input.equals("1") || !input.equals("2")){

    System.out.println("1: Login");
    System.out.println("2: Exit");
    input = sc.next(); sc.nextLine();
    if(input.equals("2")){
      exit(connection);
    }
    if(input.equals("1")) break;
  }
  boolean loop = true;
  user = "";
  pass = "";
  while(loop){
    System.out.println("Enter 0 at any point to quit");
    System.out.println("Please Enter your Username: ");
    user = sc.next(); sc.nextLine();
    if(user.equals("0")) exit(connection);
    System.out.println("Please Enter your Password: ");
    pass = sc.next(); sc.nextLine();
    System.out.println("Please Enter your Role ID: ");
    role_id = sc.next(); sc.nextLine();
    if(user.equals("0")) exit(connection);
    if(login(connection,user,pass,role_id)) loop = false;
  }
} catch (SQLException ex) {
  System.out.println("Message = " + ex.getMessage());
  System.out.println("SQLState = " + ex.getSQLState());
  System.out.println("SQLState = " + ex.getErrorCode());
  ex = ex.getNextException();
}
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
