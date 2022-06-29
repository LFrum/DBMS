/* 
    Setup new tables for our sets and relations: Performer, Movie, Acted, Director, and Movie Award
*/
-- Delete the table if it exists 
--DROP TABLE Acted; 
--DROP TABLE Performer;
--DROP TABLE Movie;
--DROP TABLE Director;
--DROP TABLE Movie_Award;


-- Create Performer table
CREATE TABLE Performer
    (pid INT,
     pname VARCHAR(50),
     years_of_experience INT,
     age INT,
     PRIMARY KEY(pid));
-- Create Director table
CREATE TABLE Director
    (did INT,
     dname VARCHAR(50),
     earnings REAL,
     PRIMARY KEY(did));
-- Create Movie table
CREATE TABLE Movie
    (mname VARCHAR(50), 
     genre VARCHAR(50),
     minutes INT,
     release_year INT,
     did INT,
     PRIMARY KEY(mname),
     FOREIGN KEY (did) REFERENCES Director (did));
-- Create Acted table
CREATE TABLE Acted
    (pid INT,
     mname VARCHAR(50),
     PRIMARY KEY(pid, mname),
     FOREIGN KEY(pid) REFERENCES Performer (pid),
     FOREIGN KEY(mname) REFERENCES Movie (mname));

-- Create Movie Award table
CREATE TABLE Movie_Award
    (aname VARCHAR(50),
     awardtype VARCHAR(50),
     awardyear INT,
     mname VARCHAR(50),
     PRIMARY KEY(aname, awardtype, awardyear),
     FOREIGN KEY(mname) REFERENCES Movie (mname));
/* 
    Add data from the given PDF into their respective tables
*/ 
-- Insert data into Performer table
INSERT INTO Performer 
    (pid, pname, years_of_experience, age)
VALUES
    (1, 'Morgan', 48, 67),
    (2, 'Cruz',   14, 28),
    (3, 'Adams',   1, 16),
    (4, 'Perry',  18, 32),
    (5, 'Hanks',  36, 15),
    (6, 'Hanks',  15, 24),
    (7, 'Lewis',  13, 32);
-- Insert data into Director table
INSERT INTO Director 
    (did, dname, earnings)
VALUES
    (1, 'Parker', 580000),
    (2, 'Black', 2500000),
    (3, 'Black',   30000),
    (4, 'Stone',  820000);
-- Insert data into Movie table
INSERT INTO Movie 
    (mname, genre, minutes, release_year, did)
VALUES
    ('Jurassic Park',        'Action',    125, 1984, 2),
    ('Shawshank Redemption', 'Drama',     105, 2001, 2),
    ('Fight Club',           'Drama',     144, 2015, 2),
    ('The Departed',         'Drama',     130, 1969, 3),
    ('Back to the Future',   'Comedy',     89, 2008, 3),
    ('The Lion King',        'Animation',  97, 1990, 1),
    ('Alien',                'Sci-Fi',    115, 2006, 3),
    ('Toy Story',            'Animation', 104, 1978, 1),
    ('Scarface',             'Drama',     124, 2003, 1),
    ('Up',                   'Animation', 111, 1999, 4);
-- Insert data into Acted table
INSERT INTO Acted 
    (pid, mname)
VALUES
    (4, 'Fight Club'),
    (5, 'Fight Club'),
    (6, 'Shawshank Redemption'),
    (4, 'Up'),
    (5, 'Shawshank Redemption'),
    (1, 'The Departed'),
    (2, 'Fight Club'),
    (3, 'Fight Club'),
    (4, 'Alien');

-- Insert data into Acted table
INSERT INTO Movie_Award 
    (aname, awardtype, awardyear, mname)
VALUES
    ('Oscar', 'Best Cinematography', 2000, 'A'),
    ('Oscar', 'Best Actor', 2000, 'B'),
    ('Oscar', 'Best Actress', 2010, 'C'),
    ('Oscar', 'Best Cinematography', 2010, 'D'),
    ('Emmy', 'Best Cinematography', 2010, 'D');

/* 
    Task 1: Display all data to verify 
*/
SELECT * FROM Performer;
SELECT * FROM Director;
SELECT * FROM Movie;
SELECT * FROM Acted;

SELECT mname
FROM Movie_Award
WHERE awardtype = 'Best Cinematography' AND aname = 'Oscar' AND (awardyear BETWEEN 2000 AND 2010);


/*
    Task 2: Find names of all action movies
*/
SELECT mname FROM Movie WHERE genre = 'Action';

/*
    Task 3: For each genre, display the genre and average length(minutes) of movies for that genre
*/
SELECT genre, AVG(minutes) avg_length
FROM Movie
GROUP BY genre
ORDER BY genre

/*
    Task 4: Find the names of all performers with at least 20 years of experience who have acted
    in a movie directed by Black
*/
SELECT p.pname FROM Performer AS p, Director AS d, Movie AS m, Acted AS a
WHERE (d.dname = 'Black' AND m.did = d.did AND a.mname = m.mname AND p.pid = a.pid AND p.years_of_experience > 19) 
GROUP BY p.pid, p.pname -- result with distinct pid

/*
    Task 5: Find the age of the oldest performer who is either named "Hanks" or has acted in a
    movie named "The Departed"
*/
SELECT MAX(age) AS age
FROM Performer, Acted
-- where perfomer named "Hanks"
WHERE (Performer.pname = 'Hanks' OR 
-- where performer(s) has acted in a movie named "The Departed"
(Performer.pid = Acted.pid AND Acted.mname = 'The Departed'))

/*
    Task 6: Find the names of all movies that are either a Comedy or have had more than one
    performer act in them
*/
-- select all movies with Comedy genre
SELECT mname FROM Movie as m WHERE m.genre = 'Comedy' 
UNION
-- select movie that have had more than one performer act in them
SELECT mname FROM Acted as a GROUP BY mname HAVING COUNT (a.mname) > 1;

/*
    Task 7: Find the names and pid's of all performers who have acted in at least two movies
    that have the same genre.
*/
SELECT DISTINCT Performer.pid, Performer.pname
FROM Performer, Acted AS a1, Acted AS a2, Movie AS m1, Movie AS m2
WHERE ((Performer.pid = a1.pid)
   AND (a1.mname = m1.mname)
   AND (a2.mname = m2.mname)
   AND (a1.pid = a2.pid)
   AND (m1.genre = m2.genre)
   AND NOT(a1.mname = a2.mname));

/* 
    Task 8: Decrease the earnings of all directors who directed "Up" by 10%.
*/
UPDATE Director
SET earnings = earnings * 0.90
FROM Director AS d, Movie as m
WHERE d.did = m.did AND m.mname = 'Up';
SELECT * FROM Director -- Show updated Director Table

/* 
    Task 9: Delete all movies released in the 70's and 80's
*/
DELETE FROM Movie
WHERE release_year BETWEEN 1970 AND 1989;
SELECT * FROM Movie -- Show updated Movie Table