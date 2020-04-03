-- Stephen Cheney sac295 4275535 --
-- Olympic Game Project --

---DROP ALL VIEWS TO MAKE SURE THE SCHEMA IS CLEAR
DROP MATERIALIZED VIEW MV_OLYMPICS_VENUE_EVENT_SPORT;
DROP MATERIALIZED VIEW MV_ALL_TEAM_INFO;

create MATERIALIZED VIEW MV_OLYMPICS_VENUE_EVENT_SPORT
    AS
    SELECT O.opening_date, S.dob
    FROM (((SPORT S join EVENT E on S.sport_id = E.sport_id) join Venue V on V.venue_id = E.venue_id) join Olympics O on O.olympic_id = V.olympic_id);

create or replace trigger ENFORCE_SPORT_CREATING_DATE
    AFTER INSERT on SPORT
    for each row
    declare opening date;
    creation date;
    BEGIN
         SELECT opening_date into opening FROM MV_OLYMPICS_VENUE_EVENT_SPORT;
         SELECT DOB into creation FROM MV_OLYMPICS_VENUE_EVENT_SPORT;
        IF creation > opening THEN
            RAISE_APPLICATION_ERROR( -20001, 'DOB of sport is after opening date.');
        END IF;
    end;
/

create or replace trigger ASSIGN_MEDAL
   BEFORE INSERT OR UPDATE ON SCOREBOARD
    for each row
    BEGIN
        if :new.position = 1 THEN
            update SCOREBOARD S
            set S.MEDAL_ID = 1
            where :new.position = 1;
        end if;
        if :new.position = 2 THEN
            update SCOREBOARD S
            set S.MEDAL_ID = 2
            where :new.position = 2;
        end if;
        if :new.position = 3 THEN
            update SCOREBOARD S
            set S.MEDAL_ID = 3
            where :new.position = 3;
        end if;
    end;
/

create or replace trigger ENFORCE_CAPACITY
   BEFORE INSERT on EVENT
    for each row
    declare cap integer;
            num_events integer;
    BEGIN
        SELECT CAPACITY into cap FROM VENUE where :new.venue_id = VENUE.VENUE_ID;
        SELECT count(EVENT_ID) INTO num_events from EVENT where :new.event_id = EVENT.event_id GROUP BY VENUE_ID ;
        if num_events >= cap then
            RAISE_APPLICATION_ERROR( -20002, 'Venue is at capacity, cannot create event');
        end if;
    end;
/

create MATERIALIZED VIEW MV_ALL_TEAM_INFO
AS
    SELECT TEAM.TEAM_ID, TEAM_SIZE,  STATUS, P.PARTICIPANT_ID FROM (
        TEAM JOIN TEAM_MEMBER TM on TEAM.TEAM_ID = TM.TEAM_ID
            JOIN PARTICIPANT P on TM.PARTICIPANT_ID = P.PARTICIPANT_ID
            JOIN SPORT ON TEAM.SPORT_ID = SPORT.SPORT_ID
            JOIN EVENT E on SPORT.SPORT_ID = E.SPORT_ID
            JOIN EVENT_PARTICIPATION EP on E.EVENT_ID = EP.EVENT_ID
            JOIN SCOREBOARD S on E.EVENT_ID = S.EVENT_ID)
        GROUP BY TEAM.TEAM_ID, P.PARTICIPANT_ID, TEAM.TEAM_ID, TEAM_SIZE, STATUS;



create or replace trigger ATHLETE_DISMISSAL
    BEFORE DELETE ON PARTICIPANT
    for each row
    BEGIN

    end;