create database cricket;
use cricket;

CREATE TABLE match_data (
    match_id INT,
    season VARCHAR(255),
    start_date VARCHAR(255),
    venue VARCHAR(255),
    innings INT,
    ball INT,
    batting_team VARCHAR(255),
    bowling_team VARCHAR(255),
    striker VARCHAR(255),
    non_striker VARCHAR(255),
    bowler VARCHAR(255),
    runs_off_bat INT,
    extras INT,
    wides INT,
    noballs INT,
    byes INT,
    legbyes INT,
    penalty INT,
    wicket_type VARCHAR(255),
    player_dismissed VARCHAR(255),
    other_wicket_type VARCHAR(255),
    cricsheet_id INT
);

select * from match_data ; 
SELECT SUM(runs_off_bat) AS TotalRuns FROM match_data WHERE striker = 'S Dube';

update match_data
set start_date = str_to_date(start_date, '%d-%m-%Y');

set global local_infile=true;
SET GLOBAL local_infile=1;

LOAD DATA LOCAL INFILE "C:/Users/jwala/Downloads/Interview Assignment- Data Analyst/match_data.csv"
INTO TABLE match_data
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


CREATE TABLE match_info (
    id INT,
    season VARCHAR(255),
    city VARCHAR(255),
    match_date VARCHAR(255),
    team1 VARCHAR(255),
    team2 VARCHAR(255),
    toss_winner VARCHAR(255),
    toss_decision VARCHAR(255),
    result VARCHAR(255),
    dl_applied int,
    winner VARCHAR(255),
    win_by_runs INT,
    win_by_wickets INT,
    player_of_match VARCHAR(255),
    venue VARCHAR(255),
    umpire1 VARCHAR(255),
    umpire2 VARCHAR(255),
    umpire3 VARCHAR(255)
);
SELECT * FROM match_info;

LOAD DATA LOCAL INFILE "C:/Users/jwala/Downloads/Interview Assignment- Data Analyst/match_info_data.csv"
INTO TABLE match_info
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

update match_info
set match_date = str_to_date(match_date, '%d-%m-%Y');