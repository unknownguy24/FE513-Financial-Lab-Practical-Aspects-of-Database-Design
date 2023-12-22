-- Part 1 and 2
CREATE TABLE bank_data (
    id INT,
    date DATE,
    asset INT,
    liability INT,
    idx INT PRIMARY KEY
);
-- Part 3
SELECT id, MAX(asset) AS max_asset
FROM bank_data
GROUP BY id
ORDER BY max_asset DESC
LIMIT 10;
--Part 5
SELECT quarter, COUNT(*)
FROM (
    SELECT id, MAX(asset) AS max_asset, EXTRACT(QUARTER FROM date) AS quarter
    FROM bank_data
    GROUP BY id, date
) AS siddharth
GROUP BY quarter
ORDER BY quarter;
--Part 6
SELECT COUNT(*)
FROM bank_data
WHERE asset > 100000 AND liability < 100000;
--Part 7
SELECT ROUND(AVG(liability),2) AS avg_liability_odd_siddharth
FROM bank_data
WHERE MOD(idx, 2) <> 0;
--Part 8
SELECT 
    ROUND(AVG(liability) FILTER (WHERE MOD(idx, 2) = 0), 2) AS avg_liability_even,
    ROUND(AVG(liability) FILTER (WHERE MOD(idx, 2) <> 0), 2) AS avg_liability_odd,
    ROUND(AVG(liability) FILTER (WHERE MOD(idx, 2) <> 0), 2) - ROUND(AVG(liability) FILTER (WHERE MOD(idx, 2) = 0), 2) AS diff_odd_even
FROM bank_data;
--Part 9
WITH siddharth AS (
    SELECT id, asset, date,
           LAG(asset) OVER (PARTITION BY id ORDER BY date) AS prev_asset
    FROM bank_data
)
SELECT id, asset, date
FROM siddharth
WHERE asset > prev_asset
ORDER BY id, date
LIMIT 10;
