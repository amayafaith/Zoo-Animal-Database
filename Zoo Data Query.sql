--Project 2 ITM 500 W24 by Amaya Shields 501216036

--1. Show for each zoo the number of different species represented by its captive animals. 

select zoo, count(distinct Species) 'NoSpecies'
from Animal
group by zoo;

--2. List the zoo name, employee name and salary of each employee that is a world’s best expert in a species. Sequence the output by employee name within zoo name.

select zoo, empname employee_name, salary
from Species join Employee on Species.WorldBestExpertEmpNo=Employee.EmpNo
where WorldBestExpertEmpNo is not null
order by zoo, empname;

--3. List the detail of animals that are in captivity in any zoo and whose mother is currently in the "Garden Zoo" in Boston.

select animal.*
from Animal
where MotherAnimalID in (select animalid 
	from Animal join zoo on animal.zoo=zoo.zooname 
	where zoo='garden zoo' and city='boston');

--4. Show for each zoo in Canada a count of captive animals.  Sequence the output by highest to lowest count.

select zoo, count(*) 'NoCaptiveAnimals'
from Animal join zoo on animal.zoo=zoo.zooname 
where country='canada'
group by zoo
order by count(*) desc;

--5. Show for each species a count of the experts that are employed by any zoos in the USA.

select Speciesname, count( SpeciesExpertise) NoExperts
from zoo join Employee on Zoo.ZooName=Employee.Zoo join Species on Employee.SpeciesExpertise=Species.SpeciesName
where Country='USA'
group by SpeciesName;

--6. List the details for employees in any zoo in Canada that have either a salary of at least 75000 or are an expert in the Tiger species. Sequence the output by employee name.

select *
from Employee
where (Salary>=75000 or SpeciesExpertise='tiger') and zoo in (select zooname from zoo where country='canada')
order by empname;

--7. List the details for all animals born in 2016 that belong to an endangered species (status = E). 

select animal.* 
from Animal
where  year(DateOfBirth)=2016 and Species in (select speciesname from Species where Status='E');

--8. List the details for the zoos in China that have more than 2 animals that belong to the Panda species.

select distinct zoo.* 
from zoo join Animal on zoo.ZooName=Animal.Zoo
where country='china' and zoo in
	(select Zoo 
	from Animal 
	where Species='panda' 
	group by zoo 
	having count(Species)>2);

--9. List the names, gender and salaries of all male employees that are the world’s best expert for a threatened species (status = T).

select EmpName, gender, salary 
from Employee
where Gender='M' and empno in (select WorldBestExpertEmpNo from Species where status='T' and WorldBestExpertEmpNo is not null);

--10. List the details of the zoo that has the employee with the highest salary in any zoo.

select Zoo.* 
from zoo join Employee on Zoo.ZooName=Employee.Zoo
where Salary in (select max(Salary) 
				from Employee );

--11. List the details for any species for which there animals held in any zoo in China.

select distinct species.*
from zoo join Animal on zoo.ZooName=Animal.Zoo join Species on Animal.Species=Species.SpeciesName
where country='china';

--12. List the details for the zoos that have animals belonging to more than 3 different species. Sequence the output alphabetically by zoo within city.

select *
from zoo 
where ZooName in (select zoo
	from animal 
	group by zoo
	having count(distinct Species)>3)
order by city,ZooName;

 --13. List details for the animals that have a mother that is in a zoo that is different from their child's current zoo.

select child.*
from Animal child join Animal mom on child.MotherAnimalID = mom.AnimalId
where not mom.Zoo = child.zoo;

--14. Show the name of any country that has the more than 2 zoos.

select country
from zoo
group by Country
having count(*)>2;

--15. List the species details for the species that have a world’s best expert working in a zoo 
--that also has animals of that same species. Show each species only once.

select distinct Species.*
from employee join species on Employee.EmpNo= Species.WorldBestExpertEmpNo join animal on species.SpeciesName=Animal.Species
where Animal.zoo=Employee.zoo ;

--16. List the details for the employee that has the lowest salary for an expert in the Tiger species.

select *
from Employee
where salary in (select min(Salary) from Employee where SpeciesExpertise='tiger');

--16 answer 
select *
from Employee
where SpeciesExpertise='tiger' and salary in (select min(Salary) from Employee where SpeciesExpertise='tiger');

--17. List the details for any endangered species for which there are more than 2 individual animals in total in Canadian zoos.

select distinct Species.*
from Species join animal on Species.SpeciesName= Animal.Species
where status='e'and species in (select Species
	from zoo join Animal on zoo.ZooName=Animal.Zoo
	where country='canada'
	group by Species
	having count(*)>2);

 --18. List the details of any zoo that has more than 2 Lions born in 2016.

 select zoo.*
 from zoo
 where ZooName in (select Zoo
 from animal
 where year(DateOfBirth)=2016 and Species='lion'
 group by Zoo
 having count(*)>2);

 --19. Show the count of how many species experts are employed at the "Metro Zoo" in Toronto.

 select count(SpeciesExpertise) SpeciesExperts
 from zoo join Employee on Zoo.ZooName=Employee.Zoo
 where zoo='metro zoo' and city='toronto';

 --20 List the details of mothers that have more than 2 offspring in total in all Canadian zoos. 

select * 
from animal
where animalid in 
(select child.MotherAnimalID
from Animal child join Animal mom on child.MotherAnimalID = mom.AnimalId 
where child.Zoo in (select ZooName from zoo where Country='canada')
group by child.MotherAnimalID
having count(*)>2);