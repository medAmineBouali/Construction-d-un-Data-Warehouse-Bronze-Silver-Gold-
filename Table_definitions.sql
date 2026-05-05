use systemes_operationnels_data_warehouse;

create table bronze.account_raw (
	account_number VARCHAR(50),
	account_name VARCHAR(50),
	account_type VARCHAR(50),
	currency VARCHAR(50));
select * from bronze.account_raw;

create table bronze.store_master_raw (
	store_code VARCHAR(50),
	store_name VARCHAR(50),
	store_type VARCHAR(50));
select * from bronze.store_master_raw;

create table bronze.account_mapping_raw (
	AccountNumber VARCHAR(50),
	AccountName VARCHAR(50),
	PLLine VARCHAR(50),
	StatementType VARCHAR(50),
	SortOrder VARCHAR(50),
	Notes VARCHAR(150));
select * from bronze.account_mapping_raw;

create table bronze.store_raw (
	store_code VARCHAR(50),
	country VARCHAR(50),
	region VARCHAR(50));
select * from bronze.store_raw;

create table bronze.transaction_raw (
	transaction_id VARCHAR(50),
	transaction_date VARCHAR(50),
	store_code VARCHAR(50),
	account_number VARCHAR(50),
	amount_local VARCHAR(50),
	currency VARCHAR(50),
	document_number VARCHAR(50),
	description VARCHAR(400));
select * from bronze.transaction_raw;
