-- Stephen Cheney sac295 4275535 --
-- Olympic Game Project --
SET CONSTRAINTS ALL DEFERRED;
-- Drop all sequences
DROP SEQUENCE SEQ_OLYMPICS;
DROP SEQUENCE SEQ_USER_ACCOUNT;
DROP SEQUENCE SEQ_SPORT;
DROP SEQUENCE SEQ_TEAM;
DROP SEQUENCE SEQ_VENUE;
DROP SEQUENCE SEQ_EVENT;
DROP SEQUENCE SEQ_COUNTRY;
DROP SEQUENCE SEQ_PARTICIPANT;
commit;
-- Create all sequences to be used on init
create SEQUENCE SEQ_OLYMPICS START WITH 1 INCREMENT BY 1 MINVALUE 1;
create SEQUENCE SEQ_USER_ACCOUNT START WITH 1 INCREMENT BY 1 MINVALUE 1;
create SEQUENCE SEQ_SPORT START WITH 1 INCREMENT BY 1 MINVALUE 1;
create SEQUENCE SEQ_TEAM START WITH 1 INCREMENT BY 1 MINVALUE 1;
create SEQUENCE SEQ_VENUE START WITH 1 INCREMENT BY 1 MINVALUE 1;
create SEQUENCE SEQ_EVENT START WITH 1 INCREMENT BY 1 MINVALUE 1;
create SEQUENCE SEQ_COUNTRY START WITH 1 INCREMENT BY 1 MINVALUE 1;
create SEQUENCE SEQ_PARTICIPANT START WITH 1 INCREMENT BY 1 MINVALUE 1;
commit;

INSERT INTO USER_ROLE values(1, 'Organizer');
INSERT INTO USER_ROLE values(2, 'Coach');
INSERT INTO USER_ROLE values(3, 'Guest');

INSERT INTO OLYMPICS values(SEQ_OLYMPICS.NEXTVAL,'XXXI','Rio de Janeiro','05-AUG-2016','21-AUG-2016','https://www.olympic.org/rio-2016'); --1
INSERT INTO OLYMPICS values(SEQ_OLYMPICS.NEXTVAL,'XXX','London','27-JUL-2012','12-AUG-2012','https://www.olympic.org/london-2012'); --2
INSERT INTO OLYMPICS values(SEQ_OLYMPICS.NEXTVAL,'XXIX','Beijing','08-AUG-2008','24-AUG-2008','https://www.olympic.org/beijing-2008'); --3
INSERT INTO OLYMPICS values(SEQ_OLYMPICS.NEXTVAL,'XXVIII','Athens','13-AUG-2004','29-AUG-2004','https://www.olympic.org/athens-2004'); --4
commit;

INSERT INTO SPORT values(SEQ_SPORT.NEXTVAL,'Archery, Team','Modern competitive target archery is governed by the World Archery Federation.','01-JAN-1900',3); --1
INSERT INTO SPORT values(SEQ_SPORT.NEXTVAL,'Archery, Ind.','Modern competitive target archery is governed by the World Archery Federation.','01-JAN-1900',1); --2
INSERT INTO SPORT values(SEQ_SPORT.NEXTVAL,'Badminton, Team','A racquet sport played using racquets to hit a shuttlecock across a net.','01-JAN-1992',2); --3
INSERT INTO SPORT values(SEQ_SPORT.NEXTVAL,'Badminton, Ind.','A racquet sport played using racquets to hit a shuttlecock across a net.','01-JAN-1992',1); --4
commit;

INSERT INTO MEDAL values(1,'GOLD',3);
INSERT INTO MEDAL values(2,'SILVER',2);
INSERT INTO MEDAL values(3,'BRONZE',1);
commit;

INSERT INTO VENUE values(SEQ_VENUE.NEXTVAL,1,'Sambódromo',36000); -- 2016 Archery
INSERT INTO VENUE values(SEQ_VENUE.NEXTVAL,1,'Riocentro – Pavilion 4',6500); -- 2016 Badminton
INSERT INTO VENUE values(SEQ_VENUE.NEXTVAL,2,'Royal Artillery Barracks',7500); -- 2012 Archery
INSERT INTO VENUE values(SEQ_VENUE.NEXTVAL,2,'Wembley Arena',6000); -- 2012 Badminton
INSERT INTO VENUE values(SEQ_VENUE.NEXTVAL,3,'Olympic Green Archery Field',5000); -- 2008 Archery
INSERT INTO VENUE values(SEQ_VENUE.NEXTVAL,3,'Beijing UOT Gymnasium',7500); -- 2008 Badminton
INSERT INTO VENUE values(SEQ_VENUE.NEXTVAL,4,'Panathenaic Stadium',7500); -- 2004 Archery
INSERT INTO VENUE values(SEQ_VENUE.NEXTVAL,4,'Goudi Olympic Hall',8000); -- 2004 Badminton
commit;

