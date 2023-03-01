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