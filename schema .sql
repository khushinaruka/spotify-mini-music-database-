CREATE TABLE Artists (
    artist_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    total_followers INT
);

CREATE TABLE Albums (
    album_id INT PRIMARY KEY,
    album_name VARCHAR(100) NOT NULL,
    release_year INT,
    artist_id INT
);

CREATE TABLE Songs (
    song_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    duration INT, -- in seconds
    genre VARCHAR(50),
    play_count INT DEFAULT 0,
    artist_id INT,
    album_id INT
);

CREATE TABLE Playlists (
    playlist_id INT PRIMARY KEY,
    playlist_name VARCHAR(100) NOT NULL,
    user_id INT,
    created_date DATE
);
