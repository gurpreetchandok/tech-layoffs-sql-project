-- World Layoffs - Data Cleaning with MySQL

-- This data source has been taken from the following link:
-- https://www.kaggle.com/datasets/swaptr/layoffs-2022


-- Load initial dataset
SELECT * FROM 
world_layoffs.layoffs;


-- Create a staging table for data cleaning, keeping the raw data intact
CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;


INSERT INTO 
world_layoffs.layoffs_staging 


SELECT * FROM world_layoffs.layoffs;

-- Data cleaning steps:
-- 1. Identify and remove duplicate records
-- 2. Standardize and correct inconsistent data
-- 3. Handle null values appropriately
-- 4. Remove unnecessary columns and rows


-- Step 1: Identify duplicate records
SELECT company, 
industry, 
total_laid_off, 
`date`,
       ROW_NUMBER() OVER (PARTITION BY company, industry, total_laid_off, `date`) AS row_num
FROM world_layoffs.layoffs_staging;



-- Identify duplicates by checking all relevant columns
SELECT * FROM (
    SELECT company, location, 
    industry, 
    total_laid_off, 
    percentage_laid_off, 
    `date`, 
    stage, 
    country, 
    funds_raised_millions,
           ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
    FROM world_layoffs.layoffs_staging
) duplicates WHERE row_num > 1;



-- Remove duplicates while keeping one instance
DELETE FROM world_layoffs.layoffs_staging
WHERE (company, 
location, 
industry, 
total_laid_off, 
percentage_laid_off, 
`date`, 
stage, 
country, 
funds_raised_millions) IN (

    SELECT company, 
    location, 
    industry, 
    total_laid_off, 
    percentage_laid_off, 
    `date`,
    stage, 
    country, 
    funds_raised_millions
    FROM (
        SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
               ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
        FROM world_layoffs.layoffs_staging
    ) duplicate_rows WHERE row_num > 1
);



-- Step 2: Standardize and clean data
-- Convert empty strings to NULL in the 'industry' column


UPDATE world_layoffs.layoffs_staging 
SET industry = NULL WHERE industry = '';



-- Populate missing industry values based on existing data for the same company
UPDATE layoffs_staging t1
JOIN layoffs_staging t2 
	ON t1.company = t2.company
    SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;



-- Standardize industry names (e.g., merge different variations of 'Crypto')
UPDATE layoffs_staging 
SET industry = 'Crypto' 
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');



-- Standardize country names (remove trailing periods)
UPDATE layoffs_staging 
SET country = TRIM(TRAILING '.' FROM country);



-- Convert date column to proper DATE format
UPDATE layoffs_staging 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');



ALTER TABLE layoffs_staging 
MODIFY COLUMN `date` DATE;



-- Step 3: Handle NULL values
-- Keeping NULL values in 'total_laid_off', 'percentage_laid_off', and 'funds_raised_millions' for accurate analysis later

-- Step 4: Remove irrelevant rows and columns
-- Identify and remove rows with no useful data (both 'total_laid_off' and 'percentage_laid_off' are NULL)


DELETE FROM world_layoffs.layoffs_staging 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;



-- Drop temporary column used for row numbering if it was added earlier
ALTER TABLE layoffs_staging 
DROP COLUMN row_num;



-- Final check on cleaned data
SELECT * FROM 
world_layoffs.layoffs_staging;


































