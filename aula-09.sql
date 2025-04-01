--============================== Exercise 1 ==============================--
CREATE TABLE employees (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100),
	salary DECIMAL(10, 2),
	hiring_date DATE
);

CREATE TABLE employee_audit (
	id INT,
	old_salary DECIMAL(10, 2),
	new_salary DECIMAL(10, 2),
	alteration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (id) REFERENCES employees(id)
);

INSERT INTO employees (name, salary, hiring_date) VALUES ('João', 4500.00, '2020-03-15');
INSERT INTO employees (name, salary, hiring_date) VALUES ('Ana', 5500.00, '2021-07-20');
INSERT INTO employees (name, salary, hiring_date) VALUES ('Pedro', 6000.00, '2019-01-10');
INSERT INTO employees (name, salary, hiring_date) VALUES ('Carla', 4800.00, '2022-11-05');
INSERT INTO employees (name, salary, hiring_date) VALUES ('Lucas', 5200.00, '2021-08-30');
INSERT INTO employees (name, salary, hiring_date) VALUES ('Bianca', 5300.00, '2020-12-12');
INSERT INTO employees (name, salary, hiring_date) VALUES ('Roberto', 4900.00, '2022-05-18');
INSERT INTO employees (name, salary, hiring_date) VALUES ('Juliana', 5100.00, '2018-10-02');
INSERT INTO employees (name, salary, hiring_date) VALUES ('Fernando', 5800.00, '2020-04-25');
INSERT INTO employees (name, salary, hiring_date) VALUES ('Patrícia', 5400.00, '2021-01-14');

CREATE OR REPLACE FUNCTION salary_register_audit()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO employee_audit (id, old_salary, new_salary)
	VALUES (OLD.id, OLD.salary, NEW.salary);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_modified_salary
AFTER UPDATE OF salary ON employees
FOR EACH ROW
EXECUTE FUNCTION salary_register_audit();

UPDATE employees
SET salary = 7000.00
WHERE name = 'Ana';

--============================== Exercise 2 ==============================--
CREATE TABLE products (
	product_code INT PRIMARY KEY,
	description VARCHAR(50) UNIQUE,
	available_quantity INT NOT NULL DEFAULT 0	
);
CREATE TABLE sales_registry(
	sale_code SERIAL PRIMARY KEY,
	product_code INT,
	sale_quantity INT,
	FOREIGN KEY (product_code) REFERENCES products(product_code) ON DELETE CASCADE
);
INSERT INTO products VALUES (1, 'Basic', 10);
INSERT INTO products VALUES (2, 'Data', 5);
INSERT INTO products VALUES (3, 'Summer', 15);

CREATE FUNCTION func_verify_stock()
RETURNS TRIGGER
AS $$
DECLARE
    init_quantity INTEGER;
BEGIN
    SELECT available_quantity INTO init_quantity
    FROM products 
    WHERE product_code = NEW.product_code;

    IF init_quantity < NEW.sale_quantity THEN
        RAISE EXCEPTION 'Not enough quantity in stock!';
    ELSE
        UPDATE products 
        SET available_quantity = (available_quantity - NEW.sale_quantity)
        WHERE product_code = NEW.product_code;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_verify_stock
BEFORE INSERT ON sales_registry
FOR EACH ROW
EXECUTE FUNCTION func_verify_stock();

INSERT INTO sales_registry (product_code, sale_quantity) VALUES (1, 10);
INSERT INTO sales_registry (product_code, sale_quantity) VALUES (1, 100);

--============================== Project ==============================--
CREATE MATERIALIZED VIEW sales_accumulated_monthly_mv AS
	SELECT
		EXTRACT(YEAR FROM o.order_date) AS year,
		EXTRACT(MONTH FROM o.order_date) AS month,
		SUM((od.unit_price * od.quantity) - od.discount*(od.unit_price * od.quantity)) As total_sales
	FROM
		orders o
	INNER JOIN
		order_details od
	ON
		o.order_id = od.order_id
	GROUP BY
		EXTRACT(YEAR FROM o.order_date),
		EXTRACT(MONTH FROM o.order_date)
	ORDER BY
		year,
		month

CREATE OR REPLACE FUNCTION refresh_mv_sales_accumulated()
RETURNS TRIGGER AS $$
BEGIN
    REFRESH MATERIALIZED VIEW sales_accumulated_monthly_mv;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_refresh_sales_accumulated_monthly_mv_order_details
AFTER INSERT OR UPDATE OR DELETE ON order_details
FOR EACH ROW EXECUTE FUNCTION refresh_mv_sales_accumulated();

CREATE TRIGGER trg_refresh_sales_accumulated_monthly_mv_orders
AFTER INSERT OR UPDATE OR DELETE ON orders
FOR EACH ROW EXECUTE FUNCTION refresh_mv_sales_accumulated();

INSERT INTO orders VALUES (11078, 'RATTC', 1, '1999-05-06', '1999-06-03', NULL, 2, 8.52999973, 'Rattlesnake Canyon Grocery', '2817 Milton Dr.', 'Albuquerque', 'NM', '87110', 'USA'); 
INSERT INTO order_details VALUES (11078, 77, 25, 23, 0);
INSERT INTO order_details VALUES (11078, 24, 23, 10, 0);
INSERT INTO order_details VALUES (11078, 35, 56, 5, 0.15);

SELECT
	*
FROM
	sales_accumulated_monthly_mv
