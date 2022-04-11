---------------------- CREATE_STATEMENTS ------------------------

CREATE TABLE IIT(
	id INT AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE Student(
	id INT AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	gender CHAR NOT NULL,
	dob DATE NOT NULL,
	institute_id INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (institute_id) REFERENCES IIT(id)
);

CREATE TABLE Team(
	id INT AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	cardinality INT NOT NULL,
	institute_id INT NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (institute_id) REFERENCES IIT(id)
);

CREATE TABLE Members(
	stu_id INT NOT NULL,
	team_id INT NOT NULL,
	PRIMARY KEY (stu_id, team_id),
	FOREIGN KEY (stu_id) REFERENCES Student(id),
	FOREIGN KEY (team_id) REFERENCES Team(id)
);

CREATE TABLE Event(
	id INT AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL,
	pos1_points INT NOT NULL,
	pos2_points INT NOT NULL,
	pos3_points INT NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE Individual_Event(
	id INT NOT NULL,
	pos1_stuid INT,
	pos2_stuid INT,
	pos3_stuid INT,
	PRIMARY KEY (id),
	FOREIGN KEY (id) REFERENCES Event(id),
	FOREIGN KEY (pos1_stuid) REFERENCES Student(id),
	FOREIGN KEY (pos2_stuid) REFERENCES Student(id),
	FOREIGN KEY (pos3_stuid) REFERENCES Student(id)
);

CREATE TABLE Team_Event(
	id INT NOT NULL,
	pos1_teamid INT,
	pos2_teamid INT,
	pos3_teamid INT,
	PRIMARY KEY (id),
	FOREIGN KEY (id) REFERENCES Event(id),
	FOREIGN KEY (pos1_teamid) REFERENCES Team(id),
	FOREIGN KEY (pos2_teamid) REFERENCES Team(id),
	FOREIGN KEY (pos3_teamid) REFERENCES Team(id)
);

CREATE TABLE Individual_Participation(
	stu_id INT NOT NULL,
	event_id INT NOT NULL,
	points INT NOT NULL,
	PRIMARY KEY (stu_id, event_id),
	FOREIGN KEY (stu_id) REFERENCES Student(id),
	FOREIGN KEY (event_id) REFERENCES Event(id)
);

CREATE TABLE Team_Participation(
	team_id INT,
	event_id INT NOT NULL,
	position INT,
	PRIMARY KEY (team_id),
	FOREIGN KEY (team_id) REFERENCES Team(id),
	FOREIGN KEY (event_id) REFERENCES Event(id)
);

----------------------SELECT_QUERIES----------------------------

----- Q1 -----
-- Here, since a student can be part of multiple events,
-- all such instances are listed. The final result is sorted by
-- IIT, then the Event, and then the student

SELECT I.name, E.name, S.id, S.name         -- Select the corresponding fields
FROM IIT as I, Event as E, Student as S, Team as T, Members as M, 
            Individual_Participation as IP, Team_Participation as TP -- Load the corresponding tables
WHERE (I.id = S.institute_id) AND           -- Match the student to the corresponding institute
    ((E.id = IP.event_id AND S.id = IP.stu_id) OR -- For each individual event, list the participants
    (M.team_id = T.id AND S.id = M.stu_id AND E.id = TP.event_id AND T.id = TP.team_id)) -- For each team event, list the members of the participating teams
ORDER BY I.name, E.name, S.id;  -- Sort the result by insti name

----- Q2 -----
-- Here, assuming one student can participate at most once in a particular team event,
-- we can directly count the membership of teams to count the number of team events. 
-- The final result is sorted by IIT, then the Event, and then the student

SELECT I.name, S.id, S.name
FROM Student S, Members M, Individual_Participation IP          -- Load the necessary tables
WHERE S.id = IP.participation_id OR S.id = M.participation_id   -- Individual event or team event
GROUP BY S.id
HAVING COUNT(*) <= 2;       -- Count
ORDER BY I.name, E.name, S.id;  -- Sort accordingly

------ Q3 ------

-- All students with 0 team events and at least 1 indi events are listed
-- in descending order of their number of events. All the indivdual events
-- they are participating in are listed

SELECT S.id, S.name, S.institute_id, E.name
FROM Event E, Student S, Members M, Individual_Participation IP     -- Load the tables
WHERE (SELECT COUNT(*) WHERE S.id = IP.stu_id) > 0 AND              -- Ensuring students with at least 1 individual event
        (SELECT COUNT(*) WHERE S.id = M.stu_id) = 0 AND             -- Ensuring students with no team events 
        IP.stu_id = S.id AND IP.event_id = E.id                     -- Matching the students with their events
ORDER BY (SELECT COUNT(*) WHERE S.id = IP.stu_id), E.name DESC;     -- Sort the results

------ Q4 ------

-- All students are listed along with their team event points and individual event points.
-- Use the points attribute in the 'Participation' Tables. They are then sorted accordingly. 

SELECT S.id, S.name, SUM(IP.points), SUM(TP.points) 
FROM Student S, Members M, Individual_Participation IP, Team T, Team_Participation TP
WHERE (IP.stu_id = S.id) AND                                            -- Their Individual event participations
      (TP.team_id = T.id) AND (M.team_id = T.id) AND (M.stu_id = S.id)  -- Their Team Participation
GROUP BY S.id                                                           -- Group the same student id together 
ORDER BY SUM(TP.points) ASC, SUM(IP.points) DESC;                       -- Order accordingly

------ Q5 ------

-- All IITs with more team event points than individual events are listed.
-- Using the points attribute in the 'Participation' Tables. They are then sorted accordingly. 

SELECT I.name, SUM(IP.points), SUM(TP.points) 
FROM Student S, Individual_Participation IP, Team T, Team_Participation TP
WHERE IP.stu_id = S.id AND I.id = S.institute_id    -- The individual participations from the IIT
    TP.team_id = T.id AND I.id = T.institute_id     -- The team participations from the IIT
GROUP BY I.name                                     -- Group those institutes having the same name and
HAVING SUM(IP.points) < SUM(TP.points)              -- more team points than individual points
ORDER BY I.name;                                    -- Order accordingly