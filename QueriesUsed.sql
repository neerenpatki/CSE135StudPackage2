
// Total amount spent by each user
SELECT u.name, SUM(c.quantity*c.price) as Total FROM users u, carts c WHERE c.uid = u.id GROUP BY u.id ORDER BY u.name

// Amount spent per product by each user
SELECT u.name, p.name, (c.quantity* c.price) as SpentPerProduct FROM users u, carts c, products p WHERE c.uid = u.id AND p.id = c.pid
// Total for each product
SELECT  p.name, SUM(c.quantity*c.price) FROM products p, carts c WHERE c.pid = p.id GROUP BY p.id


SELECT u.name, SUM(c.quantity*c.price) as TotalSpent FROM users u, carts c WHERE c.uid = u.id GROUP BY u.id ORDER BY u.name

SELECT * FROM users

SELECT * FROM carts

SELECT u.name, p.name, (c.quantity* c.price) as SpentPerProduct FROM users u, carts c, products p WHERE c.uid = u.id AND p.id = c.pid

SELECT * FROM products

SELECT u.name, p.name, (c.quantity* c.price) as SpentPerProduct FROM users u, carts c, products p WHERE u.id = 6 AND c.uid = u.id
AND p.id = 10 AND c.pid = p.id

SELECT id, RPAD(name,10,'') FROM products ORDER BY name LIMIT 10

// Query for total money spent by state
SELECT u.state, SUM(s.quantity*s.price) FROM users u, sales s WHERE u.state = 'Alabama' AND u.id = s.uid
GROUP BY u.state


SELECT u.state, SUM(s.quantity*s.price) FROM users u, sales s WHERE u.state = 'Alabama' AND u.id = s.uid
GROUP BY u.state

SELECT SUM(s.quantity*s.price) FROM users u, sales s, products p WHERE u.state = 'Alabama' 
AND s.uid = u.id AND p.id = 1 AND s.pid = p.id

SELECT u.name, SUM(s.quantity*s.price) as Total FROM users u, sales s WHERE s.uid = u.id GROUP BY u.id ORDER BY u.name

SELECT p.name, SUM(s.quantity*s.price) FROM products p, sales s, users u WHERE p.id = s.pid 
AND p.name = 'Apple MacBook' AND u.state = 'Alabama' AND u.id = s.uid GROUP BY p.id ORDER BY p.name


SELECT u.name, p.name, (s.quantity* s.price) FROM users u, sales s, products p WHERE u.id = 5 AND s.uid = u.id
AND p.id = 1 AND s.pid = p.id