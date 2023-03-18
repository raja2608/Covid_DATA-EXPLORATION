--COVID-19 OUTBREAK [DATA EXPLORATION]

-- The data has last been refreshed dated 14/03/2023 and it is downloaded from https://ourworldindata.org/covid-deaths

--The excel files [dbo].[covid_deaths$] & [dbo].[covid_vaccinations$]  were imported using the ssms import and export tool 


-- ANALYSIS OF [dbo].[covid_deaths$]

--Worldwide infection rate date wise 

Select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,(sum(cast(new_deaths as int))/Sum(new_cases))*100 as '%iNFECTED'
from [Dataexploration_project].[dbo].[covid_deaths$]
where continent is not null 
having sum(new_cases)>=1
order by sum(new_cases)

--DEATH Percentage in  india 

Select location,DATE,population,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from [Dataexploration_project].[dbo].[covid_deaths$]
where location='india' and total_deaths>=1
order by date

--% population IN INDIA infected by covid 

Select date,population,total_cases,(total_cases/population)*100 as '%_infected'
from [Dataexploration_project].[dbo].[covid_deaths$]
where location='india' and total_cases>=1
order by '%_infected'

--Highest infection rate 
Select Location as COUNTRY,POPULATION,max(total_cases) as 'Max_Total_Cases',max((total_cases/population))*100 as '%_Infected'
from [Dataexploration_project].[dbo].[covid_deaths$]
group by location,population
order by '%_infected' desc

-- Infection Rate in India

Select Location as COUNTRY,POPULATION,max(total_cases) as 'Max_Total_Cases',max((total_cases/population))*100 as '%_Infected'
from [Dataexploration_project].[dbo].[covid_deaths$]
where location='india'
group by location,population
order by '%_infected' desc


--infection rate by continent


SELECT c.continent, SUM(p.population) as total_population,((sum(p.total_cases))/(SUM(p.population)))*100 as infection_rate
 from Dataexploration_project.dbo.covid_deaths$ p
JOIN (SELECT DISTINCT location, continent 
from Dataexploration_project.dbo.covid_deaths$
where continent is not null) c
ON p.location = c.location
GROUP BY c.continent
order by infection_rate desc

--ANALYSIS OF [dbo].[covid_vaccinations$]

--TOTAL VACCINATIONS BY POPULATION

SELECT DEA.continent,DEA.location,DEA.date,DEA.population,VACC.total_vaccinations
from Dataexploration_project.dbo.covid_deaths$ DEA
JOIN Dataexploration_project.dbo.covid_vaccinations$ VACC
on DEA.location=VACC.location
AND  DEA.date=VACC.date
WHERE DEA.continent IS NOT NULL
ORDER BY DEA.continent,DEA.location
