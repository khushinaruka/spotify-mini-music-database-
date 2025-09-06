-- Group songs by genre and title
SELECT
    genre
FROM Songs
GROUP BY genre, title;

-- song with highest play count
SELECT TOP 1
    title,
    duration,
    play_count
FROM Songs Songs
ORDER BY play_count DESC;


-- Rank songs by play count (overall)
SELECT
    title,
    play_count,
    RANK() OVER(ORDER BY play_count DESC) AS rank_overall
FROM Songs;


-- Rank songs by play count within each genre
SELECT
    title,
    genre,
    play_count,
    RANK() OVER(PARTITION BY genre ORDER BY play_count DESC) AS rank_in_genre
FROM Songs;


-- Sum of play counts per artist
SELECT
    title,
    play_count,
    A.name,
    SUM(play_count) OVER(PARTITION BY A.name ORDER BY S.play_count DESC) AS total_play_count
FROM Songs S
JOIN Artists A
    ON S.artist_id = A.artist_id;


-- Get top 2 songs for each artist
SELECT TOP 2
    MAX(S.title) OVER(PARTITION BY A.name) AS top_song
FROM Songs S
JOIN Artists A
    ON S.artist_id = A.artist_id;

-- Average play count per genre
SELECT
    title,
    genre,
    play_count,
    AVG(play_count) OVER(PARTITION BY genre) AS playcount
FROM Songs;

-- Get top 2 songs per artist using ROW_NUMBER
SELECT artist_name, title, play_count
FROM (
    SELECT
        a.name AS artist_name,
        s.title,
        s.play_count,
        ROW_NUMBER() OVER(PARTITION BY a.artist_id ORDER BY s.play_count DESC) AS rn
    FROM Songs s
    JOIN Artists a
        ON s.artist_id = a.artist_id
) t
WHERE rn <= 2;

-- Compare play count with previous and next song
SELECT
    title,
    play_count,
    LAG(play_count) OVER(ORDER BY play_count DESC) AS prev_song_play,
    LEAD(play_count) OVER(ORDER BY play_count DESC) AS next_song_play
FROM Songs;

-- Percentage share of each song in its album
SELECT
    s.title,
    s.title AS album,
    s.play_count,
    (s.play_count * 100.0 / SUM(s.play_count) OVER(PARTITION BY s.album_id)) AS pct_share
FROM Songs s
JOIN Albums a
    ON s.album_id = a.album_id;

--difference between max and min play counts with each genre
SELECT 
    genre,
    MAX(play_count) - MIN(play_count) AS diff_playcount
FROM Songs
GROUP BY genre;

-- assign a dense rank to albums based on their total play count
SELECT 
    a.title AS album,
    SUM(s.play_count) AS total_plays,
    DENSE_RANK() OVER (ORDER BY SUM(s.play_count) DESC) AS album_rank
FROM Songs s
JOIN Albums a ON s.album_id = a.album_id
GROUP BY a.title;


--find the first and the last played song for each artist
SELECT artist_name, title, play_count
FROM (
    SELECT 
        ar.name AS artist_name,
        s.title,
        s.play_count,
        ROW_NUMBER() OVER(PARTITION BY ar.artist_id ORDER BY s.play_count DESC) AS rn_desc,
        ROW_NUMBER() OVER(PARTITION BY ar.artist_id ORDER BY s.play_count ASC)  AS rn_asc
    FROM Songs s
    JOIN Artists ar ON s.artist_id = ar.artist_id
) t
WHERE rn_desc = 1 OR rn_asc = 1;





