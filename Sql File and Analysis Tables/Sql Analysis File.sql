--Metrics  : 

/* 
Basic Data Analysis
1-Most effected Gender 
2-average time to confirm the disease , Hospitalize and isolate 
3-Top MonkeyPox Symptoms
4- top 3 places of MonkeyPox 
5- most used confirmations methods 
   1) is MonkeyPox deadly ? 
1- Total Number of DEATH
2- Percentage of Recoverd Vs Percentage of Deaths 
3- Top Symptoms that causes death 
4- Total Number of Death each country 
   2) How is the Disease increaing each month ? 
1- number of increase of confirmed cases each month 
2-
   3)  Does data prove that monkeypox is caused by homosexuality 
1-Total Number of Male confirmed cases each country 
2-Total Number of Males Homosexual in each country  
3- are they the same ? 
*/
--1) Basic Data analysis
--1- top places that has MonkeyPox : 
SELECT  Country,City,Location,COUNT(*) AS number_of_cases
FROM MonkeyPox..Sheet1 
WHERE Status <> 'discarded' AND (City IS NOT NULL OR Location IS NOT NULL)
GROUP BY Country,City,Location
ORDER BY number_of_cases DESC; 
-- 2- Most affected gender 
SELECT Gender , COUNT(*) Number_of_cases
FROM MonkeyPox..Sheet1 
WHERE Status = 'confirmed' AND Gender IS NOT NULL
GROUP BY Gender
ORDER BY Number_of_cases DESC;
--3 Average confirmation,hospitalisation,isolation time
SELECT AVG(DATEDIFF(Day,Date_onset,Date_confirmation)) AS average_confirmation_time,
AVG(DATEDIFF(Day,Date_confirmation,Date_hospitalisation)) AS average_hospitalisation_time,
AVG(DATEDIFF(Day,Date_confirmation,Date_isolation)) AS average_confirmation_time
FROM MonkeyPox..Sheet1
WHERE Date_onset IS NOT NULL AND Date_confirmation IS NOT NULL AND
Date_hospitalisation IS NOT NULL AND Date_isolation IS NOT NULL;
--4 top MonkeyPox Symptoms : 
SELECT   Status , value AS Symptoms,COUNT(value) as Symptoms_Number
FROM MonkeyPox..Sheet1 
CROSS APPLY STRING_SPLIT(TRIM(Symptoms),',')
WHERE Status <> 'discarded'
GROUP BY Status,value
ORDER BY Symptoms_Number DESC;
--5 TOP  Confirmations Methods 
SELECT Confirmation_method,COUNT(*) AS number_of_cases
FROM MonkeyPox..Sheet1 
WHERE Status='confirmed' AND Confirmation_method IS NOT NULL
GROUP BY Confirmation_method
ORDER BY number_of_cases DESC;
--1) is MonkeyPox Deadly : 
--1- total Number of Deaths 
SELECT Status, Outcome,COUNT(*) AS number
FROM MonkeyPox..Sheet1
WHERE Status <> 'discarded' AND Outcome IS NOT NULL
GROUP BY Status,Outcome 
ORDER BY number; -- we find that suspected ones are the ones that die more , let's check if they get hospitalised 

SELECT [Hospitalised (Y/N/NA)],Status,COUNT(*)
FROM MonkeyPox..Sheet1 
WHERE Status <> 'discarded' 
GROUP BY [Hospitalised (Y/N/NA)],Status
HAVING [Hospitalised (Y/N/NA)] ='Y'; -- only 6 of suspected gets Hospitalised 
--2-Percentage of recovered vs Percentage of Dead  
SELECT   CAST(COUNT(IIF(Outcome='Death',1,NULL))AS FLOAT)/CAST(COUNT(*) AS FLOAT)*100 AS percentage_of_deaths,
CAST(COUNT(IIF(Outcome='Recovered',1,NULL))AS FLOAT)/CAST(COUNT(*) AS FLOAT)*100 AS percentage_of_Recovered
FROM MonkeyPox..Sheet1 
WHERE  Status <> 'discarded' AND Outcome IS NOT NULL


--4-Top Death in each Country 
SELECT Country,COUNT(*) AS number_of_deaths
FROM MonkeyPox..Sheet1 
WHERE Outcome = 'Death'
GROUP BY Country 
ORDER BY number_of_deaths DESC ;
-- 2) 
SELECT DATEPART(month,Date_confirmation) AS 'Month',Count(*) AS number_of_cases
FROM MonkeyPox..Sheet1
WHERE Status = 'confirmed'
GROUP BY DATEPART(month,Date_confirmation)
ORDER BY DATEPART(month,Date_confirmation);

-- 3) does data prove that MonkeyPox is related to homosexuality 
--1) total number of male confirmed cases in each country 
SELECT DISTINCT Gender,COUNT(*) AS number
FROM MonkeyPox..Sheet1
GROUP BY Gender ;
-- we don't have much data about gender , although we can say the following 


SELECT Country ,COUNT(*) AS number_of_cases
FROM MonkeyPox..Sheet1 
WHERE    Status = 'confirmed'
GROUP BY  Country 
ORDER BY number_of_cases DESC; 

