-- 1. Drop the existing physical table
IF OBJECT_ID('gold.dim_account', 'U') IS NOT NULL
    DROP TABLE gold.dim_account;
GO

-- 2. Create the new view
CREATE OR ALTER VIEW gold.dim_account AS
WITH MostCommonValues AS (
    -- Dynamically find the most frequent currency
    SELECT 
        (SELECT TOP 1 currency 
         FROM silver.accounts 
         WHERE currency IS NOT NULL AND currency != 'UNKNOWN'
         GROUP BY currency 
         ORDER BY COUNT(*) DESC) AS DefaultCurrency,

    -- Dynamically find the most frequent StatementType
        (SELECT TOP 1 StatementType 
         FROM silver.account_mapping 
         WHERE StatementType IS NOT NULL AND StatementType != 'UNMAPPED'
         GROUP BY StatementType 
         ORDER BY COUNT(*) DESC) AS DefaultStatementType
)
SELECT 
    -- 1. Combine Keys and Names
    COALESCE(a.account_number, m.AccountNumber) AS account_number,
    COALESCE(a.account_name, m.AccountName) AS account_name,
    
    -- 2. Merge account_type and PLLine (Since they are the same concept)
    COALESCE(a.account_type, m.PLLine, 'UNKNOWN') AS account_type,
    
    -- 3. Impute Currency: Try silver.accounts first, fallback to the Most Common Currency
    COALESCE(a.currency, cv.DefaultCurrency) AS currency,
    
    -- 4. Impute Statement Type: Try silver.account_mapping first, fallback to Most Common Statement Type
    COALESCE(m.StatementType, cv.DefaultStatementType) AS statement_type

FROM silver.accounts a
FULL OUTER JOIN silver.account_mapping m 
    ON a.account_number = m.AccountNumber
CROSS JOIN MostCommonValues cv;
GO

SELECT * FROM gold.dim_account;

GO

IF OBJECT_ID('gold.dim_store', 'U') IS NOT NULL
    DROP TABLE gold.dim_store;
GO

CREATE OR ALTER VIEW gold.dim_store AS
SELECT 
    COALESCE(s.store_code, sm.store_code) AS store_code,
    COALESCE(sm.store_name, 'UNKNOWN') AS store_name,
    COALESCE(sm.store_type, 'UNKNOWN') AS store_type,
    COALESCE(s.country, 'UNKNOWN') AS country,
    COALESCE(s.region, 'UNKNOWN') AS region
FROM silver.stores s
FULL OUTER JOIN silver.store_masters sm
    ON s.store_code = sm.store_code;
GO

SELECT * FROM gold.dim_store;
GO

IF OBJECT_ID('gold.fact_gl', 'U') IS NOT NULL
    DROP TABLE gold.fact_gl;
GO

CREATE OR ALTER VIEW gold.fact_gl AS
SELECT 
    transaction_id,
    transaction_date,
    store_code,
    account_number,
    amount_local,
    currency,
    document_number,
    description
FROM silver.transactions;
GO

SELECT * FROM gold.fact_gl;
GO
