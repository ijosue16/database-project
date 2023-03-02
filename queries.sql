/*Queries that provide answers to the questions from all projects.*/


-- Query for Find all animals whose name ends in "mon".
SELECT * FROM animals WHERE name LIKE '%mon';

-- Query for List the name of all animals born between 2016 and 2019.
SELECT name FROM animals
WHERE date_of_birth BETWEEN '2016-1-1'AND '2019-12-31';

-- Query for List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name FROM animals
WHERE neutered = true  AND escape_attempts < 3;

-- Query for List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals
WHERE name = 'Agumon' OR name ='Pikachu' ;

-- Query for List name and escape attempts of animals that weigh more than 10.5kg
SELECT name,escape_attempts FROM animals
WHERE weight_kg > 10.5 ;


-- Query for Find all animals that are neutered.
SELECT * FROM animals
WHERE neutered = true ;

-- Query for Find all animals not named Gabumon.
SELECT * FROM animals
WHERE name <> 'Gabumon' ;

-- Query for Find all animals with a weight between 10.4kg and 17.3kg
SELECT * FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- Query to make a transaction to update species column and roll back
BEGIN;
UPDATE animals
SET species='unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

--Query for transaction to set species ->digimon to animals ending in mon and species->pokemon to animals with no species
BEGIN;
UPDATE animals
SET species ='digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species ='pokemon'
WHERE species IS NULL;
SELECT * FROM animals
COMMIT;

--Query for transaction to delete all data and rollback
BEGIN;
DELETE FROM animals;
SELECT * FROM animals
ROLLBACK;
SELECT * FROM animals;

--Query for transacton to delete animals with dob> 2022 making savepoint and update weight of animal with negative weight
BEGIN;
DELETE FROM animals
WHERE date_of_birth >'2022-01-01';
SAVEPOINT born_before;
UPDATE animals
SET weight_kg = weight_kg * (-1);
ROLLBACK TO born_before;
UPDATE animals
SET weight_kg = weight_kg * (-1)
WHERE weight_kg < 0;
SELECT * FROM animals;
COMMIT;

-- Query to find How many animals are there
SELECT COUNT (id)
FROM animals;

-- Query to find How many animals have never tried to escape
SELECT COUNT (id)
FROM animals
WHERE escape_attempts < 1;

-- Query to find What is the average weight of animals
SELECT AVG (weight_kg)
FROM animals;

-- Query to find Who escapes the most, neutered or not neutered animals
SELECT max(escape_attempts) as escape_attempts,neutered
FROM animals
WHERE neutered= true or neutered= false
GROUP BY DISTINCT neutered;

-- Query to find  is the minimum and maximum weight of each type of animal
SELECT species,MAX(weight_kg) AS maximum_weight,MIN(weight_kg) AS manimum_weight
FROM animals
GROUP BY species

-- Query to find What is the average number of escape attempts per animal type of those born between 1990 and 2000
SELECT species,AVG(escape_attempts) AS average_escape_attempts_number
FROM animals
WHERE date_of_birth BETWEEN'1990-01-01' AND'2000-12-31'
GROUP BY species

-- Query to find What animals belong to Melody Pond?
SELECT * FROM animals
JOIN owners ON animals.owner_id= owners.id
WHERE owners.full_name='Melody Pond';

-- Query to List of all animals that are pokemon (their type is Pokemon).
SELECT * FROM animals
JOIN species ON animals.species_id= species.id
WHERE species.name='Pokemon';

-- Query to List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name,animals.name
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id;

-- Query to find How many animals are there per species
SELECT species.name,COUNT (animals.name)
FROM species
LEFT JOIN animals ON species.id = animals.species_id 
GROUP BY species.name;

-- Query to List all Digimon owned by Jennifer Orwell.
SELECT species.name,animals.name,owners.full_name
FROM animals
JOIN owners ON animals.owner_id  = owners.id
JOIN species ON animals.species_id  = species.id
WHERE owners.full_name = 'Jennifer Orwell'AND species.name = 'Digimon';
-- Query to List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name,owners.full_name
FROM animals
JOIN owners ON animals.owner_id  = owners.id
WHERE owners.full_name='Dean Winchester' AND animals.escape_attempts < 1;

--Query to find Who owns the most animals
SELECT COUNT(animals.owner_id),owners.full_name
FROM animals
JOIN owners ON animals.owner_id  = owners.id
GROUP BY owners.full_name
HAVING COUNT(animals.owner_id)>2;
Query to find Who was the last animal seen by William Tatcher

-- Query to find Who was the last animal seen by William Tatcher
SELECT animals.name,vets.name,visits.visit_date
FROM animals
JOIN visits ON animals.id=visits.animals_id
JOIN vets ON visits.vets_id= vets.id
WHERE vets.name LIKE '%William Tatcher%'
ORDER BY visits.visit_date DESC LIMIT 1

-- Query to find How many different animals did Stephanie Mendez see
SELECT COUNT(animals.name),vets.name
FROM animals
JOIN visits ON animals.id=visits.animals_id
JOIN vets ON visits.vets_id= vets.id
WHERE vets.name LIKE 'Stephanie Mendez'
GROUP BY vets.name;

-- Query to find List all vets and their specialties, including vets with no specialties
SELECT vets.name AS vet_name,species.name AS species_name
FROM vets
LEFT JOIN specializations ON vets.id = specializations.vets_id
LEFT JOIN species ON species.id = specializations.species_id
-- Query to find List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name AS animalS_name,vets.name AS vets_name,visits.visit_date
FROM animals
JOIN visits ON visits.animals_id = animals.id
JOIN vets ON vets.id = visits.vets_id
WHERE vets.name LIKE 'Stephanie Mendez' AND
visits.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- Query to find What animal has the most visits to vets
SELECT animals.name AS animals_name,COUNT(*)
FROM animals
JOIN visits ON visits.animals_id = animals.id
GROUP BY animals.name
ORDER BY COUNT DESC LIMIT 1;
-- Query to find Who was Maisy Smith's first visit
SELECT animals.name,vets.name,visits.visit_date
FROM animals
JOIN visits ON animals.id=visits.animals_id
JOIN vets ON visits.vets_id= vets.id
WHERE vets.name LIKE '%Maisy Smith%'
ORDER BY visits.visit_date ASC LIMIT 1;

-- Query to find Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name,vets.name,visits.visit_date
FROM animals
JOIN visits ON animals.id=visits.animals_id
JOIN vets ON visits.vets_id= vets.id
ORDER BY visits.visit_date DESC LIMIT 1
-- Query to find How many visits were with a vet that did not specialize in that animal's species
SELECT COUNT(*)
FROM vets
JOIN visits ON visits.vets_id = vets.id
JOIN specializations ON specializations.vets_id = vets.id
JOIN animals ON visits.animals_id = animals.id
WHERE NOT specializations.vets_id = animals.species_id
-- Query to find What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT vets.name, COUNT (species.name),species.name FROM vets
JOIN visits ON visits.vets_id = vets.id 
JOIN animals ON visits.animals_id = animals.id 
JOIN species ON animals.species_id = species.id 
WHERE vets.name LIKE 'Maisy Smith'
GROUP BY species.name, vets.name 
ORDER BY COUNT DESC LIMIT 1;