/* ==========================================================
   SQL Script: Create Clean Data Warehouse Environment
   Author: Tejas Vyasam
   Purpose: Drops existing 'datawarehouse01' (if any),
            then recreates it with bronze, silver, and gold schemas.
   Notes:
     - Use only in a DEV or TEST environment!
     - This will DELETE all data in 'datawarehouse01'.
========================================================== */

-- Switch to the system database before managing other DBs
USE master;
GO

PRINT 'Step 1: Checking if datawarehouse01 already exists...';
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = N'datawarehouse01')
BEGIN
    PRINT 'Database found. Switching to SINGLE_USER mode and dropping it...';
    ALTER DATABASE datawarehouse01 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE datawarehouse01;
    PRINT 'Existing database dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Database not found. Proceeding to create a new one...';
END
GO

-- Create the new database
PRINT 'Step 2: Creating fresh database [datawarehouse01]...';
CREATE DATABASE datawarehouse01;
GO
PRINT 'Database created successfully.';
GO

-- Switch context to the new database
USE datawarehouse01;
GO
PRINT 'Switched to database [datawarehouse01].';

-- Create medallion architecture schemas
PRINT 'Step 3: Creating schemas for medallion architecture...';

CREATE SCHEMA bronze;
PRINT 'Schema [bronze] created successfully. (Raw ingestion layer)';
GO

CREATE SCHEMA silver;
PRINT 'Schema [silver] created successfully. (Cleaned & conformed layer)';
GO

CREATE SCHEMA gold;
PRINT 'Schema [gold] created successfully. (Curated/reporting layer)';
GO

PRINT 'All schemas created successfully!';
PRINT '===========================================';
PRINT 'Data Warehouse setup complete ✅';
PRINT '===========================================';
