/*
* Stephen Cheney sac295 4275535
* CS1555
*/

Reccomended order of running SQL: schema.sql, init.sql, tirgger.sql (they all have appropriate drop functions)

To compile and run Olympic.java:
javac -cp "ojdbc7.jar" Olympic.java
java -cp "ojdbc7.jar;." Olympic

There is an admin account in init that acts as an Organizer. Organizers are able to perform all functions as they act as administrators. To login as admin, type 1 when prompted to login, then user: admin   pass: admin   role id: 1.   All logins must include the specified role id as I made it possible for the user to have the same username and password with different roles for testing (still seperate tuples however). Once logged in, you will see the menu appear. Follow instructions to select the functions. 0 will send you back to log in with a different account, and -1 will exit entirely.

To compile and run Driver.java
javac -cp "odjbc7.jar" Driver.java
java -cp "ojdbc7.jar;." Driver



Files include Olympic.java, Driver.java, Schema.sql, trigger.sql, init.sql, and queries.sql