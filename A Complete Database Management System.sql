/* create a new  table  cancer_patients_Record as part of the import process */
CREATE TABLE  Global_Cancer_Patients_Record(
    Patient_ID VARCHAR(20),
    Age INT,
    Gender VARCHAR(10),
    Country VARCHAR(100),
    Year INT,
    Genetic_Risk FLOAT,
    Air_Pollution FLOAT,
    Alcohol_Use FLOAT,
    Smoking FLOAT,
    Obesity_Level FLOAT,
    Cancer_Type VARCHAR(100),
    Cancer_Stage VARCHAR(20),
    Treatment_Cost_USD FLOAT,
    Survival_Years FLOAT,
    Target_Severity_Score FLOAT
);

select * from global_Cancer_Patients_Record;

/* Create table PatientDetails */
create  table PatientDetails (
	Patient_ID VARCHAR(20) primary key not null,
    Age INT,
    Gender VARCHAR(10),
    Country VARCHAR(100),
    Year INT);

INSERT into  PatientDetails 
select Patient_ID, Age, Gender, Country , year from global_Cancer_Patients_Record;

SELECT * FROM PatientDetails;

/*Create table Countries */
CREATE TABLE Countries (
    Country_ID INT AUTO_INCREMENT PRIMARY KEY,
    Country_Name VARCHAR(50) UNIQUE
);

insert into Countries ( Country_Name)
select  distinct  country from global_Cancer_Patients_Record;

select * from Countries;

/* ADD COLUMN COUNTRY_ID INTO global_Cancer_Patients_Record and update it*/
 Alter table global_Cancer_Patients_Record
 add Country_ID INT NOT NULL;

SET SQL_SAFE_UPDATES = 0;
Update global_Cancer_Patients_Record cp
join Countries c
on cp.Country = c.Country_Name
set cp.Country_ID = C.Country_ID;
SET SQL_SAFE_UPDATES = 1;
 
/*Add a foreign key to table global_Cancer_Patients_Record  */
 Alter table global_Cancer_Patients_Record
 ADD constraint FK_CancerPatient_Country
  FOREIGN KEY (Country_ID) REFERENCES Countries(Country_ID);

/* drop column country*/
alter table global_Cancer_Patients_Record
drop column Country;
select * from global_Cancer_Patients_Record;

/* Create table Cancer_Types using constraint unique & identity*/
Create  table Cancer_Types (
CancerType_ID int PRIMARY KEY auto_increment,
Cancer_Type varchar(50) not null unique);

insert into Cancer_Types(Cancer_type)
select  distinct Cancer_Type from global_Cancer_Patients_Record;

SELECT * FROM Cancer_Types;
SELECT * FROM Global_Cancer_Patients_Record;

/* add a column CancerType_ID into global_Cancer_Patients_Record and insert values into it add drop COLUMN Cancer_Type*/
alter table global_Cancer_Patients_Record
add CancerType_ID int;

SET SQL_SAFE_UPDATES = 0;
Update global_Cancer_Patients_Record cp
join Cancer_Types ct
on cp.Cancer_Type = ct.Cancer_Type
set cp.CancerType_ID = ct.CancerType_ID;

SELECT * FROM Global_Cancer_Patients_Record;

alter table global_Cancer_Patients_Record
drop column Cancer_Type;

/* add a foreign key constraint */
alter table global_Cancer_Patients_Record
add constraint FK_Cancer_Type
foreign key(CancerType_ID) references Cancer_Types (CancerType_ID);
 
 /* create table  Cancer_Stages */
create table Cancer_Stages (
CancerStage_ID INT PRIMARY KEY auto_increment,
Cancer_Stage varchar(20) );

insert into Cancer_Stages(Cancer_Stage)
select  distinct cancer_stage from  global_Cancer_Patients_Record;

SELECT * from Cancer_stages;
SELECT * FROM Global_Cancer_Patients_Record;

/* add a column CancerStage_ID into global_Cancer_Patients_Record and insert values into it add drop COLUMN Cancer_stage*/
alter table global_Cancer_Patients_Record
add COLUMN CancerStage_ID INT;

SET SQL_SAFE_UPDATES = 0;
UPDATE  global_Cancer_Patients_Record CP
JOIN Cancer_stages cs
on CS.Cancer_Stage=cp.Cancer_Stage
SET CP. CancerStage_ID=cS.CancerStage_ID;

alter table global_Cancer_Patients_Record
DROP COLUMN Cancer_stage;

