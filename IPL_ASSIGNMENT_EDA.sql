SELECT DISTINCT striker from match_data; -- 637
SELECT DISTINCT bowler from match_data; -- 537

SELECT DISTINCT striker from match_data WHERE STRIKER IN (SELECT DISTINCT bowler from match_data); -- 446, Players who does both batting and bowling
SELECT DISTINCT bowler from match_data WHERE bowler IN (SELECT DISTINCT striker from match_data); -- 446
 
-- ##batsman who is not a bowler 
SELECT COUNT(DISTINCT STRIKER) as total_batsman FROM  match_data WHERE STRIKER NOT IN (SELECT DISTINCT BOWLER FROM match_data) -- 191

-- ##bowler who is not a batsman
SELECT COUNT(DISTINCT bowler) as total_bowler FROM  match_data WHERE bowler NOT IN (SELECT DISTINCT striker FROM match_data) -- 57

## all rounders players
SELECT COUNT(DISTINCT striker) as total_all_rounder from match_data WHERE STRIKER IN (SELECT DISTINCT bowler from match_data); -- 

SELECT SUM(IPL.total_batsman) AS TOTAL_IPL_PLAYERS -- 694
FROM
(
SELECT COUNT(DISTINCT STRIKER) as total_batsman FROM  match_data WHERE STRIKER NOT IN (SELECT DISTINCT BOWLER FROM match_data) -- 191
UNION
SELECT COUNT(DISTINCT bowler) as total_bowler FROM  match_data WHERE bowler NOT IN (SELECT DISTINCT striker FROM match_data) -- 57
UNION
SELECT COUNT(DISTINCT striker) as total_all_rounder from match_data WHERE STRIKER IN (SELECT DISTINCT bowler from match_data) -- 446
) AS IPL;

## all rounder who is batsman actually
CREATE VIEW BATSMAN_ALL_ROUNDER_OVERRALL AS
SELECT m.striker,count(distinct m.match_id) as total_matches_played,sum(runs_off_bat) as total_runs_scored,bowlers.total_wickets_taken AS total_batsman_wicket
FROM match_data m
JOIN (
    SELECT DISTINCT BOWLER,count(case when wicket_type is not NULL then 1 end) as total_wickets_taken
    FROM match_data
    GROUP BY 1
) AS bowlers
ON m.STRIKER = bowlers.BOWLER
GROUP BY 1 
ORDER BY 2 DESC;

SELECT * FROM BATSMAN_ALL_ROUNDER_OVERRALL;

## all rounder who is bowler actually
CREATE VIEW BOWLER_ALL_ROUNDER_OVERRALL AS
SELECT m.bowler,count(distinct m.match_id) as total_matches_played,count(case when wicket_type is not NULL then 1 end) as total_wickets_taken,strikers.total_runs_scored as total_bowler_runs
FROM match_data m
JOIN (
    SELECT DISTINCT STRIKER,sum(runs_off_bat) as total_runs_scored
    FROM match_data
    GROUP BY 1
) AS strikers
ON m.bowler = strikers.STRIKER
GROUP BY 1 
ORDER BY 2 DESC;

SELECT * FROM BATSMAN_ALL_ROUNDER_OVERRALL;
SELECT * FROM BOWLER_ALL_ROUNDER_OVERRALL;


## overrall all-rounder data

DROP VIEW BATSMAN_BOWLER_ALL_ROUNDER_OVERRALL;
CREATE VIEW BATSMAN_BOWLER_ALL_ROUNDER_OVERRALL AS
SELECT BAA.striker AS all_rounder_name,BAA.total_matches_played,BAA.total_runs_scored,BOA.total_wickets_taken,
ROUND(BAA.total_matches_played/237,2) as match_played_ratio,
ROUND(BAA.total_runs_scored/7273,2) as runs_ratio,
ROUND(BOA.total_wickets_taken/207,2) as wick_ratio,
ROUND(((BAA.total_matches_played/237) + (BAA.total_runs_scored/7273) + (BOA.total_wickets_taken/207)),2) as capab_ratio
FROM BATSMAN_ALL_ROUNDER_OVERRALL AS BAA
LEFT JOIN BOWLER_ALL_ROUNDER_OVERRALL AS BOA ON BAA.striker = BOA.bowler
ORDER BY 8 DESC;

