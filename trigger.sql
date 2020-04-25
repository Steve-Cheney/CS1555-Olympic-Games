-- Stephen Cheney sac295 4275535 --
-- Olympic Game Project --

---DROP ALL VIEWS AND TRIGGERS TO MAKE SURE THE SCHEMA IS CLEAR
DROP MATERIALIZED VIEW MV_ALL_TEAM_INFO;
DROP MATERIALIZED VIEW MV_OLYMPIC_VENUES_DATES;
DROP MATERIALIZED VIEW MV_Venue_Events;
DROP TRIGGER ENFORCE_CAPACITY;
DROP TRIGGER ASSIGN_MEDAL;
DROP TRIGGER ATHLETE_DISMISSAL;

DROP procedure proc_create_user;
DROP procedure proc_drop_user_userid;
DROP procedure proc_drop_user_usern;
drop procedure proc_create_event;
drop procedure proc_add_Event_Outcome;
drop procedure PROC_create_team;
drop procedure proc_register_Team;
drop procedure proc_add_Participant;
drop procedure proc_add_Team_Member;
drop procedure proc_drop_Team_member;
drop procedure proc_login;
drop procedure proc_logout;
drop procedure proc_display_Event;
drop procedure proc_display_sport;
drop procedure proc_topk_athletes;

commit;

create trigger ASSIGN_MEDAL
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
create trigger ENFORCE_CAPACITY
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


create trigger ATHLETE_DISMISSAL
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
        where TEAM_ID = teamid;
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

CREATE PROCEDURE proc_create_Team (city in OLYMPICS.HOST_CITY%type, year number, sid SPORT.SPORT_ID%type,
                    cid in COUNTRY.COUNTRY_ID%type, name in TEAM.TEAM_NAME%type, coachid in TEAM.COACH_ID%type)
    AS
        oid number;
        oidchk number;
        sidchk number;
        cidchk number;
        coachidchk number;
        teamnamechk number;
        yearchk date;

        oid_dne exception;
        sid_dne exception;
        cid_dne exception;
        coachid_dne exception;
        teamname_err exception;
    BEGIN

        yearchk := to_date(year,'YYYY');
        SELECT OLYMPIC_ID INTO oid FROM OLYMPICS WHERE HOST_CITY = city AND yearchk = to_DATE(EXTRACT(year from OPENING_DATE), 'YYYY');

        select count(*)
        into oidchk
        from OLYMPICS
        where OLYMPIC_ID = oid;
        if oidchk = 0 then RAISE oid_dne;
        END IF;

        select count(*)
        into coachidchk
        from PARTICIPANT
        where PARTICIPANT_ID = coachid;
        if coachidchk = 0 then RAISE coachid_dne;
        END IF;

        select count(*)
        into sidchk
        from SPORT
        where SPORT_ID = sid;
        if sidchk = 0 then RAISE sid_dne;
        END IF;

        select count(*)
        into cidchk
        from COUNTRY
        where COUNTRY_ID = cid;
        if cidchk = 0 then RAISE cid_dne;
        END IF;

        select count(*)
        into teamnamechk
        from TEAM
        where TEAM_NAME = name;
        if teamnamechk > 0 then RAISE teamname_err;
        END IF;

        INSERT INTO TEAM values(SEQ_TEAM.NEXTVAL, oid, name, cid, sid, coachid);

        Exception
            when oid_dne then
                raise_application_error(-20015,'Olympic ID does not exist, please try again');
            when sid_dne then
                raise_application_error(-20016,'Sport ID does not exist, please try again');
            when cid_dne then
                raise_application_error(-20017,'Country ID does not exist, please try again');
            when coachid_dne then
                raise_application_error(-20018,'Coach ID does not exist, please try again');
            when teamname_err then
                raise_application_error(-20019,'Team name already exists, please try again');
    END;
/
commit;

CREATE PROCEDURE proc_register_Team (tid in TEAM.TEAM_ID%type, eid in EVENT.EVENT_ID%type)
    AS
    tidchk number;
    eidchk number;
    tid_dne exception;
    eid_dne exception;

    BEGIN

        select count(*)
        into tidchk
        from TEAM
        where TEAM_ID = tid;
        if tidchk = 0 then RAISE tid_dne;
        END IF;

        select count(*)
        into eidchk
        from EVENT
        where EVENT_ID = eid;
        if eidchk = 0 then RAISE eid_dne;
        END IF;

        INSERT INTO EVENT_PARTICIPATION values(eid,tid,'e');

        Exception
            when tid_dne then
                raise_application_error(-20020,'Team ID does not exist, please try again');
            when eid_dne then
                raise_application_error(-20021,'Event ID does not exist, please try again');
    END;
/
commit;

CREATE PROCEDURE proc_add_Participant (fname_ in PARTICIPANT.FNAME%type, lname_ in Participant.LNAME%type,
        nat in PARTICIPANT.NATIONALITY%type, bp in PARTICIPANT.BIRTH_PLACE%type, dob_ in PARTICIPANT.DOB%type)
    AS

    BEGIN
        INSERT INTO PARTICIPANT values(SEQ_PARTICIPANT.NEXTVAL,fname_,lname_,nat,bp,dob_);
    END;
