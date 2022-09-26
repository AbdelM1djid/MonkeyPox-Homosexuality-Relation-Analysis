-- View The Data
SELECT * 
FROM MonkeyPox..Sheet1;

-- Checking unique values in each column (change column name ) : 
SELECT DISTINCT Symptoms
FROM MonkeyPox..Sheet1;

-- View the null value in ID column  : 
SELECT * 
FROM MonkeyPox..Sheet1
WHERE ID IS NULL ; 

-- Drop the Null Values
DELETE FROM MonkeyPox..Sheet1 
WHERE ID IS NULL;

-- count number of unique and Null values  : 
SELECT DISTINCT Genomics_Metadata,COUNT(*) AS number_of_uniques
FROM MonkeyPox..Sheet1
GROUP BY Genomics_Metadata
ORDER BY number_of_uniques;


-- we are not going to use all column so we will create a table where we will use only needed column 
-- needed columns : ID , Status , Location , City , Age , Gender , Date_onset , Date Confirmation ,Symptomes ,  Hospitalised , Date_Hospitalised , Isolated, Outcome 
-- Travel_history_country , contact location , confirmation method , source , date_death

ALTER TABLE MonkeyPox..Sheet1 
DROP COLUMN Country_ISO3,Contact_comment,Contact_ID,Travel_history_entry,
Travel_history_start,Source_II,Source_III,Source_IV,Source_V,Source_VI,Source_VII,Date_entry,Date_last_modified; 


SELECT DISTINCT Status,COUNT(*) AS Number_of_Cases
FROM MonkeyPox..Sheet1
GROUP BY Status
ORDER BY Number_of_Cases DESC;
--Status has omit_error values let's invsestigate these to decide how we want to handle them : 
SELECT * 
FROM MonkeyPox..Sheet1
WHERE Status = 'omit_error';
-- we want to fill it with confirmed if we find a confirmation date , first let's check if every confirmed case has a confirmation date 
SELECT * 
FROM MonkeyPox..Sheet1 
WHERE Status = 'confirmed' AND Date_confirmation IS NULL; -- we should get no rows if every 'confirmed' has a date of confirmation 

--correct we have no values 
UPDATE MonkeyPox..Sheet1
set Status = REPLACE(Status,'omit_error','confirmed')
WHERE Date_confirmation IS NOT NULL;

--only 4 'omit_error' values left let's check them 
SELECT * 
FROM MonkeyPox..Sheet1
WHERE Status = 'omit_error'; -- they are no useful let's drop them 

DELETE FROM MonkeyPox..Sheet1
WHERE Status = 'omit_error';

--change date columns into date type 
ALTER TABLE MonkeyPox..Sheet1 
ALTER COLUMN Date_onset Date;

ALTER TABLE MonkeyPox..Sheet1 
ALTER COLUMN Date_confirmation Date;

ALTER TABLE MonkeyPox..Sheet1 
ALTER COLUMN Date_hospitalisation Date;

ALTER TABLE MonkeyPox..Sheet1 
ALTER COLUMN Date_isolation Date;
/*
ALTER TABLE MonkeyPox..Sheet1 
ALTER COLUMN Date_death INT; 
*/ -- changing to in chunk of code 
ALTER TABLE MonkeyPox..Sheet1 
ALTER COLUMN Date_death SMALLDATETIME; -- we got an error here , let's check that out 
--appearently the date values are written in base format TO CONVERT THAT we change column type to int then to smalldatetime , because we cant convert 
--directly from string 
-- then we change to date format once again : 
ALTER TABLE MonkeyPox..Sheet1 
ALTER COLUMN Date_death DATE;


-- Checking for Duplicates Values  : 
SELECT ID , COUNT(ID) 
FROM MonkeyPox..Sheet1 
GROUP BY ID
HAVING COUNT(ID) > 1; --no Duplicate Values

-- we saw that the age is not in a consistent format , let's count number of unique values 
SELECT DISTINCT Age,COUNT(*) AS Number_of_Cases
FROM MonkeyPox..Sheet1
GROUP BY Age
ORDER BY Number_of_Cases DESC;
-- we see that the ranges are huge for us to make a category analysis so we leave that for another dataset 
--- length of strings in Symptomes column 
SELECT DISTINCT Symptoms , MAX(LEN(Symptoms)) AS length_
FROM MonkeyPox..Sheet1
GROUP BY Symptoms
ORDER BY length_; 

-- values are comma seperated 



