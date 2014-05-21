
// Total amount spent by each user
SELECT u.name, SUM(c.quantity*c.price) as Total FROM users u, carts c WHERE c.uid = u.id GROUP BY u.id ORDER BY u.name

// Amount spent per product by each user
SELECT u.name, p.name, (c.quantity* c.price) as SpentPerProduct FROM users u, carts c, products p WHERE c.uid = u.id AND p.id = c.pid
// Total for each product
SELECT  p.name, SUM(c.quantity*c.price) FROM products p, carts c WHERE c.pid = p.id GROUP BY p.id