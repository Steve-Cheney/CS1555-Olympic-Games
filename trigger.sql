-- Stephen Cheney sac295 4275535 --
-- Olympic Game Project --

---DROP ALL VIEWS AND TRIGGERS TO MAKE SURE THE SCHEMA IS CLEAR
--DROP MATERIALIZED VIEW MV_OLYMPICS_VENUE_EVENT_SPORT;
DROP MATERIALIZED VIEW MV_ALL_TEAM_INFO;
DROP MATERIALIZED VIEW MV_OLYMPIC_VENUES_DATES;
DROP MATERIALIZED VIEW MV_Venue_Events;
--DROP TRIGGER ENFORCE_SPORT_CREATING_DATE;
DROP TRIGGER ENFORCE_CAPACITY;
DROP TRIGGER ENFORCE_TEAM_SIZE;
DROP TRIGGER ASSIGN_MEDAL;
DROP TRIGGER ATHLETE_DISMISSAL;

DROP procedure proc_create_user;
DROP procedure proc_drop_user_userid;
DROP procedure proc_drop_user_usern;
drop procedure proc_create_event;
drop procedure proc_add_Event_Outcome;

commit;

/*
create MATERIALIZED VIEW MV_OLYMPICS_VENUE_EVENT_SPORT
    AS
    SELECT O.opening_date, S.dob
    FROM (((SPORT S join EVENT E on S.sport_id = E.sport_id) join Venue V on V.venue_id = E.venue_id) join Olympics O on O.olympic_id = V.olympic_id);

create or replace trigger ENFORCE_SPORT_CREATING_DATE
    AFTER INSERT on SPORT
    for each row
    declare opening date;
    creation date;
    ex_sport_creation_date exception;
    BEGIN
         SELECT opening_date into opening FROM MV_OLYMPICS_VENUE_EVENT_SPORT;
         SELECT DOB into creation FROM MV_OLYMPICS_VENUE_EVENT_SPORT;
        IF creation > opening THEN RAISE ex_sport_creation_date;
        END IF;
        Exception
            when ex_sport_creation_date then
                raise_application_error(-20001,'DOB of sport is after opening date');
    end;
/
*/

create or replace trigger ASSIGN_MEDAL
   BEFORE INSERT OR UPDATE ON SCOREBOARD
    for each row
    BEGIN
        if :new.medal_ID is null
           then
                if :new.position = 1 THEN
                    :new.MEDAL_ID := 1;
                end if;
                if :new.position = 2 THEN
                    :new.MEDAL_ID := 2;
                end if;
                if :new.position = 3 THEN
                    :new.MEDAL_ID := 3;
                end if;
            end if;
    end;
/

create MATERIALIZED VIEW MV_Venue_Events
AS
    SELECT V.Venue_ID, E.EVENT_ID FROM VENUE V JOIN EVENT E ON V.VENUE_ID=E.VENUE_ID GROUP BY V.Venue_ID, E.EVENT_ID;
/

-- Only one event can take place at a venue at a specific time
create or replace trigger ENFORCE_CAPACITY
   BEFORE INSERT on EVENT
    for each row
    declare
            timechk number;
            ex_venue_capacity exception;
    BEGIN
       select count(*)
        into timechk
        from EVENT
        where :new.EVENT_TIME = EVENT_TIME;
        if timechk > 0 then RAISE ex_venue_capacity;
        END IF;


        Exception
            when ex_venue_capacity then
                raise_application_error(-20002,'Venue is at capacity, cannot create event');

    end;
/

create MATERIALIZED VIEW MV_ALL_TEAM_INFO
AS
    SELECT TEAM.TEAM_ID, TEAM_SIZE as MAX_SIZE,  STATUS, P.PARTICIPANT_ID, count(P.PARTICIPANT_ID) as TEAM_TOTAL FROM (
        TEAM JOIN TEAM_MEMBER TM on TEAM.TEAM_ID = TM.TEAM_ID
            JOIN PARTICIPANT P on TM.PARTICIPANT_ID = P.PARTICIPANT_ID
            JOIN SPORT ON TEAM.SPORT_ID = SPORT.SPORT_ID
            JOIN EVENT E on SPORT.SPORT_ID = E.SPORT_ID
            JOIN EVENT_PARTICIPATION EP on E.EVENT_ID = EP.EVENT_ID
            JOIN SCOREBOARD S on E.EVENT_ID = S.EVENT_ID)
        GROUP BY TEAM.TEAM_ID, P.PARTICIPANT_ID, TEAM_SIZE, STATUS;
