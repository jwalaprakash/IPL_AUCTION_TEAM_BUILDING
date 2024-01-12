## season wise top 10 batsman

CREATE VIEW top_10_batsman_season_wise AS
SELECT ipl_bat.* FROM
(
select season,striker,
count(distinct match_id) as total_matches_played,
sum(runs_off_bat) as total_runs_scored,
ceil(sum(runs_off_bat) /count(distinct match_id)) as batting_avg,
dense_rank() OVER(partition by season order by sum(runs_off_bat) DESC) AS run_rnk 
from match_data 
where STRIKER IN (SELECT DISTINCT STRIKER  FROM  match_data WHERE STRIKER NOT IN (SELECT DISTINCT BOWLER FROM match_data))
group by 1,2 order by 1 desc,4 desc
) AS ipl_bat where run_rnk <=10; 

## overrall top 10 batsman

DROP view top_10_batsman_overrall;
create view top_10_batsman_overrall AS
SELECT ipl_bat.* FROM
(
select striker,
count(distinct match_id) as total_matches_played,
sum(runs_off_bat) as total_runs_scored,
ceil(sum(runs_off_bat) /count(distinct match_id)) as batting_avg,
dense_rank() OVER(order by sum(runs_off_bat) DESC) AS run_rnk 
from match_data 
where STRIKER IN (SELECT DISTINCT STRIKER  FROM  match_data WHERE STRIKER NOT IN (SELECT DISTINCT BOWLER FROM match_data))
group by 1 order by 3 desc
) AS ipl_bat where run_rnk <=10; 

## season wise top 10 wicket taker

DROP VIEW top_10_bowler_season_wise;
create view top_10_bowler_season_wise AS
SELECT ipl_wick.* FROM
(
select season,bowler,
count(distinct match_id) as total_matches_played,
count(case when wicket_type is not NULL then 1 end) as total_wickets_taken,
ceil(count(case when wicket_type is not NULL then 1 end) /count(distinct match_id)) as wick_avg,
dense_rank() OVER(partition by season order by count(case when wicket_type is not NULL then 1 end) DESC) AS wick_rnk 
from match_data 
where BOWLER IN (SELECT DISTINCT BOWLER  FROM  match_data WHERE BOWLER NOT IN (SELECT DISTINCT STRIKER FROM match_data))
group by 1,2 order by 1 desc,4 desc
) AS ipl_wick where wick_rnk <=10; 

## overrall top 10 bowler

DROP VIEW top_10_bowler_overrall
create view top_10_bowler_overrall AS
SELECT ipl_wick.* FROM
(
select bowler,
count(distinct match_id) as total_matches_played,
count(case when wicket_type is not NULL then 1 end) as total_wickets_taken,
ceil(count(case when wicket_type is not NULL then 1 end) /count(distinct match_id)) as wick_avg,
dense_rank() OVER(order by count(case when wicket_type is not NULL then 1 end) DESC) AS wick_rnk 
from match_data 
where BOWLER IN (SELECT DISTINCT BOWLER  FROM  match_data WHERE BOWLER NOT IN (SELECT DISTINCT STRIKER FROM match_data))
group by 1 order by 3 desc
) AS ipl_wick where wick_rnk <=10; 


DROP VIEW TOP_20_BATSMAN_BOWLER_ALL_ROUNDER_OVERRALL;
CREATE VIEW TOP_20_BATSMAN_BOWLER_ALL_ROUNDER_OVERRALL AS
SELECT *,DENSE_RANK() OVER(ORDER BY capab_ratio DESC) AS capab_ratio_rank
FROM BATSMAN_BOWLER_ALL_ROUNDER_OVERRALL
LIMIT 20;