-- Insert Archery Events
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,1,1,0,to_date('06-AUG-2016 08:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,1,1,1,to_date('07-AUG-2016 08:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,2,1,0,to_date('05-AUG-2016 10:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,2,1,1,to_date('05-AUG-2016:12:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,1,3,0,to_date('27-JUL-2012 08:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,1,3,1,to_date('27-JUL-2012 10:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,2,3,0,to_date('27-JUL-2012 12:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,2,3,1,to_date('27-JUL-2012 14:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,1,5,0,to_date('09-AUG-2008 08:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,1,5,1,to_date('10-AUG-2008 08:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,2,5,0,to_date('09-AUG-2008 10:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,2,5,1,to_date('09-AUG-2008 12:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,1,7,0,to_date('15-AUG-2004 08:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,1,7,1,to_date('15-AUG-2004 10:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,2,7,0,to_date('15-AUG-2004 12:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,2,7,1,to_date('15-AUG-2004 14:00','dd-Mon-yyyy hh24:mi'));
commit;

-- Insert Badminton Events
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,3,2,0,to_date('11-AUG-2016 08:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,3,2,1,to_date('11-AUG-2016 10:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,4,2,0,to_date('11-AUG-2016 12:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,4,2,1,to_date('11-AUG-2016 14:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,3,4,0,to_date('28-JUL-2012 08:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,3,4,1,to_date('28-JUL-2012 10:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,4,4,0,to_date('28-JUL-2012 12:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,4,4,1,to_date('28-JUL-2012 14:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,3,6,0,to_date('09-AUG-2008 08:30','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,3,6,1,to_date('09-AUG-2008 10:30','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,4,6,0,to_date('09-AUG-2008 12:30','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,4,6,1,to_date('09-AUG-2008 14:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,3,8,0,to_date('14-AUG-2004 08:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,3,8,1,to_date('14-AUG-2004 10:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,4,8,0,to_date('14-AUG-2004 12:00','dd-Mon-yyyy hh24:mi'));
INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,4,8,1,to_date('14-AUG-2004 14:00','dd-Mon-yyyy hh24:mi'));
commit;

-- Insert Countries
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'South Korea','KOR'); --1
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'France','FRA'); --2
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'United States','USA'); --3
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Australia','AUS'); --4
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Chinese Taipei','TPE'); --5
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Russia','RUS'); --6
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'China','CHN'); --7
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Great Britain','GBR'); --8
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Malaysia','MAS'); --9
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Indonesia','INA'); --10
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Japan','JPN'); --11
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Denmark','DEN'); --12
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Spain','ESP'); --13
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'India','IND'); --14
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Italy','ITA'); --15
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Mexico','MEX'); --16
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Ukraine','UKR'); --17
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Netherlands','NED'); --18
INSERT INTO COUNTRY values(SEQ_COUNTRY.NEXTVAL,'Germany','GER'); --19
commit;

SET CONSTRAINTS ALL IMMEDIATE;

-- Insert Participants and Teams [Singular Placeholder Coach for all teams]
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'CFN1','CLN1','South Korea','Placeholder','01-JAN-1900'); --1
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'CFN2','CLN2','South Korea','Placeholder','01-JAN-1900'); --2
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'CFN3','CLN3','South Korea','Placeholder','01-JAN-1900'); --3
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'CFN4','CLN4','South Korea','Placeholder','01-JAN-1900'); --4
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'CFN5','CLN5','France','Placeholder','01-JAN-1900'); --5
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'CFN6','CLN6','United States','Placeholder','01-JAN-1900'); --6
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'CFN7','CLN7','Germany','Placeholder','01-JAN-1900'); --7
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'CFN8','CLN8','Russia','Placeholder','01-JAN-1900'); --8
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'CFN9','CLN9','United States','Placeholder','01-JAN-1900'); --9
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'CFN10','CLN10','Australia','Placeholder','01-JAN-1900'); --10
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'CFN11','CLN11','South Korea','Placeholder','01-JAN-1900'); --11
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'CFN12','CLN12','Chinese Taipei','Placeholder','01-JAN-1900'); --12
commit;

INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Ku','Bon-chan','South Korea','South Korea','31-JAN-1993'); --13
INSERT INTO TEAM values(SEQ_TEAM.NEXTVAL,1,'KOR Ind. Men Archery',1,2,1); --TEAM 1
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Lee','Seung-yun','South Korea','South Korea','18-APR-1995'); --14
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Kim','Woo-jin','South Korea','South Korea','20-JUN-1992'); --15
INSERT INTO TEAM values(SEQ_TEAM.NEXTVAL,1,'KOR Team Men Archery',1,1,2); --TEAM 2
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Chang','Hye-jin','South Korea','South Korea','13-MAY-1997'); --16
INSERT INTO TEAM values(SEQ_TEAM.NEXTVAL,1,'KOR Ind. Women Archery',1,2,3); --TEAM 3
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Choi','Mi-sun','South Korea','South Korea','01-JUL-1996'); --17
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Ki','Bo-bae','South Korea','South Korea','20-FEB-1988'); --18
INSERT INTO TEAM values(SEQ_TEAM.NEXTVAL,1,'KOR Team Women Archery',1,1,4); --TEAM 4
commit;

INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Jean-Charles','Valladont','France','France','20-MAR-1989'); --19
INSERT INTO TEAM values(SEQ_TEAM.NEXTVAL,1,'FRA Ind. Men Archery',2,2,5); --TEAM 5
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Brady','Ellison','United States','United States','12-OCT-1988'); --20
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Zach','Garrett','United States','United States','08-APR-1995'); --21
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Jake','Kaminski','United States','United States','11-AUG-1988'); --22
INSERT INTO TEAM values(SEQ_TEAM.NEXTVAL,1,'USA Team Men Archery',3,1,6); --TEAM 6
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Lisa','Unruh','Germany','Germany','12-APR-1988'); --23
INSERT INTO TEAM values(SEQ_TEAM.NEXTVAL,1,'GER Ind. Women Archery',19,2,7); --TEAM 7
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Tuyana','Dashidorzhieva','Russia','Russia','14-APR-1996'); --24
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Ksenia','Perova','Russia','Russia','08-FEB-1989'); --25
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Inna','Stepanova','Russia','Russia','17-APR-1990'); --26
INSERT INTO TEAM values(SEQ_TEAM.NEXTVAL,1,'RUS Team Women Archery',6,1,8); --TEAM 8
INSERT INTO TEAM values(SEQ_TEAM.NEXTVAL,1,'USA Ind. Men Archery',3,2,9); --TEAM 9
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Alec','Potts','Australia','Australia','19-FEB-1996'); --27
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Ryan','Tyack','Australia','Australia','02-Jun-1991'); --28
INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,'Taylor','Worth','Australia','Australia','08-JAN-1991'); --29
INSERT INTO TEAM values(SEQ_TEAM.NEXTVAL,1,'AUS Team Men Archery',4,1,10); --TEAM 10
INSERT INTO TEAM values(SEQ_TEAM.NEXTVAL,1,'KOR Ind. Women Archery',1,2,11); --TEAM 11
INSERT INTO TEAM values(SEQ_TEAM.NEXTVAL,1,'TPE Team Women Archery',5,1,12); --TEAM 12

INSERT INTO TEAM_MEMBER values(1,13);
INSERT INTO TEAM_MEMBER values(2,14);
INSERT INTO TEAM_MEMBER values(2,15);

INSERT INTO USER_ACCOUNT values(SEQ_USER_ACCOUNT.NEXTVAL, 'admin','admin',1,current_timestamp(3));
INSERT INTO USER_ACCOUNT values(SEQ_USER_ACCOUNT.NEXTVAL, 'user1','GUEST',3,current_timestamp(3));
INSERT INTO USER_ACCOUNT values(SEQ_USER_ACCOUNT.NEXTVAL, 'user3','worstpass',2,current_timestamp(3));
INSERT INTO USER_ACCOUNT values(SEQ_USER_ACCOUNT.NEXTVAL, 'user2','badpass',2,current_timestamp(3));

INSERT INTO EVENT_PARTICIPATION values(1,1,'e');
commit;
/