-- Qual foi o total de receitas no ano de 1997?
SELECT
	SUM((1 - od.discount)*(od.quantity * od.unit_price)) AS total_revenues_1997
FROM
	orders o
INNER JOIN
	order_details od
ON
	o.order_id = od.order_id
WHERE
	EXTRACT(YEAR FROM o.order_date) = '1997'

-- Faça uma análise de crescimento mensal e o cálculo de YTD
WITH ReceitasMensais AS (
    SELECT
        EXTRACT(YEAR FROM orders.order_date) AS Ano,
        EXTRACT(MONTH FROM orders.order_date) AS Mes,
        SUM(order_details.unit_price * order_details.quantity * (1.0 - order_details.discount)) AS Receita_Mensal
    FROM
        orders
    INNER JOIN
        order_details ON orders.order_id = order_details.order_id
    GROUP BY
        EXTRACT(YEAR FROM orders.order_date),
        EXTRACT(MONTH FROM orders.order_date)
),
ReceitasAcumuladas AS (
    SELECT
        Ano,
        Mes,
        Receita_Mensal,
        SUM(Receita_Mensal) OVER (PARTITION BY Ano ORDER BY Mes) AS Receita_YTD
    FROM
        ReceitasMensais
)
SELECT
    Ano,
    Mes,
    Receita_Mensal,
    Receita_Mensal - LAG(Receita_Mensal) OVER (PARTITION BY Ano ORDER BY Mes) AS Diferenca_Mensal,
    Receita_YTD,
    (Receita_Mensal - LAG(Receita_Mensal) OVER (PARTITION BY Ano ORDER BY Mes)) / LAG(Receita_Mensal) OVER (PARTITION BY Ano ORDER BY Mes) * 100 AS Percentual_Mudanca_Mensal
FROM
    ReceitasAcumuladas
ORDER BY
    Ano, Mes

-- Qual é o valor total que cada cliente já pagou até agora?
SELECT
	c.company_name,
	SUM((1 - od.discount)*(od.quantity * od.unit_price)) AS total
FROM
	orders o
INNER JOIN
	order_details od
ON
	o.order_id = od.order_id
INNER JOIN 
    customers c
ON
	c.customer_id = o.customer_id
GROUP BY 
    c.company_name
ORDER BY
	SUM((1 - od.discount)*(od.quantity * od.unit_price)) DESC

-- Separe os clientes em 5 grupos de acordo com o valor pago por cliente
SELECT
	c.company_name,
	SUM((1 - od.discount)*(od.quantity * od.unit_price)) AS total,
	NTILE(5) OVER(ORDER BY (SUM((1 - od.discount)*(od.quantity * od.unit_price))) DESC) AS customer_group
FROM
	orders o
INNER JOIN
	order_details od
ON
	o.order_id = od.order_id
INNER JOIN 
    customers c
ON
	c.customer_id = o.customer_id
GROUP BY 
    c.company_name

-- Agora somente os clientes que estão nos grupos 3, 4 e 5 para que seja feita uma análise de Marketing especial com eles
WITH customer_grouped_by_value AS(
	SELECT
		c.company_name,
		SUM((1 - od.discount)*(od.quantity * od.unit_price)) AS total,
		NTILE(5) OVER(ORDER BY (SUM((1 - od.discount)*(od.quantity * od.unit_price))) DESC) AS customer_group
	FROM
		orders o
	INNER JOIN
		order_details od
	ON
		o.order_id = od.order_id
	INNER JOIN 
	    customers c
	ON
		c.customer_id = o.customer_id
	GROUP BY 
	    c.company_name
)
SELECT
	*
FROM
	customer_grouped_by_value cgbv
WHERE
	cgbv.customer_group IN (3, 4, 5)

-- Identificar os 10 produtos mais vendidos
SELECT
	p.product_name,
	SUM(od.quantity) AS total_sells
FROM
	order_details od
INNER JOIN
	products p
ON
	od.product_id = p.product_id
GROUP BY
	p.product_name
ORDER BY
	SUM(od.quantity) DESC
LIMIT 10

-- Quais clientes do Reino Unido pagaram mais de 1000 dólares?
SELECT
	c.company_name,
	SUM((1 - od.discount)*(od.quantity * od.unit_price)) AS total
FROM
	orders o
INNER JOIN
	order_details od
ON
	o.order_id = od.order_id
INNER JOIN
	customers c
ON
	o.customer_id = c.customer_id
WHERE
	c.country = 'UK'
GROUP BY
	c.company_name
HAVING
	SUM((1 - od.discount)*(od.quantity * od.unit_price)) > 1000