/

create MATERIALIZED VIEW MV_Olympic_Venues_DateS
AS
    SELECT O.OLYMPIC_ID, O.OPENING_DATE, VENUE_ID FROM OLYMPICS O JOIN VENUE ON O.OLYMPIC_ID = VENUE.OLYMPIC_ID GROUP BY O.OLYMPIC_ID, O.OPENING_DATE, VENUE_ID;
/


create or replace trigger ATHLETE_DISMISSAL
    BEFORE DELETE ON PARTICIPANT
    for each row
    declare team_max MV_ALL_TEAM_INFO.MAX_SIZE%type;
        team_cur MV_ALL_TEAM_INFO.TEAM_TOTAL%type;
        team_id_temp MV_ALL_TEAM_INFO.TEAM_ID%type;
    BEGIN
        delete from SCOREBOARD where SCOREBOARD.PARTICIPANT_ID = :old.PARTICIPANT_ID;
        select MAX_SIZE into team_max from MV_ALL_TEAM_INFO where MV_ALL_TEAM_INFO.PARTICIPANT_ID = :old.PARTICIPANT_ID;
        select TEAM_TOTAL into team_cur from MV_ALL_TEAM_INFO where MV_ALL_TEAM_INFO.PARTICIPANT_ID = :old.PARTICIPANT_ID;
        select TEAM_ID into team_id_temp from MV_ALL_TEAM_INFO where MV_ALL_TEAM_INFO.PARTICIPANT_ID = :old.PARTICIPANT_ID;

        if team_max = 1 then
            delete from TEAM where TEAM_ID = team_id_temp;
        end if;
        if team_max = team_cur then
            update EVENT_PARTICIPATION EP
            set status = 'n'
            where EP.TEAM_ID = team_id_temp;
        end if;
    end;
/

create or replace trigger ENFORCE_TEAM_SIZE
    AFTER INSERT ON PARTICIPANT
    for each row
    declare team_max MV_ALL_TEAM_INFO.MAX_SIZE%type;
        team_cur MV_ALL_TEAM_INFO.TEAM_TOTAL%type;
        team_id_temp MV_ALL_TEAM_INFO.TEAM_ID%type;
    BEGIN
        select MAX_SIZE into team_max from MV_ALL_TEAM_INFO where MV_ALL_TEAM_INFO.PARTICIPANT_ID = :new.PARTICIPANT_ID;
        select TEAM_TOTAL into team_cur from MV_ALL_TEAM_INFO where MV_ALL_TEAM_INFO.PARTICIPANT_ID = :new.PARTICIPANT_ID;
        select TEAM_ID into team_id_temp from MV_ALL_TEAM_INFO where MV_ALL_TEAM_INFO.PARTICIPANT_ID = :new.PARTICIPANT_ID;

        if team_max > team_cur then
            update EVENT_PARTICIPATION EP
            set status = 'n'
            where EP.TEAM_ID = team_id_temp;
        end if;
    end;
/

CREATE PROCEDURE proc_create_user (usern in USER_ACCOUNT.USERNAME%type, passk in USER_ACCOUNT.PASSKEY%type, roleid in USER_ACCOUNT.ROLE_ID%type)
    AS
    exisiting_creds exception;
    user_check number;
    BEGIN
        select count(*)
        into user_check
        from USER_ACCOUNT
        where usern = USERNAME;

            if user_check >=1 then RAISE exisiting_creds;
            END IF;
        insert into USER_ACCOUNT values(SEQ_USER_ACCOUNT.nextval,usern,passk,roleid,current_timestamp(3));
        Exception
            when exisiting_creds then
            raise_application_error(-20003,'Username taken, please try again');
    END;
/
--call proc_create_user('A','b',1);
commit;

CREATE PROCEDURE proc_drop_user_usern (usern in USER_ACCOUNT.USERNAME%type)
    AS
    does_not_exist exception;
    user_check number;
    BEGIN
        select count(*)
        into user_check
        from USER_ACCOUNT
        where usern = USERNAME;

            if user_check =0 then RAISE does_not_exist;
            END IF;
        DELETE FROM USER_ACCOUNT WHERE USERNAME = usern;

        Exception
            when does_not_exist then
            raise_application_error(-20004,'Username does not exist, please try again');
    END;
/
commit;

