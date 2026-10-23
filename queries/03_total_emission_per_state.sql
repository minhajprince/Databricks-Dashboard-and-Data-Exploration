-- Dataset: Total Emission per State (feeds the "Top 10 States" pie chart)
-- Source table: emissions.default.emissions_data (EPA 2023 county-level GHG data)

WITH state_totals AS (
  SELECT
    state_abbr,
    SUM(TRY_CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE)) AS total_emissions_mtons
  FROM emissions.default.emissions_data
  GROUP BY state_abbr
),
with_national_share AS (
  SELECT
    state_abbr,
    total_emissions_mtons,
    100.0 * total_emissions_mtons / SUM(total_emissions_mtons) OVER () AS pct_of_national_total
  FROM state_totals
)
SELECT
  state_abbr,
  total_emissions_mtons,
  pct_of_national_total
FROM with_national_share
QUALIFY ROW_NUMBER() OVER (ORDER BY total_emissions_mtons DESC) <= 10
ORDER BY total_emissions_mtons DESC
