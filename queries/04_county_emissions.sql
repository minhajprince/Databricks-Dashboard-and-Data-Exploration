-- Dataset: County Emissions (feeds the "Total Emission by mTon CO2 e" bar chart)
-- Source table: emissions.default.emissions_data (EPA 2023 county-level GHG data)

SELECT
  county_state_name,
  population,
  TRY_CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE) AS total_emissions_mtons
FROM emissions.default.emissions_data
ORDER BY total_emissions_mtons DESC
LIMIT 10
