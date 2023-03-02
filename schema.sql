/* Database schema to keep the structure of entire database. */

-- create table
CREATE TABLE animals (
id BIGSERIAL NOT NULL,
name VARCHAR(100),
date_of_birth DATE,
escape_attempts INT,
neutered BOOLEAN,
weight_kg DECIMAL,
PRIMARY KEY (id));

--Add a column species of type string to your animals table. Modify your schema.sql file.
ALTER TABLE animals
ADD species TEXT;


-- Create a table named owners with the following columns
CREATE TABLE owners(
id BIGSERIAL PRIMARY KEY NOT NULL,
full_name VARCHAR(100) NOT NULL,
age INT NOT NULL
);
-- Create a table named species with the following columns
CREATE TABLE species(
id BIGSERIAL PRIMARY KEY NOT NULL,
name VARCHAR(100) NOT NULL
);

--  qeury to Remove column species
ALTER TABLE animals
DROP COLUMN species ;
SELECT * FROM animals;

-- Modify animals table
ALTER TABLE animals
ADD species_id INT;
ALTER TABLE animals
ADD CONSTRAINT fk_species_animals
FOREIGN KEY(species_id) REFERENCES species(id);
ALTER TABLE animals
ADD owner_id INT;
ALTER TABLE animals
ADD CONSTRAINT fk_owners_animals
FOREIGN KEY(owner_id) REFERENCES owners(id);
SELECT * FROM animals;


-- Create a table named vets with the following columns

CREATE TABLE vets (
id SERIAL PRIMARY KEY NOT NULL,
name VARCHAR(100),
age INT,
date_of_graduation DATE );

--  Create a "join table" called specializations

CREATE TABLE specializations (
species_id INT REFERENCES species (id),
vets_id INT REFERENCES vets (id));


-- Create a "join table" called visits

CREATE TABLE visits(
animals_id INT REFERENCES animals (id),
vets_id INT REFERENCES vets (id),
visit_date DATE );
