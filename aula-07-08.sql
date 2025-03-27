CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS clients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    balance_limit INTEGER NOT NULL,
    balance INTEGER NOT NULL,
	CHECK (balance <= balance_limit)
);

CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY NOT NULL,
    transaction_type CHAR(1) NOT NULL,
    description VARCHAR(10) NOT NULL,
    value INTEGER NOT NULL,
    client_id UUID NOT NULL,
    transaction_datetime TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO
	clients (balance_limit, balance)
VALUES
    (10000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);

CREATE OR REPLACE PROCEDURE perform_transaction(
    IN p_transaction_type CHAR(1),
    IN p_description VARCHAR(10),
    IN p_value INTEGER,
    IN p_client_idCREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS clients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    balance_limit INTEGER NOT NULL,
    balance INTEGER NOT NULL,
	CHECK (balance <= balance_limit)
);

CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY NOT NULL,
    transaction_type CHAR(1) NOT NULL,
    description VARCHAR(10) NOT NULL,
    value INTEGER NOT NULL,
    client_id UUID NOT NULL,
    transaction_datetime TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO
	clients (balance_limit, balance)
VALUES
    (10000, 0),
    (80000, 0),
    (1000000, 0),
    (10000000, 0),
    (500000, 0);

CREATE OR REPLACE PROCEDURE perform_transaction(
    IN p_transaction_type CHAR(1),
    IN p_description VARCHAR(10),
    IN p_value INTEGER,
    IN p_client_id UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
    current_balance INTEGER;
    balance_limit_client INTEGER;
BEGIN
    SELECT
		balance,
		balance_limit
	INTO
		current_balance,
		balance_limit_client
	FROM
		clients
	WHERE
		id = p_cliente_id;

	IF
		p_transaction_type = 'd' AND current_balance - p_value < -balance_limit_client
		THEN RAISE EXCEPTION 'Saldo insuficiente para realizar a transação';
	END IF;

	UPDATE
		clients
	SET
		balance = balance + CASE WHEN p_transaction_type = 'd' THEN -p_value ELSE p_value END
	WHERE
		id = p_cliente_id;

	INSERT INTO
		transactions (transaction_type, description, value, client_id)
	VALUES
		(p_transaction_type, p_description, p_value, p_client_id);
END;
$$;

CALL perform_transaction('d', 'carro', 8000, '0b09cfc8-c52e-4882-b617-548c64b574dc');

CREATE OR REPLACE PROCEDURE bank_statement(
    IN p_client_id UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
    current_balance INTEGER;
    balance_limit_client INTEGER;
	rec RECORD;
BEGIN
    SELECT
		balance
	INTO
		current_balance
	FROM
		clients
	WHERE
		id = p_client_id;

	RAISE NOTICE 'Seu saldo atual é: %', current_balance;

	RAISE NOTICE 'Extrato das últimas 10 transações realizadas:';
	RAISE NOTICE '=============================================';
	
	FOR rec IN SELECT id, CASE WHEN transaction_type = 'c' THEN 'Crédito' ELSE 'Débito' END AS transaction_type, description, value, transaction_datetime FROM transactions WHERE client_id = p_client_id ORDER BY transaction_datetime DESC LIMIT 10 LOOP
		RAISE NOTICE 'ID: % | Tipo de transação: % | Descrição: % | Valor: % | Data da transação: %', rec.id, rec.transaction_type, rec.description, rec.value, rec.transaction_datetime;
	END LOOP;

	RAISE NOTICE '=============================================';
END;
$$;

CALL bank_statement('0b09cfc8-c52e-4882-b617-548c64b574dc')