use systemes_operationnels_data_warehouse;
GO
--------------------------------------------------
-- silver.account
--------------------------------------------------

IF OBJECT_ID('silver.accounts', 'U') IS NOT NULL
DROP TABLE silver.accounts;

create table silver.accounts (
	account_number INT PRIMARY KEY,
	account_name VARCHAR(50),
	account_type VARCHAR(50),
	currency VARCHAR(4));

INSERT INTO silver.accounts (
    account_number,
    account_name,
    account_type,
    currency
)
SELECT DISTINCT
    TRY_CAST(account_number AS INT),

    UPPER(LTRIM(RTRIM(account_name))),

    UPPER(LTRIM(RTRIM(account_type))),

    UPPER(LTRIM(RTRIM(currency)))

FROM bronze.account_raw
WHERE account_number IS NOT NULL;

select * from silver.accounts;


--------------------------------------------------
-- silver.account_mapping
--------------------------------------------------

IF OBJECT_ID('silver.account_mapping', 'U') IS NOT NULL
DROP TABLE silver.account_mapping;

CREATE TABLE silver.account_mapping (
    AccountNumber INT PRIMARY KEY, -- We can now safely add a PRIMARY KEY!
    AccountName VARCHAR(25),
    PLLine VARCHAR(25),
    StatementType VARCHAR(25)
);

-- 1. Create a CTE to clean and deduplicate the raw data
WITH CleanedAndDeduped AS (
    SELECT
        TRY_CAST(AccountNumber AS INT) AS AccountNumber,
        UPPER(LTRIM(RTRIM(AccountName))) AS AccountName,

        -- Gestion métier PLLine
        CASE 
            WHEN PLLine IS NULL OR LTRIM(RTRIM(PLLine)) = '' THEN NULL
            ELSE UPPER(LTRIM(RTRIM(PLLine)))
        END AS PLLine,

        -- Standardisation StatementType
        CASE 
            WHEN StatementType IS NULL OR LTRIM(RTRIM(StatementType)) = '' THEN NULL
            WHEN UPPER(REPLACE(LTRIM(RTRIM(StatementType)), ' ', '')) IN ('PL', 'P&L') THEN 'P&L'
            ELSE UPPER(LTRIM(RTRIM(StatementType)))
        END AS StatementType,

        -- 2. Apply the ROW_NUMBER logic to partition by the AccountNumber
        ROW_NUMBER() OVER (
            PARTITION BY TRY_CAST(AccountNumber AS INT)
            ORDER BY (SELECT NULL) -- Change this to 'ORDER BY AccountName DESC' etc., if you want a specific row to win
        ) AS rn
    FROM bronze.account_mapping_raw
    WHERE TRY_CAST(AccountNumber AS INT) IS NOT NULL
)

-- 3. Insert only the first row (rn = 1) into the Silver table
INSERT INTO silver.account_mapping (
    AccountNumber,
    AccountName,
    PLLine,
    StatementType
)
SELECT
    AccountNumber,
    AccountName,
    PLLine,
    StatementType
FROM CleanedAndDeduped
WHERE rn = 1;

select * from silver.accounts;
select * from silver.account_mapping;

--------------------------------------------------
-- silver..store
--------------------------------------------------

IF OBJECT_ID('silver.stores', 'U') IS NOT NULL
DROP TABLE silver.stores;

create table silver.stores (
	store_code VARCHAR(25) PRIMARY KEY,
	country VARCHAR(50),
	region VARCHAR(25));

INSERT INTO silver.stores (
    store_code,
    country,
    region
)

SELECT DISTINCT
    UPPER(LTRIM(RTRIM(store_code))),

    UPPER(LTRIM(RTRIM(country))),

    UPPER(LTRIM(RTRIM(region)))

FROM bronze.store_raw
WHERE store_code IS NOT NULL;

select * from silver.stores;

--------------------------------------------------
-- silver.store_master
--------------------------------------------------

IF OBJECT_ID('silver.store_masters', 'U') IS NOT NULL
DROP TABLE silver.store_masters;

create table silver.store_masters (
	store_code VARCHAR(25),
	store_name VARCHAR(50),
	store_type VARCHAR(25));

INSERT INTO silver.store_masters (
    store_code,
    store_name,
    store_type
)
SELECT DISTINCT
    UPPER(LTRIM(RTRIM(store_code))),

    UPPER(LTRIM(RTRIM(store_name))),

    UPPER(LTRIM(RTRIM(store_type)))

FROM bronze.store_master_raw
WHERE store_code IS NOT NULL;

select * from silver.store_masters;



--------------------------------------------------
-- silver..transaction
--------------------------------------------------

IF OBJECT_ID('silver.transactions', 'U') IS NOT NULL
DROP TABLE silver.transactions;

create table silver.transactions (
	transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    store_code VARCHAR(25),
    account_number INT,
    amount_local DECIMAL(19,2),
    currency VARCHAR(4),
    document_number VARCHAR(50),
    description VARCHAR(350));

INSERT INTO silver.transactions (
    transaction_id,
    transaction_date,
    store_code,
    account_number,
    amount_local,
    currency,
    document_number,
    description
)

SELECT DISTINCT
    TRY_CAST(transaction_id AS INT),

    TRY_CAST(transaction_date AS DATE),

    UPPER(LTRIM(RTRIM(store_code))),

    TRY_CAST(account_number AS INT),

    TRY_CAST(amount_local AS DECIMAL(19,2)),

    UPPER(LTRIM(RTRIM(currency))),

    LTRIM(RTRIM(document_number)),

    LTRIM(RTRIM(description))
FROM bronze.transaction_raw
WHERE TRY_CAST(transaction_id AS INT) IS NOT NULL;

select * from silver.transactions;

