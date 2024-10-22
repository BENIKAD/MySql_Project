-- Benjamin Adebanjo Ikuesan c402

/*
Basic Selects

REQUIREMENT - Use a multi-line comment to paste the first 5 or fewer results under your query
		     Also include the total records returned.
*/

USE orderbook_activity_db;

-- -------------------------------------------------------------
-- #1: List all users, including username and dateJoined.
SELECT uname, datejoined
from user;
/*
'admin', '2023-02-14 13:13:28'
'wiley', '2023-04-01 13:13:28'
'james', '2023-03-15 19:15:48'
'kendra', '2023-03-15 19:16:06'
'alice', '2023-03-15 19:16:21'

total records returned = 7 rows returned
*/

-- ---------------------------------------------------------------------------
-- #2: List the username and datejoined from users with the newest users at the top.

select uname, datejoined
from user
order by datejoined desc;

/*
'robert', '2023-03-15 19:16:43'
'alice', '2023-03-15 19:16:21'
'kendra', '2023-03-15 19:16:06'
'james', '2023-03-15 19:15:48'

total records returned = 7 rows returned
*/

-- ------------------------------------------------------------------------------
-- #3: List all usernames and dateJoined for users who joined in March 2023.
SELECT uname, datejoined
from user
where DATE_FORMAT(dateJoined, '%Y-%m') = '2023-03';
/*
'james', '2023-03-15 19:15:48'
'kendra', '2023-03-15 19:16:06'
'alice', '2023-03-15 19:16:21'
'robert', '2023-03-15 19:16:43'
'sam', '2023-03-15 19:16:59'

total records returned = 5 rows returned
*/

-- -------------------------------------------------------------------------

-- #4: List the different role names a user can have.
select name 
from role;
/*
admin
it
user

total records returned = 3 rows returned
*/


-- ----------------------------------------------------------------
-- #5: List all the orders.
Select *
from `order`;
/*
'1', '1', 'WLY', '1', '2023-03-15 19:20:35', '100', '38.73', 'partial_fill'
'2', '6', 'WLY', '2', '2023-03-15 19:20:50', '-10', '38.73', 'filled'
'3', '6', 'NFLX', '2', '2023-03-15 19:21:12', '-100', '243.15', 'pending'
'4', '5', 'A', '1', '2023-03-15 19:21:31', '10', '129.89', 'filled'
'5', '3', 'A', '2', '2023-03-15 19:21:39', '-10', '129.89', 'filled'
total records returned = 24 rows returned
*/
-- -------------------------------------------------------------------------------

-- #6: List all orders in March where the absolute net order amount is greater than 1000.
select * from `order` 
WHERE ABS(shares * price) > 1000
and DATE_FORMAT(ordertime, '%Y-%m') = '2023-03';
/*
1	1	WLY	1	2023-03-15 19:20:35	100	38.73	partial_fill
3	6	NFLX	2	2023-03-15 19:21:12	-100	243.15	pending
4	5	A	1	2023-03-15 19:21:31	10	129.89	filled
5	3	A	2	2023-03-15 19:21:39	-10	129.89	filled
total records returned = 16 rows returned
*/
-- ----------------------------------------------------------------------

-- #7: List all the unique status types from orders.
SELECT distinct status
from `order`;
/*
'partial_fill'
'filled'
'pending'
'canceled_partial_fill'
'canceled'

total records returned = 5 rows returned
*/
-- -------------------------------------------------------------------

-- #8: List all pending and partial fill orders with oldest orders first.
select *
from `order`
where status in ('Pending', 'Partial Fill')
order by orderTime ASC;
/*
3	6	NFLX	2	2023-03-15 19:21:12	-100	243.15	pending
12	4	QQQ	2	2023-03-15 19:24:32	-100	268.27	pending
13	4	QQQ	2	2023-03-15 19:24:32	-100	268.27	pending
20	3	WLY	1	2023-03-15 19:51:06	100	38.73	pending
21	5	A	2	2023-03-15 20:09:38	-1	129.89	pending

total records returned = 8 rows returned
*/
-- -----------------------------------------------------


-- #9: List the 10 most expensive financial products where the productType is stock.
-- Sort the results with the most expensive product at the top
select *
from product
where productType = 'stock'
order by price DESC
LIMIT 10;
/*
207940.KS	830000.00	stock	Samsung Biologics Co.,Ltd.	2022-10-17 15:24:51
003240.KS	715000.00	stock	Taekwang Industrial Co., Ltd.	2022-10-17 15:24:51
000670.KS	630000.00	stock	Young Poong Corporation	2022-10-17 15:24:51
010130.KS	616000.00	stock	Korea Zinc Company, Ltd.	2022-10-17 15:24:51
006400.KS	605000.00	stock	Samsung SDI Co., Ltd.	2022-10-17 15:24:51

total records returned = 10 rows returned
*/


-- #10: Display orderid, fillid, userid, symbol, and absolute net fill amount
-- from fills where the absolute net fill is greater than $1000.
-- Sort the results with the largest absolute net fill at the top.

SELECT orderid, fillid, userid, symbol, ABS(share * price) AS net_fill_amount
FROM fill
WHERE ABS(share * price) > 1000
ORDER BY net_fill_amount DESC;

/*
11	11	5	SPY	27429.75
14	12	4	SPY	27429.75
6	5	1	GS	3056.30
7	6	4	GS	3056.30
8	9	6	AAPL	2111.40

total records returned = 10 rows returned
*/
