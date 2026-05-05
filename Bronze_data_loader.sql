
CREATE OR ALTER PROCEDURE bronze.sp_load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @start_time DATETIME = GETDATE();
    DECLARE @data_path NVARCHAR(500) = 'C:\Users\amine\Desktop\simplon\Bases des Données\Construction dun data warehouse\data\';

    PRINT '=== START BRONZE LOAD ===';
    PRINT 'Start Time: ' + CAST(@start_time AS VARCHAR);

    --------------------------------------------------
    -- DROP TABLES IF EXIST
    --------------------------------------------------
    IF OBJECT_ID('bronze.transaction_raw', 'U') IS NOT NULL DROP TABLE bronze.transaction_raw;
    IF OBJECT_ID('bronze.store_raw', 'U') IS NOT NULL DROP TABLE bronze.store_raw;
    IF OBJECT_ID('bronze.store_master_raw', 'U') IS NOT NULL DROP TABLE bronze.store_master_raw;
    IF OBJECT_ID('bronze.account_mapping_raw', 'U') IS NOT NULL DROP TABLE bronze.account_mapping_raw;
    IF OBJECT_ID('bronze.account_raw', 'U') IS NOT NULL DROP TABLE bronze.account_raw;

    PRINT 'Tables dropped';

    --------------------------------------------------
    -- CREATE TABLES
    --------------------------------------------------
    CREATE TABLE bronze.account_raw (
        account_number VARCHAR(50),
        account_name VARCHAR(50),
        account_type VARCHAR(50),
        currency VARCHAR(50)
    );

    CREATE TABLE bronze.store_master_raw (
        store_code VARCHAR(50),
        store_name VARCHAR(50),
        store_type VARCHAR(50)
    );


    CREATE TABLE bronze.account_mapping_raw (
        AccountNumber VARCHAR(50),
        AccountName VARCHAR(50),
        PLLine VARCHAR(50),
        StatementType VARCHAR(50),
        SortOrder VARCHAR(50),
        Notes VARCHAR(150)
    );
    

    CREATE TABLE bronze.store_raw (
        store_code VARCHAR(50),
        country VARCHAR(50),
        region VARCHAR(50)
    );


    CREATE TABLE bronze.transaction_raw (
        transaction_id VARCHAR(50),
        transaction_date VARCHAR(50),
        store_code VARCHAR(50),
        account_number VARCHAR(50),
        amount_local VARCHAR(50),
        currency VARCHAR(50),
        document_number VARCHAR(50),
        description VARCHAR(400)
    );

    PRINT 'Tables created';

    --------------------------------------------------
    -- BULK INSERT (Dynamic SQL for path variable)
    --------------------------------------------------

    DECLARE @sql NVARCHAR(MAX);

    -- ACCOUNT
    SET @sql = '
    BULK INSERT bronze.account_raw
    FROM ''' + @data_path + 'account.csv''
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        TABLOCK,
        CODEPAGE = ''65001'',
        KEEPNULLS
    );';
    EXEC sp_executesql @sql;

    -- ACCOUNT MAPPING
    SET @sql = '
    BULK INSERT bronze.account_mapping_raw
    FROM ''' + @data_path + 'account_mapping.csv''
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        TABLOCK,
        CODEPAGE = ''65001'',
        KEEPNULLS
    );';
    EXEC sp_executesql @sql;

    -- STORE MASTER
    SET @sql = '
    BULK INSERT bronze.store_master_raw
    FROM ''' + @data_path + 'store_master.csv''
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        TABLOCK,
        CODEPAGE = ''65001'',
        KEEPNULLS
    );';
    EXEC sp_executesql @sql;

    -- STORE
    SET @sql = '
    BULK INSERT bronze.store_raw
    FROM ''' + @data_path + 'store.csv''
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        TABLOCK,
        CODEPAGE = ''65001'',
        KEEPNULLS
    );';
    EXEC sp_executesql @sql;

    -- TRANSACTION
    SET @sql = '
    BULK INSERT bronze.transaction_raw
    FROM ''' + @data_path + 'transaction.csv''
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        TABLOCK,
        CODEPAGE = ''65001'',
        KEEPNULLS
    );';
    EXEC sp_executesql @sql;

    PRINT 'Data loaded';

    --------------------------------------------------
    -- LOGGING TIME
    --------------------------------------------------
    DECLARE @end_time DATETIME = GETDATE();
    DECLARE @duration INT = DATEDIFF(SECOND, @start_time, @end_time);

    PRINT 'End Time: ' + CAST(@end_time AS VARCHAR);
    PRINT 'Duration (seconds): ' + CAST(@duration AS VARCHAR);

    PRINT '=== END BRONZE LOAD ===';

END;
GO

EXEC bronze.sp_load_bronze;