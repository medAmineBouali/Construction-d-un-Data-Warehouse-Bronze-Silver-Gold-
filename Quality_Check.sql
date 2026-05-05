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