-- 1. Cria um relatório para todos os pedidos de 1996 e seus clientes (152 linhas)
SELECT
	*
FROM
	orders
INNER JOIN
	customers
ON
	orders.customer_id = customers.customer_id
WHERE
	EXTRACT(YEAR FROM order_date) = 1996

-- 2. Cria um relatório que mostra o número de funcionários e clientes de cada cidade que tem funcionários (5 linhas)
SELECT
	e.city,
	COUNT(DISTINCT(e.employee_id)) AS total_employees,
	COUNT(DISTINCT(c.customer_id)) AS total_customers
FROM
	employees e 
LEFT JOIN
	customers c
ON
	e.city = c.city
GROUP BY
	e.city

-- 3. Cria um relatório que mostra o número de funcionários e clientes de cada cidade que tem clientes (69 linhas)
SELECT
	c.city,
	COUNT(DISTINCT(e.employee_id)) AS total_employees,
	COUNT(DISTINCT(c.customer_id)) AS total_customers
FROM
	customers c
LEFT JOIN
	employees e
ON
	e.city = c.city
GROUP BY
	c.city

-- 4.Cria um relatório que mostra o número de funcionários e clientes de cada cidade (71 linhas)
SELECT
	COALESCE(c.city, e.city) AS city,
	COUNT(e.employee_id) AS total_employees,
	COUNT(c.customer_id) AS total_customers
FROM
	customers c
FULL JOIN
	employees e
ON
	e.city = c.city
GROUP BY
	COALESCE(c.city, e.city)

-- 5. Cria um relatório que mostra a quantidade total de produtos encomendados.
-- Mostra apenas registros para produtos para os quais a quantidade encomendada é menor que 200 (5 linhas)
SELECT
	od.product_id,
	SUM(od.quantity) AS total_quantity
FROM
	order_details od
INNER JOIN
	orders o
ON
	od.order_id = o.order_id
GROUP BY
	od.product_id
HAVING
	SUM(od.quantity) < 200

-- 6. Cria um relatório que mostra o total de pedidos por cliente desde 31 de dezembro de 1996.
-- O relatório deve retornar apenas linhas para as quais o total de pedidos é maior que 15 (5 linhas)
SELECT
	COUNT(order_id),
	customer_id
FROM
	orders
WHERE
	order_date >= '1996-12-31'
GROUP BY
	customer_id
HAVING
	COUNT(order_id) > 15