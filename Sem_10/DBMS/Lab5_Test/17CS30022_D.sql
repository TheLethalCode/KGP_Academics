-- 17CS30022
-- Kousshik Raj


CREATE TABLE CS30022AXCZ
(
    painting_id INTEGER PRIMARY KEY,
    painting_name VARCHAR(50) NOT NULL,
    painting_type VARCHAR(50) NOT NULL,
    painting_start_date DATE NOT NULL
);

CREATE TABLE CS30022RTZ
(
    painter_cd INTEGER PRIMARY KEY,
    painter_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    date_of_death DATE
);

CREATE TABLE CS30022ICE3
(
    generation_cd INTEGER PRIMARY KEY,
    generation_name VARCHAR(50) NOT NULL,
    generation_start_date DATE NOT NULL,
    generation_end_date DATE
);

CREATE TABLE CS30022HLO
(
    wing_no INTEGER NOT NULL,
    room_no INTEGER NOT NULL,
    capacity INTEGER NOT NULL,
    PRIMARY KEY (wing_no, room_no)
);

CREATE TABLE CS30022WPP
(
    painting_id INTEGER,
    painter_cd INTEGER,
    PRIMARY KEY (painting_id, painter_cd),
    FOREIGN KEY (painting_id) REFERENCES CS30022AXCZ(painting_id),
    FOREIGN KEY (painter_cd) REFERENCES CS30022RTZ(painter_cd)
);

CREATE TABLE CS30022ACB
(
    wing_no INTEGER,
    room_no INTEGER,
    painting_id INTEGER,
    PRIMARY KEY (wing_no, room_no, painting_id),
    FOREIGN KEY (wing_no, room_no) REFERENCES CS30022HLO(wing_no, room_no),
    FOREIGN KEY (painting_id) REFERENCES CS30022AXCZ(painting_id)
);

CREATE TABLE CS30022MNO
(
    painting_id INTEGER,
    generation_cd INTEGER,
    PRIMARY KEY (painting_id, generation_cd),
    FOREIGN KEY (painting_id) REFERENCES CS30022AXCZ(painting_id),
    FOREIGN KEY (generation_cd) REFERENCES CS30022ICE3(generation_cd)
);
