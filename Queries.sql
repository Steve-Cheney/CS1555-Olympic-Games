-- Stephen Cheney sac295 4275535 --
-- Olympic Game Project --

--1. createUser
call proc_create_user('Stephen', 'Cheney',1);
call proc_create_user('John', 'Smith',3);

--2. dropUser
-- drop by Username
call PROC_DROP_USER_USERN('Stephen');
-- drop by UID
call PROC_DROP_USER_USERID(3);

--3. createEvent
call PROC_CREATE_EVENT(1,2,'11-Aug-2016 07:30'); -- events cannot be in the same venue starting at the same time

--4. addEventOutcome
call PROC_ADD_EVENT_OUTCOME(1, 1,2,13,1);

--5. createTeam
call PROC_CREATE_TEAM('Pittsburgh', 2019, 3, 3, 'Pirates', 6);

--6. registerTeam
call PROC_REGISTER_TEAM(1,3);

--7. addParticipant
call PROC_ADD_PARTICIPANT('First', 'Last', 'Canada', 'Montreal', '12-Jul-1950');

--8. addTeamMember
call PROC_ADD_TEAM_MEMBER(2,19);

--9. dropTeamMember
call PROC_DROP_TEAM_MEMBER(19);

--10. login
call PROC_LOGIN('admin','admin',1);

--11. displaySport
call PROC_DISPLAY_SPORT('Archery, Team');

--12. displayEvent
call PROC_DISPLAY_EVENT('London', 2012, 5);

--13. countryRanking
-- incomplete

--14. topkAthletes
call PROC_TOPK_ATHLETES(1, 10);

--14 connectedAthletes
-- incomplete

--16 logout
call PROC_LOGOUT('admin','admin');

--17 exit
-- in Java as closing connection