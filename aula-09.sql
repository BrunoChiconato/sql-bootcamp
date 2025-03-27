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