CREATE PROCEDURE proc_drop_user_userid (userid in USER_ACCOUNT.USER_ID%type)
    AS
    does_not_exist exception;
    user_check number;
    BEGIN
        select count(*)
        into user_check
        from USER_ACCOUNT
        where user_id = userid;

            if user_check = 0 then RAISE does_not_exist;
            END IF;
        DELETE FROM USER_ACCOUNT WHERE USER_ID = userid;

        Exception
            when does_not_exist then
            raise_application_error(-20005,'User ID does not exist, please try again');
    END;
/
commit;

CREATE PROCEDURE proc_create_event (sid in SPORT.SPORT_ID%type, vid in VENUE.VENUE_ID%type, dat date, gen in EVENT.GENDER%type)
    AS
    sid_dne exception;
    vid_dne exception;
    dat_err exception;
    gen_dne exception;

    sidchk number;
    vidchk number;
    datchk date;

    BEGIN
        select count(*)
        into sidchk
        from SPORT
        where SPORT_ID = sid;
        if sidchk = 0 then RAISE sid_dne;
        END IF;
        select count(*)
        into vidchk
        from VENUE
        where VENUE_ID = vid;
        if vidchk = 0 then RAISE vid_dne;
        END IF;

        IF NOT(gen BETWEEN 0 AND 1) THEN RAISE gen_dne;
        END IF;

        SELECT OPENING_DATE INTO datchk FROM MV_OLYMPIC_VENUES_DATES where VENUE_ID = vid;
        if dat < datchk THEN RAISE dat_err;
        END IF;

        INSERT INTO EVENT values(SEQ_EVENT.NEXTVAL,sid,vid,gen,dat);

        Exception
            when sid_dne then
            raise_application_error(-20006,'Sport ID does not exist, please try again');
            when vid_dne then
            raise_application_error(-20007,'Venue ID does not exist, please try again');
            when gen_dne then
            raise_application_error(-20008,'Gender entered incorrectly, please enter 0 for Mens or 1 for Womans');
            when dat_err then
            raise_application_error(-20009,'Event cannot be before opening date of Olympics, please try again: ' || datchk || ' is listed start date,'
                                               || CHR(10) || 'you entered: ' || dat);
    END;
/
commit;

CREATE PROCEDURE proc_add_Event_Outcome (oid OLYMPICS.OLYMPIC_ID%type, teamid TEAM.TEAM_ID%type, eid EVENT.EVENT_ID%type,
 pid PARTICIPANT.PARTICIPANT_ID%type, pos SCOREBOARD.POSITION%type)
    AS
        oidchk number;
        teamidchk number;
        eidchk number;
        pidchk number;
        teammemchk number;

        oid_dne exception;
        teamid_dne exception;
        eid_dne exception;
        pid_dne exception;
        notateammem exception;
    BEGIN
        select count(*)
        into oidchk
        from OLYMPICS
        where OLYMPIC_ID = oid;
        if oidchk = 0 then RAISE oid_dne;
        END IF;

        select count(*)
        into teamidchk
        from TEAM
        where TEAM_ID = oid;
        if teamidchk = 0 then RAISE teamid_dne;
        END IF;

        select count(*)
        into eidchk
        from EVENT
        where EVENT_ID = eid;
        if eidchk = 0 then RAISE eid_dne;
        END IF;

        select count(*)
        into pidchk
        from PARTICIPANT
        where PARTICIPANT_ID = pid;
        if pidchk = 0 then RAISE pid_dne;
        END IF;

        select count(*)
        into teammemchk
        from TEAM_MEMBER
        where TEAM_ID = teamid AND PARTICIPANT_ID = pid;
        if teammemchk = 0 then RAISE notateammem;
        END IF;

        INSERT INTO SCOREBOARD(OLYMPIC_ID, EVENT_ID, TEAM_ID, PARTICIPANT_ID, POSITION) values(oid,eid,teamid,pid,pos);

        Exception
            when oid_dne then
                raise_application_error(-20010,'Olympic ID does not exist, please try again');
            when teamid_dne then
                raise_application_error(-20011,'Team ID does not exist, please try again');
            when eid_dne then
                raise_application_error(-20012,'Event ID does not exist, please try again');
            when pid_dne then
                raise_application_error(-20013,'Participant ID does not exist, please try again');
            when notateammem then
                raise_application_error(-20014,'Listed Participant is not part of listed Team, please try again');
    END;
/
commit;