use systemes_operationnels_data_warehouse;

-- 1. Check if dim_account correctly captured all 9 unique accounts
SELECT COUNT(*) AS Total_Accounts_In_Gold 
FROM gold.dim_account; 
-- Expected Result: 9

-- 2. Identify the 3 accounts that were missing from silver.accounts
SELECT * 
FROM gold.dim_account
WHERE account_type = 'UNKNOWN';

-- 3. Check for Orphaned Transactions (Transactions mapped to an account not in our Gold dimension)
SELECT COUNT(*) AS Orphaned_Transactions
FROM gold.fact_gl f
LEFT JOIN gold.dim_account a ON f.account_number = a.account_number
WHERE a.account_number IS NULL;
-- Expected Result: 0

-- 4. Check for duplicate Accounts in gold.dim_account
SELECT account_number, COUNT(*) AS Duplicate_Count
FROM gold.dim_account
GROUP BY account_number
HAVING COUNT(*) > 1;
-- Expected Result: 0 rows

-- 5. Check for duplicate Stores in gold.dim_store
SELECT store_code, COUNT(*) AS Duplicate_Count
FROM gold.dim_store
GROUP BY store_code
HAVING COUNT(*) > 1;
-- Expected Result: 0 rows

-- 6. Check for duplicate Transactions in silver.transactions 
-- (or gold.fact_gl depending on your final fact table name)
SELECT transaction_id, COUNT(*) AS Duplicate_Count
FROM silver.transactions 
GROUP BY transaction_id
HAVING COUNT(*) > 1;
-- Expected Result: 0 rows

-- 7. Check for duplicate mappings in silver.account_mapping 
-- (Before the deduplication CTE in the Gold view)
SELECT AccountNumber, COUNT(*) AS Duplicate_Count
FROM silver.account_mapping
GROUP BY AccountNumber
HAVING COUNT(*) > 1;
-- Expected Result: 0 rows