SELECT p.id, p.name FROM products p, categories c WHERE c.name=c.name AND c.id=p.cid ORDER BY p.name

EXPLAIN ANALYZE VERBOSE
SELECT * INTO tempTable FROM (SELECT p.id, p.name, u.name as user, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id
GROUP BY u.name, p.id ORDER BY u.name) AS T

EXPLAIN ANALYZE VERBOSE
SELECT p.id, p.name, u.name as user, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id WHERE p.name >= 'Apple Macbook' AND p.name <= 
'Samsung Galaxy'
GROUP BY u.name, p.id ORDER BY u.name

SELECT p.name, u.name as user, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id  WHERE p.name >= 'Apple Macbook' AND p.name <= 'Samsung Galaxy'
GROUP BY u.name, p.name ORDER BY u.name

--Customer Cells
SELECT name, uname, SUM(quantity*price) FROM all_temp 
WHERE name >= 'Apple Macbook' AND name <= 'Samsung Galaxy'
GROUP BY uname, name ORDER by uname, name

--Customer Spent
SELECT uname, SUM(quantity*price) FROM all_temp
WHERE TRUE AND TRUE AND TRUE AND TRUE
GROUP BY uname ORDER BY uname LIMIT 20 

SELECT u.name, SUM(s.quantity*s.price) FROM users u LEFT OUTER JOIN sales s ON (s.uid = u.id) 
LEFT OUTER JOIN products p ON (p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE
TRUE AND TRUE AND TRUE GROUP BY u.name ORDER BY u.name LIMIT 20


CREATE TEMPORARY TABLE sales_temp AS(
SELECT u.id, u.name, SUM(s.quantity*s.price) FROM users u LEFT OUTER JOIN 
sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON (p.id = s.pid) LEFT OUTER JOIN
categories c ON (p.cid = c.id) WHERE TRUE AND TRUE AND 
TRUE AND TRUE GROUP BY u.id ORDER BY u.name LIMIT 20);


SELECT name, count(*) as cnt
FROM users
LEFT OUTER JOIN sales
ON (users.id = sales.uid)
GROUP BY name,users.id
ORDER BY name LIMIT 50;

CREATE TEMPORARY TABLE users_temp AS (SELECT * FROM users LIMIT 50);

SELECT * FROM users_temp



SELECT p.id, p.name, u.state as user, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id AND TRUE AND TRUE WHERE p.name >= 'Apple Macbook' AND p.name <= 
'Samsung Galaxy'
GROUP BY u.state, p.id ORDER BY u.state

SELECT * FROM tempTable LIMIT 20

DROP TABLE tempTable

SELECT p.id, p.name FROM products p, categories c WHERE c.name=c.name AND c.id=p.cid ORDER BY p.name

SELECT p.id, p.name, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid)
LEFT OUTER JOIN users u ON (s.uid = u.id) WHERE TRUE AND c.name = 'Computers' AND TRUE AND TRUE GROUP BY p.id ORDER BY p.name


SELECT * FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid)
LEFT OUTER JOIN users u ON (s.uid = u.id AND u.state = 'Alabama')


EXPLAIN ANALYZE VERBOSE
SELECT p.name, SUM(s.quantity*s.price) FROM products p, sales s, users u, categories c WHERE p.id = s.pid AND u.state = 'Alabama'
 AND u.id = s.uid AND p.cid = c.id AND c.name = c.name GROUP BY p.id ORDER BY p.name

EXPLAIN ANALYZE VERBOSE
SELECT u.id, u.name, SUM(s.quantity*s.price) FROM users u LEFT OUTER JOIN 
sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON (p.id = s.pid) LEFT OUTER JOIN
categories c ON (p.cid = c.id) WHERE TRUE AND TRUE AND 
TRUE AND TRUE GROUP BY u.id ORDER BY u.name

SELECT u.state, COALESCE(SUM(s.quantity*s.price),0) FROM 
			users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON 
			(p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE
			TRUE AND TRUE AND TRUE GROUP BY u.state ORDER BY u.state

SELECT p.name, u.state, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c 
ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid) LEFT OUTER JOIN users u 
ON s.uid = u.id
GROUP BY u.state, p.name ORDER BY u.state


CREATE TEMPORARY TABLE all_temp AS (SELECT p.id as pid, p.name, u.id, u.name as uname, u.state, s.quantity, s.price FROM products p LEFT OUTER JOIN categories c 
ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid) LEFT OUTER JOIN users u 
ON s.uid = u.id)

