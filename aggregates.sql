-- Benjamin Adebanjo Ikuesan c402

/*
Aggregate Queries

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     THEN records returned. 
*/

USE orderbook_activity_db;

-- #1: How many users do we have?
SELECT COUNT(*) AS total_users
FROM user;
-- total returned: 7

-- #2: List the username, userid, and number of orders each user has placed.
SELECT u.uname, u.userid, COUNT(o.orderid) AS total_orders
FROM user u
LEFT JOIN `order` o ON u.userid = o.userid
GROUP BY u.uname, u.userid;



-- #3: List the username, symbol, and number of orders placed for each user and for each symbol. 
-- Sort results in alphabetical order by symbol.
SELECT u.uname, o.symbol, COUNT(o.orderid) AS total_orders
FROM user u
JOIN `order` o ON u.userid = o.userid
GROUP BY u.uname, o.symbol
ORDER BY o.symbol ASC;
/*
alice	A	5
james	A	1
robert	AAA	1
admin	AAPL	1
total returned : 19 row
*/


-- #4: Perform the same query as the one above, but only include admin users.
SELECT u.uname, o.symbol, COUNT(o.orderid) AS total_orders
FROM user u
JOIN `order` o ON u.userid = o.userid
JOIN role r ON u.userid = r.roleid
WHERE r.name = 'Admin'
GROUP BY u.uname, o.symbol
ORDER BY o.symbol ASC;
/*
admin	AAPL	1
admin	GS	1
admin	WLY	1

total returned: 3 rows
*/

-- #5: List the username and the average absolute net order amount for each user with an order.
-- Round the result to the nearest hundredth and use an alias (averageTradePrice).
-- Sort the results by averageTradePrice with the largest value at the top.
SELECT u.uname, ROUND(AVG(ABS(o.shares * o.price)), 2) AS averageTradePrice
FROM user u
JOIN `order` o ON u.userid = o.userid
GROUP BY u.uname
ORDER BY averageTradePrice DESC;
/*
kendra	17109.53
admin	12182.47
robert	10417.84
alice	6280.26
james	2053.73
total returned : 5 rows
*/


-- #6: How many shares for each symbol does each user have?
-- Display the username and symbol with number of shares.
SELECT u.uname, o.symbol, SUM(o.shares) AS total_shares
FROM user u
JOIN `order` o ON u.userid = o.userid
GROUP BY u.uname, o.symbol;
/*
admin	WLY	100
admin	GS	100
admin	AAPL	-15
alice	A	18
total retuned : 19
*/

-- #7: What symbols have at least 3 orders?
SELECT o.symbol, COUNT(o.orderid) AS total_orders
FROM `order` o
GROUP BY o.symbol
HAVING COUNT(o.orderid) >= 3;
/*
A	6
AAPL	3
WLY	3

total returned: 3 rows
*/

-- #8: List all the symbols and absolute net fills that have fills exceeding $100.
-- Do not include the WLY symbol in the results.
-- Sort the results by highest net with the largest value at the top.
SELECT f.symbol, ABS(SUM(f.share * f.price)) AS net_fills
FROM fill f
WHERE f.symbol != 'WLY'
GROUP BY f.symbol
HAVING net_fills > 100
ORDER BY net_fills DESC;
/*
o rows returned
*/

-- #9: List the top five users with the greatest amount of outstanding orders.
-- Display the absolute amount filled, absolute amount ordered, and net outstanding.
-- Sort the results by the net outstanding amount with the largest value at the top.
SELECT u.uname, ABS(SUM(f.share)) AS total_filled, ABS(SUM(o.shares)) AS total_ordered,
       ABS(SUM(o.shares)) - ABS(SUM(f.share)) AS net_outstanding
FROM user u
JOIN `order` o ON u.userid = o.userid
LEFT JOIN fill f ON o.orderid = f.orderid
GROUP BY u.uname
ORDER BY net_outstanding DESC
LIMIT 5;
/*
kendra	95	295	200
admin	5	185	180
alice	75	208	133
james	0	100	100
robert	15	50	35

total returned : 5 rows
*/