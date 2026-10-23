-- Dataset: Global Carbon Emissions by Location (feeds the "Emissions of United States" symbol map)
-- Source table: emissions.default.emissions_data (EPA 2023 county-level GHG data)

SELECT
  latitude,
  longitude,
  `GHG emissions mtons CO2e` AS Emissions
FROM emissions.default.emissions_data
