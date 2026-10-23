-- Dataset: Emissions per Person (feeds the "Emissions per Person Vs Population" scatter)
-- Source table: emissions.default.emissions_data (EPA 2023 county-level GHG data)

SELECT
  county_state_name,
  TRY_CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE) AS total_emissions_mtons,
  population,
  TRY_CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE) / NULLIF(population, 0) AS emissions_per_person
FROM emissions.default.emissions_data
ORDER BY emissions_per_person DESC
