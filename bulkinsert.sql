use systemes_operationnels_data_warehouse

BULK INSERT bronze.account_raw
FROM 'C:\Users\amine\Desktop\simplon\Bases des Données\Construction dun data warehouse\data\account.csv'
WITH (
    FIRSTROW = 2,             
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001',
    KEEPNULLS
);

BULK INSERT bronze.account_mapping_raw
FROM 'C:\Users\amine\Desktop\simplon\Bases des Données\Construction dun data warehouse\data\account_mapping.csv'
WITH (
    FIRSTROW = 2,              
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001',
    KEEPNULLS
);

BULK INSERT bronze.store_master_raw
FROM 'C:\Users\amine\Desktop\simplon\Bases des Données\Construction dun data warehouse\data\store_master.csv'
WITH (
    FIRSTROW = 2,              
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001',
    KEEPNULLS
);

BULK INSERT bronze.store_raw
FROM 'C:\Users\amine\Desktop\simplon\Bases des Données\Construction dun data warehouse\data\store.csv'
WITH (
    FIRSTROW = 2,              
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001',
    KEEPNULLS
);

BULK INSERT bronze.transaction_raw
FROM 'C:\Users\amine\Desktop\simplon\Bases des Données\Construction dun data warehouse\data\transaction.csv'
WITH (
    FIRSTROW = 2,              
    FIELDTERMINATOR = ',',     
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001',
    KEEPNULLS
);