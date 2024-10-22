-- Benjamin Adebanjo Ikuesan c402

/*
Join Queries

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     Also include the total records returned.
*/

USE orderbook_activity_db;

-- #1: Display the dateJoined and username for admin users.
SELECT u.dateJoined, u.uname
FROM user u
JOIN role r ON u.userid = r.roleid
WHERE r.name = 'Admin';
/*
2023-02-14 13:13:28	admin
total records returned = 1
*/

-- -----------------------------------------------------------------------
-- #2: Display each absolute order net (share*price), status, symbol, trade date, and username.
-- Sort the results with largest the absolute order net (share*price) at the top.
-- Include only orders that were not canceled or partially canceled.
SELECT o.orderid, ABS(o.shares * o.price) AS absolute_order_net, o.status, o.symbol, o.orderTime, u.uname
FROM `order` o
JOIN user u ON o.userid = u.userid
WHERE o.status NOT IN ('Canceled', 'Partially Canceled')
ORDER BY absolute_order_net DESC;

/*
'11', '36573.00', 'partial_fill', 'SPY', '2023-03-15 19:24:21', 'alice'
'6', '30563.00', 'canceled_partial_fill', 'GS', '2023-03-15 19:22:11', 'admin'
'14', '27429.75', 'filled', 'SPY', '2023-03-15 19:24:47', 'kendra'
'12', '26827.00', 'pending', 'QQQ', '2023-03-15 19:24:32', 'kendra'
'13', '26827.00', 'pending', 'QQQ', '2023-03-15 19:24:32', 'kendra'
total records returned = 21
*/
-- ----------------------------------------------------------------


-- #3: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Note that filledShares are the opposite sign (+-) because they subtract from ordershares!
SELECT o.orderid, o.symbol, o.status, o.shares AS order_shares, f.share AS filled_shares, o.price
FROM `order` o
JOIN fill f ON o.orderid = f.orderid;
/*
'1', 'WLY', 'partial_fill', '100', '-10', '38.73'
'2', 'WLY', 'filled', '-10', '10', '38.73'
'4', 'A', 'filled', '10', '-10', '129.89'
'5', 'A', 'filled', '-10', '10', '129.89'
total returned = 14 rows

*/



-- #4: Display all partial_fill orders and how many outstanding shares are left.
-- Also include the username, symbol, and orderid.

SELECT o.orderid, o.symbol, u.uname, o.shares - COALESCE(SUM(f.share), 0) AS outstanding_shares
FROM `order` o
JOIN user u ON o.userid = u.userid
LEFT JOIN fill f ON o.orderid = f.orderid
WHERE o.status = 'Partial Fill'
GROUP BY o.orderid, o.symbol, u.uname;
 -- -- 0 returened
-- -----------------------------------------------------------------------


-- #5: Display the orderid, symbol, status, order shares, filled shares, and price for orders with fills.
-- Also include the username, role, absolute net amount of shares filled, and absolute net order.
-- Sort by the absolute net order with the largest value at the top.
SELECT o.orderid, o.symbol, o.status, o.shares AS order_shares, f.share AS filled_shares, o.price,
       u.uname, r.name AS role, ABS(f.share) AS absolute_net_filled, ABS(o.shares * o.price) AS absolute_net_order
FROM `order` o
JOIN fill f ON o.orderid = f.orderid
JOIN user u ON o.userid = u.userid
JOIN role r ON r.roleid = u.userid
ORDER BY absolute_net_order DESC;
/*
6	GS	canceled_partial_fill	100	-10	305.63	admin	admin	10	30563.00
1	WLY	partial_fill	100	-10	38.73	admin	admin	10	3873.00
10	AAPL	filled	-15	15	140.76	admin	admin	15	2111.40
5	A	filled	-10	10	129.89	james	user	10	1298.90

total return: 5 rows
*/



-- #6: Display the username and user role for users who have not placed an order.
SELECT u.uname, r.name AS role
FROM user u
JOIN role r ON u.userid = r.roleid
LEFT JOIN `order` o ON u.userid = o.userid
WHERE o.orderid IS NULL;
/*
wiley	it
total returened: 1 row

*/



-- #7: Display orderid, username, role, symbol, price, and number of shares for orders with no fills.
SELECT o.orderid, u.uname, r.name AS role, o.symbol, o.price, o.shares
FROM `order` o
JOIN user u ON o.userid = u.userid
JOIN role r ON r.roleid = u.userid
LEFT JOIN fill f ON o.orderid = f.orderid
WHERE f.fillid IS NULL;
/*
20	james	user	WLY	38.73	100
total returned : 1 row
*/

-- #8: Display the symbol, username, role, and number of filled shares where the order symbol is WLY.
-- Include all orders, even if the order has no fills.

SELECT o.symbol, u.uname, r.name AS role, COALESCE(SUM(f.share), 0) AS filled_shares
FROM `order` o
JOIN user u ON o.userid = u.userid
JOIN role r ON r.roleid = u.userid
LEFT JOIN fill f ON o.orderid = f.orderid
WHERE o.symbol = 'WLY'
GROUP BY o.symbol, u.uname, r.name;
/*
WLY	admin	admin	-10
WLY	james	user	0

total returned: 2 rows
*/