/
commit;

CREATE PROCEDURE proc_add_Team_Member (tid in TEAM.TEAM_ID%type, pid in PARTICIPANT.PARTICIPANT_ID%type)
    AS
    tidchk number;
    pidchk number;
    tid_dne exception;
    pid_dne exception;

    BEGIN

        select count(*)
        into tidchk
        from TEAM
        where TEAM_ID = tid;
        if tidchk = 0 then RAISE tid_dne;
        END IF;

        select count(*)
        into pidchk
        from PARTICIPANT
        where PARTICIPANT_ID = pid;
        if pidchk = 0 then RAISE pid_dne;
        END IF;

        INSERT INTO TEAM_MEMBER values(tid,pid);

        Exception
            when tid_dne then
                raise_application_error(-20022,'Team ID does not exist, please try again');
            when pid_dne then
                raise_application_error(-20023,'Participant ID does not exist, please try again');
    END;
/
commit;

CREATE PROCEDURE proc_drop_Team_Member (pid in PARTICIPANT.PARTICIPANT_ID%type)
    AS
    pidchk number;
    pid_dne exception;

    BEGIN

        select count(*)
        into pidchk
        from PARTICIPANT
        where PARTICIPANT_ID = pid;
        if pidchk = 0 then RAISE pid_dne;
        END IF;

        delete from PARTICIPANT WHERE pid = PARTICIPANT_ID;

        Exception
            when pid_dne then
                raise_application_error(-20024,'Participant ID does not exist, please try again');
    END;
/
commit;

-- Administrators may have a coach or guest role with another account, which is why they must specify roleid
CREATE PROCEDURE proc_login (user_ in USER_ACCOUNT.USERNAME%type, pass_ in USER_ACCOUNT.PASSKEY%type, roleid number)
    AS
    userchk number;
    passchk number;
    combchk number;
    login_err exception;

    BEGIN

        select count(*)
        into userchk
        from USER_ACCOUNT
        where USERNAME = user_;
        if userchk = 0 then RAISE login_err;
        END IF;

        select count(*)
        into passchk
        from USER_ACCOUNT
        where PASSKEY = pass_;
        if passchk = 0 then RAISE login_err;
        END IF;

        select count(*)
        into combchk
        from USER_ACCOUNT
        where PASSKEY = pass_ and USERNAME = user_ and ROLE_ID = roleid;
        if combchk = 0 then RAISE login_err;
        END IF;

        Exception
            when login_err then
                raise_application_error(-20025,'Your username, password, or role does not match');
    END;
/
commit;

CREATE PROCEDURE proc_logout (user_ in USER_ACCOUNT.USERNAME%type, pass_ in USER_ACCOUNT.PASSKEY%type)
    AS
    userchk number;
    passchk number;
    combchk number;
    login_err exception;

    BEGIN

        select count(*)
        into userchk
        from USER_ACCOUNT
        where USERNAME = user_;
        if userchk = 0 then RAISE login_err;
        END IF;

        select count(*)
        into passchk
        from USER_ACCOUNT
        where PASSKEY = pass_;
        if passchk = 0 then RAISE login_err;
        END IF;

        select count(*)
        into combchk
        from USER_ACCOUNT
        where PASSKEY = pass_ and USERNAME = user_;
        if passchk = 0 then RAISE login_err;
        END IF;

        UPDATE USER_ACCOUNT
        SET LAST_LOGIN = current_timestamp(3)
        WHERE PASSKEY = pass_ and USERNAME = user_;

        Exception
            when login_err then
                raise_application_error(-20026,'Error on logout');
    END;
/
commit;

CREATE procedure proc_display_sport(name in SPORT.SPORT_NAME%type)
    AS
    namechk number;
    name_dne exception;
    sid number;
    dob_ date;
    gen number;
    gen_out varchar2(10);


    Cursor cur_Sport IS SELECT S.OLYMPIC_ID, S.EVENT_ID, E.GENDER, (P.FNAME|| ' ' || P.LNAME) as fullNAME, S.MEDAL_ID FROM SCOREBOARD S JOIN EVENT E ON S.EVENT_ID = E.EVENT_ID JOIN PARTICIPANT P on S.PARTICIPANT_ID = P.PARTICIPANT_ID JOIN SPORT SP on E.SPORT_ID = SP.SPORT_ID
                            WHERE SP.SPORT_NAME = name AND S.MEDAL_ID Is NOT NULL
                            GROUP BY S.OLYMPIC_ID, S.EVENT_ID, E.GENDER,S.MEDAL_ID, P.FNAME|| ' ' || P.LNAME ORDER BY S.OLYMPIC_ID ASC, S.EVENT_ID ASC, S.MEDAL_ID ASC;
    v_emp_rec cur_Sport%ROWTYPE;

        BEGIN
        OPEN cur_Sport;
        select count(*)
        into namechk
        from SPORT
        where SPORT_NAME = name;
        if namechk = 0 then RAISE name_dne;
        END IF;

        SELECT SPORT_ID INTO sid FROM SPORT WHERE SPORT_NAME = name;
        SELECT DOB INTO dob_ FROM SPORT WHERE sid = SPORT_ID;
        dbms_output.put_line('Added: ' || dob_);

        -- A PL/SQL cursor

          LOOP
            FETCH cur_Sport into v_emp_rec;
            EXIT WHEN cur_Sport%NOTFOUND;
            v_emp_rec.GENDER := gen;
            if gen = 0 THEN gen_out := 'Male'; END IF;
            if gen = 1 THEN gen_out := 'Female'; END IF;
            DBMS_OUTPUT.PUT_LINE('Olympic ID = ' || v_emp_rec.OLYMPIC_ID || ', Event ID = ' || v_emp_rec.EVENT_ID ||', Gender = ' || gen_out || ', Place = ' || v_emp_rec.MEDAL_ID || ': ' || v_emp_rec.fullNAME);

        END LOOP;
        close cur_Sport;
        Exception
            when name_dne then
                raise_application_error(-20027,'Sport entered does not exist, please try again');
    END;
