-- create table with data import wizard. prior to import clean/align data in .csv file to ensure no duplications, appropriate data types, etc.

-- dataset: https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset
-- objective: as someone passionate about listening, sharing, and recording music, i wanted to explore spotify data for trends and patterns
-- some metrics such as instrumentalness is not measured for every song. we could DELETE FROM table WHERE instrumentalness = 0; but for now we will leave it
	-- the data here is from the top tracks on spotify from 1998-2020
	-- hopefully, we will be able to quantify a correlation between popularity and other song features, as well as release strategy 

-- preliminary exploration
SELECT * FROM songdata;
SELECT COUNT(*) FROM songdata;
SELECT DISTINCT artist FROM songdata;
SELECT COUNT(DISTINCT artist) FROM songdata; 
SELECT MIN(year) from songdata;
SELECT MAX(year) from songdata;

SELECT AVG(duration_ms) FROM songdata;
SELECT MAX(duration_ms) FROM songdata;
SELECT MIN(duration_ms) FROM songdata;

-- top 25 songs of this era
SELECT * 
FROM songdata
ORDER BY popularity DESC
LIMIT 25; 

-- top 10 artists of this era
SELECT artist, COUNT(artist) AS hits, AVG(popularity) AS avg_popularity, AVG(danceability) AS avg_danceability, AVG(energy) AS avg_energy, AVG(duration_ms) AS avg_duration 
FROM songdata
GROUP BY artist
ORDER BY hits DESC
LIMIT 10;

-- we notice that all these top artists mainly stick to 3-4 minutes a song
-- the avg popularity, danceability, and energy all hovers around 70%. this is likely to create a digestible, familiar product that is not polarizing 

-- top genres of this era (pop, hip hop, r&b)
SELECT DISTINCT genre, COUNT(genre) AS genre_count 
FROM songdata
GROUP BY genre
ORDER BY genre_count DESC;

-- hip hop exploration for my own curiosity
SELECT artist, song, year, popularity, danceability, tempo, genre, AVG(danceability) AS how_danceable 
FROM songdata 
WHERE genre LIKE '%hip hop%' AND popularity > '65'
ORDER BY popularity;

SELECT artist, song, year, popularity, danceability, tempo, genre 
FROM songdata 
WHERE genre LIKE '%hip hop%' AND popularity < '65'
ORDER BY popularity;

SELECT artist, song, year, MAX(popularity), danceability, tempo, genre 
FROM songdata 
WHERE genre LIKE '%hip hop%';
-- most popular hip hop song is from 1999, yet hip hop is still a top 2 genre

-- can you make a hit song with no profanity? (yes) however, i think this is more prevalent for the very biggest hits since these clean titles can be consumed by all ages
-- hypothesis: in median popularity, explicit songs are still very prevalent
SELECT 
COUNT(*) AS explicit_songs
FROM songdata
WHERE explicit = 'true';

-- hypothesis: songs with higher tempo/danceability tend to fare better on the charts due to their replay value in social settings
SELECT artist, COUNT(artist) AS hits, AVG(danceability) AS avg_danceability, AVG(tempo) AS avg_tempo 
FROM songdata
GROUP BY artist
ORDER BY hits DESC;

-- find the most versatile artists with the most hits and assess the difference between their highest and lowest tempo hits
SELECT artist, tempo, COUNT(artist) AS hits, MAX(tempo) AS highest_tempo, MIN(tempo) AS lowest_tempo, (MAX(tempo) - MIN(tempo)) AS difference
FROM songdata
GROUP BY artist
ORDER BY hits DESC, highest_tempo DESC;
-- the very top artists all have a high diversity in the tempos they can execute upon
-- some more household noames such as lopez/timberlake have a narrower range, but are not in the elite group (top 10) of this list

SELECT artist, tempo, COUNT(artist) AS hits, MAX(tempo) AS highest_tempo, MIN(tempo) AS lowest_tempo, (MAX(tempo) - MIN(tempo)) AS difference, AVG(danceability) AS avg_danceability, CASE
	WHEN AVG(danceability) > 0.6 THEN "danceable"
    ELSE 'not very danceable'
    END AS assessment
FROM songdata
GROUP BY artist
ORDER BY hits DESC, highest_tempo DESC;
-- while tempo stays fairly consistent, track character (danceability) is very important
-- songs without a respectable danceability rating do not top charts often

-- tempo is a raw measurement for the pace of the track. however, energy comes from song activity that can be measured in songwaves, decibals, and more
-- since artist execution has such a large impact on the feeling of a song, tempo can be very variable among these top hits
-- hypothesis: energy and danceability have a stronger correlation than comparing either of these metrics to tempo
SELECT artist, AVG(energy) AS avg_energy, AVG(danceability) AS avg_danceability 
FROM songdata
GROUP BY artist
ORDER BY avg_energy DESC;
-- seems to have no strong correlation

-- what kind of audience are the top artists targeting?
SELECT artist, COUNT(artist) AS hits, SUM(explicit = 'true') AS explicit_songs
FROM songdata
GROUP BY artist
ORDER BY hits DESC;
-- in visualization, we will be able to draw a clearer conclusion that the median of these hit songs have more explicit content

SELECT artist, COUNT(artist) AS hits, explicit,
	(SELECT AVG(popularity) FROM songdata)
FROM songdata
GROUP BY artist
ORDER BY hits DESC;

-- find the most popular song for each artist
SELECT artist, song, MAX(popularity)
FROM songdata
GROUP BY artist;

-- find the very best songs (above the popularity average of this list of hits)
SELECT AVG(popularity) FROM songdata; -- 59.63
SELECT * FROM songdata
WHERE popularity > 59.63;

-- overall, we can draw strategy insights from the exploration conducted 
-- we have been able to quantifiably discern the ambiguity between characteristics such as tempo, danceability, and energy
-- we have observed the very best artists and the audience they cater to, the genre they work in, their song duration, and other traits

-- in conclusion, it is important to remember that a song is a product
-- these quantifiable metrics suggest that some traits are common among digestible products that listeners enjoy over and over
-- delivering a product that is not too short or too long, with a relatively high danceability level and following the sonic character of "popular culture" is the best formula to create a hit



