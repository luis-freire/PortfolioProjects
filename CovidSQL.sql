Select *
From PortfolioProjects..CovidDeathsV2$
Order By 3,4

--Select data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjects..CovidDeathsV2$
Order By 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the liklihood of dying if you contract Covid in your Country

Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From PortfolioProjects..CovidDeathsV2$
Where location like '%states%'
Order By 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

Select Location, population, MAX(total_cases) as HighestInfectedCount, MAX(total_cases/population) *100 as PercentPopulationInfected
From PortfolioProjects..CovidDeathsV2$
Group By location, population
Order By PercentPopulationInfected desc


-- Looking at Total Population vs Vaccinations
--Including CTE (With fucntion)

With PopvsVac (continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition By dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeathsV2$ dea
Join PortfolioProjects..CovidVac$ vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order  by 2,3
)
Select*, (RollingPeopleVaccinated/population)*100 as PopulationVaccinated
From PopvsVac

-- CTE we used
With PopvsVac (continent, location, date, population, RollingPeopleVaccinated)
as
(
)



-- TEMP TABLE

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition By dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeathsV2$ dea
Join PortfolioProjects..CovidVac$ vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order  by 2,3
Select*, (RollingPeopleVaccinated/population)*100 as PopulationVaccinated
From #PercentPopulationVaccinated

-- If error occurs: There is already an object named '#PercentPopluationVaccinated' in database,
-- Add function "Drop table if exists (#PercentPopulationVaccinated)"

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert Into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition By dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeathsV2$ dea
Join PortfolioProjects..CovidVac$ vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order  by 2,3
Select*, (RollingPeopleVaccinated/population)*100 as PopulationVaccinated
From #PercentPopulationVaccinated



-- Creating View to store data for later visulizations
Use PortfolioProjects
Go
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition By dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100
From PortfolioProjects..CovidDeathsV2$ dea
Join PortfolioProjects..CovidVac$ vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order  by 2,3

Select *
From PercentPopulationVaccinated
