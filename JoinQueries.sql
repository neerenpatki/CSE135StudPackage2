SELECT p.id, p.name FROM products p, categories c WHERE c.name=c.name AND c.id=p.cid ORDER BY p.name

EXPLAIN ANALYZE VERBOSE
SELECT * INTO tempTable FROM (SELECT p.id, p.name, u.name as user, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id
GROUP BY u.name, p.id ORDER BY u.name) AS T

EXPLAIN ANALYZE VERBOSE
SELECT p.id, p.name, u.name as user, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id WHERE p.name >= 'Apple Macbook' AND p.name <= 
'Samsung Galaxy' AND u.name <= 'A_user_10437'
GROUP BY u.name, p.id ORDER BY u.name

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


SELECT d.datname AS Name,  pg_catalog.pg_get_userbyid(d.datdba) AS Owner,
    CASE WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT')
        THEN pg_catalog.pg_size_pretty(pg_catalog.pg_database_size(d.datname))
        ELSE 'No Access'
    END AS Size
FROM pg_catalog.pg_database d
    ORDER BY
    CASE WHEN pg_catalog.has_database_privilege(d.datname, 'CONNECT')
        THEN pg_catalog.pg_database_size(d.datname)
        ELSE NULL
    END DESC -- nulls first
    LIMIT 20

SELECT * FROM sales