SELECT * FROM all_temp

-- State Cells
SELECT name, state, SUM(quantity*price) FROM all_temp
GROUP BY state, name ORDER BY state

--State spent
SELECT state, SUM(quantity*price) FROM all_temp
WHERE TRUE AND TRUE AND TRUE GROUP BY state ORDER BY state

SELECT u.state, COALESCE(SUM(s.quantity*s.price),0) FROM 
			users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON 
			(p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE
			TRUE AND TRUE AND TRUE GROUP BY u.state ORDER BY u.state



SELECT * FROM users ORDER BY name
SELECT * FROM sales

SELECT SUM(s.quantity * s.price) FROM users u, sales s, categories c, products p WHERE u.name = 'Neeren' AND u.id = s.uid 
AND s.pid = p.id AND p.cid = c.id AND c.name = "+category+" AND u.age >= "+lowerAge+" AND age < "+upperAge+" GROUP BY u.name

 SELECT p.name, SUM(s.quantity*s.price) FROM products p, sales s, users u, categories c WHERE p.id = s.pid 
  AND u.id = s.uid AND p.cid = c.id AND c.name = c.name GROUP BY p.id ORDER BY p.name


SELECT p.id, p.name, SUM(s.quantity*s.price) FROM users u, sales s, products p WHERE u.id = 3 AND s.uid = u.id AND s.pid = p.id 
GROUP BY p.id ORDER BY p.name


SELECT p.id, p.name, SUM(s.quantity*s.price) FROM users u, sales s, products p, categories c
WHERE u.id = 5 AND s.uid = u.id AND s.pid = p.id AND c.id = p.cid AND c.name = 'Cell Phones' GROUP BY p.id ORDER BY p.name


SELECT p.id, p.name, SUM(s.quantity*s.price) FROM users u, sales s, products p, categories c
WHERE u.state = 'Alabama' AND s.uid = u.id AND s.pid = p.id AND c.id = p.cid AND c.name = 'Cell Phones' GROUP BY p.id ORDER BY p.name


-- Products for All Categories
SELECT id, name FROM products ORDER BY name LIMIT 10 OFFSET (nextProds*10)
-- Products Spent Totals
SELECT p.id, p.name, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c 
ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON (s.uid = u.id) 
WHERE stateFilter AND categoryFilter AND lowerAgeFilter AND upperAgeFilter GROUP BY p.id ORDER BY p.name

-- Products for specified category
SELECT p.id, p.name FROM products p, categories c WHERE c.name= category AND c.id=p.cid ORDER BY p.name LIMIT 10
-- Products Spent Totals
prodSpentSQL = SELECT p.id, p.name, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN
 categories c ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON (s.uid = u.id) WHERE
 stateFilter AND categoryFilter AND lowerAgeFilter AND upperAgeFilter GROUP BY p.id ORDER BY p.nameww

--State Spent Total
SELECT u.state, COALESCE(SUM(s.quantity*s.price),0) FROM users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN 
products p ON (p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE stateFilter AND categoryFilter AND 
lowerAgeFilter AND upperAgeFilter GROUP BY u.state ORDER BY u.state

--State	Spent Cells		
SELECT p.id, p.name, u.state, SUM(s.quantity*s.price) FROM 
			products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
			sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id AND lowerAgeFilter
			AND upperAgeFilter WHERE p.name >= prodNames.get(0) AND p.name <= prodNames.get(prodNames.size()-1)
			AND u.state >= startState AND u.state <= endState GROUP BY u.state, p.id ORDER BY u.state

--Customer Total Spent
SELECT u.id, u.name, COALESCE(SUM(s.quantity*s.price),0) FROM 
			users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON 
			(p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE stateFilter
			 AND categoryFilter AND lowerAgeFilter AND upperAgeFilter GROUP BY u.id 
			ORDER BY u.name LIMIT 20 OFFSET +(nextRows*20);
--Customer Spent Cells
SELECT p.id, p.name, u.name, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id)
LEFT OUTER JOIN sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id WHERE p.name >= prodNames.get(0)
 AND p.name <= prodNames.get(prodNames.size()-1) AND u.name >= customerNames.get(0)+
  AND u.name <= customerNames.get(custonerNames.size()-1) GROUP BY u.name, p.id ORDER BY u.name

