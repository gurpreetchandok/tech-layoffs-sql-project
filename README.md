# tech-layoffs-sql-project

SQL Data Cleaning Project - Tech Layoffs Dataset

Overview

This project involves cleaning and preparing a dataset on tech layoffs for further analysis. The dataset has been sourced from Kaggle (Tech Layoffs Dataset). The goal is to remove inconsistencies, standardize data, and ensure it is structured for effective exploratory data analysis (EDA).

Database Schema

Table Name: world_layoffs.layoffs_staging

Columns:

company (TEXT) - Name of the company

location (TEXT) - Location of the company

industry (TEXT) - Industry of the company

total_laid_off (INT) - Number of employees laid off

percentage_laid_off (TEXT) - Percentage of employees laid off

date (DATE) - Layoff event date

stage (TEXT) - Stage of the company (e.g., startup, public)

country (TEXT) - Country of the company

funds_raised_millions (INT) - Total funds raised (in millions)

Data Cleaning Steps

1. Creating a Staging Table

A staging table layoffs_staging was created to ensure the raw data remains intact.

The dataset was copied into this new table to perform transformations.

2. Handling Duplicates

Identified duplicate rows using the ROW_NUMBER() function.

Removed duplicate entries while preserving one instance of each unique record.

3. Standardizing and Cleaning Data

Industry Column:

Converted empty values to NULL.

Filled missing values by referencing other rows with the same company name.

Standardized different variations of industry names (e.g., Crypto Currency → Crypto).

Country Column:

Removed inconsistent trailing periods (United States. → United States).

Date Column:

Converted date values from text format to proper DATE format using STR_TO_DATE().

Modified the column datatype to DATE.

4. Handling Null Values

Retained NULL values in total_laid_off, percentage_laid_off, and funds_raised_millions for better analysis rather than using placeholders.

5. Removing Unnecessary Data

Deleted rows where both total_laid_off and percentage_laid_off were NULL, as these records contained no useful information.

Dropped temporary columns used for numbering duplicate records.

Final Data Validation

Ensured data integrity by running final SELECT * queries to review transformations.

Confirmed consistency across industry names, country names, and date formats.

Future Considerations

Further enhancement of data quality through exploratory analysis.

Using this cleaned dataset for visualizations and trend analysis on tech layoffs.

How to Use

Run the SQL script in a MySQL-compatible database.

Perform additional data checks if needed.

Use the cleaned dataset for exploratory data analysis (EDA) and visualization.