/
commit;


CREATE PROCEDURE proc_display_Event (city OLYMPICS.HOST_CITY%type, year number, eid EVENT.EVENT_ID%type)
    AS
    yearchk date;
    oid number;
    oidchk number;
    num varchar2(30);
    event_name varchar2(45);
    oid_dne exception ;

    Cursor cur_Event IS
    SELECT FNAME || ' ' || LNAME as fullname, MEDAL_TITLE FROM PARTICIPANT JOIN SCOREBOARD S on PARTICIPANT.PARTICIPANT_ID = S.PARTICIPANT_ID
        JOIN MEDAL M on S.MEDAL_ID = M.MEDAL_ID WHERE S.EVENT_ID = eid and S.MEDAL_ID IS NOT NULL ORDER by S.MEDAL_ID;
    v_emp_rec cur_Event%ROWTYPE;
    BEGIN
       OPEN cur_Event;
        yearchk := to_date(year,'YYYY');
        SELECT OLYMPIC_ID INTO oid FROM OLYMPICS WHERE HOST_CITY = city AND yearchk = to_DATE(EXTRACT(year from OPENING_DATE), 'YYYY');

        select count(*)
        into oidchk
        from OLYMPICS
        where OLYMPIC_ID = oid;
        if oidchk = 0 then RAISE oid_dne;
        END IF;

        SELECT SPORT_NAME INTO event_name FROM SPORT JOIN EVENT E on SPORT.SPORT_ID = E.SPORT_ID;

        SELECT OLYMPIC_NUM into num FROM OLYMPICS WHERE OLYMPIC_ID = oid;
        Loop
            fetch cur_Event into v_emp_rec;
            EXIT WHEN cur_Event%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE( num || ', ' || event_name || ', ' || v_emp_rec.fullname || ', ' || v_emp_rec.MEDAL_TITLE);
        end loop;
       close cur_Event;
        Exception
            when oid_dne then
                raise_application_error(-20028,'Olympic ID does not exist, please try again');
    END;
/
commit;

CREATE procedure proc_topk_athletes(OID in OLYMPICS.OLYMPIC_ID%type, k number)
    AS
    oidchk number;
    oid_dne exception;

    Cursor cur_topk IS
    SELECT SCOREBOARD.OLYMPIC_ID, FNAME || ' ' || LNAME as fullname, NVL(Sum(MEDAL.Points),0) as score, count(case MEDAL.Medal_ID when 1 then 1 else null end) as Gold, count(case MEDAL.Medal_ID when 2 then 1 else null end) as Silver, count(case MEDAL.Medal_ID when 3 then 1 else null end) as Bronze
    FROM SCOREBOARD JOIN MEDAL ON SCOREBOARD.MEDAL_ID = MEDAL.MEDAL_ID JOIN PARTICIPANT P on SCOREBOARD.PARTICIPANT_ID = P.PARTICIPANT_ID where rownum <= k GROUP BY OLYMPIC_ID, FNAME || ' ' || LNAME ORDER BY NVL(Sum(MEDAL.Points),0) DESC;
    v_emp_rec cur_topk%ROWTYPE;

        BEGIN
        OPEN cur_topk;
        select count(*)
        into oidchk
        from OLYMPICS
        where OLYMPIC_ID = oid;
        if oidchk = 0 then RAISE oid_dne;
        END IF;

          LOOP
            FETCH cur_topk into v_emp_rec;
            EXIT WHEN cur_topk%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE('Olympic ID = ' || v_emp_rec.OLYMPIC_ID || ', ' || v_emp_rec.fullname || ': Points: ' || v_emp_rec.score || '| Gold: ' || v_emp_rec.Gold || '| Silver: ' || v_emp_rec.Silver || '| Bronze: ' || v_emp_rec.Bronze);

        END LOOP;
        close cur_topk;
        Exception
            when oid_dne then
                raise_application_error(-20029,'Olympic ID entered does not exist, please try again');
    END;
/
commit;

