--Creating both the tables
CREATE TABLE banks_sec_2022 (
    id INT,
    date DATE,
    security INT
);

CREATE TABLE banks_al_2022 (
    id INT,
    date DATE,
    asset INT,
    liability INT
);

--Did not work in my case due to permission issue
--Was done in psql on localhost (check report)
COPY banks_sec_2022 FROM 'C:/Users/siddh/Downloads/banks_sec_2002.csv' DELIMITER ',' CSV HEADER;
COPY banks_al_2002 FROM 'C:/Users/siddh/Downloads/banks_al_2002-1.csv' DELIMITER ',' CSV HEADER;

--Deleting duplicates
DELETE FROM banks_sec_2022
WHERE ctid NOT IN (
    SELECT MAX(ctid)
    FROM banks_sec_2022
    GROUP BY id, date, security
);

--Join
CREATE TABLE sid_joint AS
SELECT s.id, s.date, s.security, a.asset, a.liability
FROM banks_sec_2022 s
FULL OUTER JOIN banks_al_2022 a ON s.id = a.id AND s.date = a.date
--First 10 observations
SELECT *
FROM sid_joint
LIMIT 10;
--Banks_total
CREATE TABLE banks_total (
    id INTEGER,
    date DATE,
    security NUMERIC,
    asset NUMERIC,
    liability NUMERIC,
    PRIMARY KEY (id, date)
);
--Inserting
INSERT INTO banks_total (id, date, security, asset, liability)
SELECT id, date, security, asset, liability
FROM sid_joint;
--4th subquestion
SELECT EXTRACT(QUARTER FROM date) AS quarter, COUNT(*)
FROM banks_total
WHERE security > 0.2 * asset
GROUP BY quarter;
--5th subquestion
SELECT COUNT(*)
FROM banks_total
WHERE EXTRACT(QUARTER FROM date) = 1 AND liability > 0.9 * asset
AND id IN (
    SELECT id
    FROM banks_total
    WHERE EXTRACT(QUARTER FROM date) = 2 AND liability < 0.9 * asset
);

--Did not work in my case was done on psql
COPY banks_total TO 'C:/Users/siddh/Downloads/banks_total_siddharth.csv' WITH CSV HEADER;