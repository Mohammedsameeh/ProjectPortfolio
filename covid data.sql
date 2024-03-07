select * from Projectportfolio..coviddeaths$
select * from Projectportfolio..covidvaccinations$


select location, date,population,total_cases,(total_cases/population)*100 as deathpercentage
from Projectportfolio..coviddeaths$
where location like '%states%'
order by 1,2


select continent, max(total_deaths) as Totaldeathcount
from Projectportfolio..coviddeaths$
--where location like '%states%'
where continent is not null
group by continent
order by Totaldeathcount desc

---showing the continents with the highest death counts per population

select continent, max(total_deaths) as Totaldeathcount
from Projectportfolio..coviddeaths$
--where location like '%states%'
where continent is not null
group by continent
order by Totaldeathcount desc

select  sum(new_cases) as totalnewcases,Sum(cast(new_deaths as int)) as totalnewdeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 
as deathperentage
from Projectportfolio..coviddeaths$
--where location like '%states%'
where continent is not null

order by 1,2


select dea.continent,dea.location,dea.date,vac.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date)
from Projectportfolio..covidvaccinations$ dea
join Projectportfolio..coviddeaths$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

with popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(select dea.continent,dea.location,dea.date,vac.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date)
as rollingpeoplevaccinated
from Projectportfolio..covidvaccinations$ dea
join Projectportfolio..coviddeaths$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3-- 
)
select* ,(rollingpeoplevaccinated/population)*100
from popvsvac

create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #percentpopulationvaccinated
select dea.continent,dea.location,dea.date,vac.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date)
as rollingpeoplevaccinated
from Projectportfolio..covidvaccinations$ dea
join Projectportfolio..coviddeaths$ vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null--

select* ,(rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated


create view percentageofpopulationvaccinated 
as
select dea.continent,dea.location,dea.date,vac.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date)
as rollingpeoplevaccinated
from Projectportfolio..covidvaccinations$ dea
join Projectportfolio..coviddeaths$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

