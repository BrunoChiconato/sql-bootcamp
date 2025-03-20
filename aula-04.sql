-- Faça a classificação dos produtos mais vendidos usando usando RANK(), DENSE_RANK() e ROW_NUMBER()
-- Essa questão tem 2 implementações, veja uma que utiliza subquery e uma que não utiliza.
-- Tabelas utilizadas: FROM order_details o JOIN products p ON p.product_id = o.product_id;
SELECT
	p.product_name,
	SUM(o.quantity) AS total_quantity,
	RANK() OVER(ORDER BY(SUM(o.quantity)) DESC),
	DENSE_RANK() OVER(ORDER BY(SUM(o.quantity)) DESC),
	ROW_NUMBER() OVER(ORDER BY(SUM(o.quantity)) DESC)
FROM
	order_details o
INNER JOIN
	products p
ON
	p.product_id = o.product_id
GROUP BY
	p.product_name

--

SELECT
	sub.product_name,
	sub.total_quantity,
	RANK() OVER (ORDER BY sub.total_quantity DESC),
	DENSE_RANK() OVER (ORDER BY sub.total_quantity DESC),
	ROW_NUMBER() OVER (ORDER BY sub.total_quantity DESC)
FROM(
	SELECT
		p.product_name,
		SUM(o.quantity) AS total_quantity
	FROM
		order_details o
	INNER JOIN
		products p
	ON
		p.product_id = o.product_id
	GROUP BY
		p.product_name
) AS sub

-- Listar funcionários dividindo-os em 3 grupos usando NTILE
-- FROM employees;
SELECT
	CONCAT(title_of_courtesy, first_name, ' ', last_name),
	NTILE(3) OVER(ORDER BY first_name, last_name)
FROM
	employees

-- Ordene os custos de envio pagos pelos clientes de acordo 
-- com suas datas de pedido, mostrando o custo anterior e o custo posterior usando LAG e LEAD:
-- FROM orders JOIN shippers ON shippers.shipper_id = orders.ship_via;
SELECT
	o.customer_id,
	o.order_date,
	o.freight,
	LAG(freight, 1) OVER(ORDER BY o.customer_id, o.order_date),
	LEAD(freight, 1) OVER(ORDER BY o.customer_id, o.order_date)
FROM 
	orders o
INNER JOIN
	shippers s
ON
	s.shipper_id = o.ship_via

-- Desafio extra: questão entrevista Google
-- https://medium.com/@aggarwalakshima/interview-question-asked-by-google-and-difference-among-row-number-rank-and-dense-rank-4ca08f888486#:~:text=ROW_NUMBER()%20always%20provides%20unique,a%20continuous%20sequence%20of%20ranks.
-- https://platform.stratascratch.com/coding/10351-activity-rank?code_type=3
-- https://www.youtube.com/watch?v=db-qdlp8u3o
SELECT
    from_user,
    COUNT(from_user) AS total_emails_sent,
    ROW_NUMBER() OVER(ORDER BY (COUNT(from_user)) DESC, from_user ASC) AS ranking
FROM
    google_gmail_emails
GROUP BY
    from_user