/* create table Diagnosis with constraint */
CREATE  TABLE Diagnosis (
    Patient_ID VARCHAR(50) NOT NULL,
    Year INT NOT NULL CHECK (Year BETWEEN 1900 AND 2025),
    CancerType_ID INT NOT NULL,
    CancerStage_ID INT NOT NULL,
    Treatment_Cost_USD FLOAT,
    Survival_Years FLOAT,
    Target_Severity_Score FLOAT CHECK (Target_Severity_Score >= 0),
    FOREIGN KEY (CancerType_ID) REFERENCES Cancer_Types(CancerType_ID),
    FOREIGN KEY (CancerStage_ID) REFERENCES Cancer_Stages(CancerStage_ID)
	);
    
insert into Diagnosis
select Patient_ID, Year, CancerType_ID, CancerStage_ID, Treatment_Cost_USD, Survival_Years, Target_Severity_Score
from global_Cancer_Patients_Record;
    
SELECT * FROM Diagnosis;
SELECT * from Global_Cancer_Patients_Record;  

/*create a table of all risk factors contributing to cancer */ 
create TABLE  Risk_Factors (
RiskFactor_ID INT primary key auto_increment,
RiskFactor_Name varchar(50) not null unique);

insert into Risk_Factors (RiskFactor_Name)
values
('Genetic_Risk'),
('Air_Pollution'),
('Alcohol_Use'),
('Smoking'),
('Obesity_Level');

SELECT * FROM Risk_Factors;

/* create table Patient_Risk */
CREATE TABLE Patient_Risk (
Patient_Id varchar(20) not null primary key,
Age int not null,
Gender varchar(10) ,
Genetic_Risk Float,
Air_Polution float,
Alcohol_Use float,
Smoking float,
Obesity_Level float);

Insert into Patient_Risk
select Patient_ID,Age , Gender, Genetic_Risk, Air_Pollution,Alcohol_Use, Smoking, Obesity_Level
FROM Global_Cancer_patients_Record;

SELECT * FROM Patient_Risk;

/* find the max and min of every risk_factor*/
SELECT MAX(Genetic_Risk) AS Max_Genetic_Risk,
MIN(Genetic_Risk) AS Min_Genetic_Risk
FROM Patient_Risk;
 
SELECT MAX(Air_Polution) AS Max_Air_Polution,
MIN(Air_Polution) AS Min_Air_Polution
FROM Patient_Risk;

 SELECT MAX(Alcohol_Use) AS Max_Alcohol_Use,
MIN(Alcohol_Use) AS Min_Alcohol_USE
FROM Patient_Risk;

 SELECT MAX(Smoking) AS Max_Smoking,
MIN(Smoking) AS Min_Smoking
FROM Patient_Risk;

 SELECT MAX(Obesity_Level) AS Max_Obesity_Level,
MIN(Obesity_Level) AS Min_Obesity_Level
FROM Patient_Risk;

 SELECT MAX(Genetic_Risk) AS Max_Genetic_Risk,
MIN(Genetic_Risk) AS Min_Genetic_Risk
FROM Patient_Risk;

/* create a view to get patient_risk_Gategory*/
CREATE VIEW vWPatient_Risk_Gategory as
SELECT 
Patient_ID,
Age,
Gender,
CASE 
          WHEN Genetic_Risk >= 0 and Genetic_risk <= 3 then 'LOW'
		  WHEN Genetic_Risk >= 3 and Genetic_risk <= 6 then 'Moderate'
		  WHEN Genetic_Risk >= 6 and Genetic_risk <= 9.9 then 'High'
		  else 'unknown'
end as Genetic_Risk,

CASE 
          WHEN Air_Polution >= 0 and Air_Polution <= 3 then 'LOW'
		  WHEN Air_Polution >= 3 and Air_Polution <= 6 then 'Moderate'
		  WHEN Air_Polution >= 6 and Air_Polution <= 9.9 then 'High'
		  else 'unknown'
end as Air_polution,

CASE 
          WHEN Alcohol_Use >= 0 and Alcohol_Use <= 3 then 'LOW'
		  WHEN Alcohol_Use >= 3 and Alcohol_Use <= 6 then 'Moderate'
		  WHEN Alcohol_Use >= 6 and Alcohol_Use <= 9.9 then 'High'
		  else 'unknown'
end as Alcohol_Use,

CASE 
          WHEN Smoking >= 0 and Smoking <= 3 then 'LOW'
		  WHEN Smoking >= 3 and Smoking <= 6 then 'Moderate'
		  WHEN Smoking >= 6 and Smoking <= 9.9 then 'High'
		  else 'unknown'
end as Smoking,

CASE 
          WHEN Obesity_Level >= 0 and Obesity_Level <= 3 then 'Normal'
		  WHEN Obesity_Level >= 3 and Obesity_Level <= 6 then 'Overweight'
		  WHEN Obesity_Level >= 6 and Obesity_Level <= 9.9 then 'Obese'
		  else 'unknown'
end as Obesity_Level
from Patient_Risk;
/* execute the view*/
select * from vWPatient_Risk_Gategory;
  