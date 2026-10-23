# 🌍 US Emissions Dashboard on Databricks

**A Databricks AI/BI dashboard, built with SQL and explored with the AI assistant Genie, that turns 3,142 US county records into clear answers about where greenhouse gas emissions come from.**

## Dashboard Preview

![Emissions Dashboard](Emission%20Dashboard.PNG)

![Dashboard Datasets](Dashboard%20datasets.png)

![Emission Data](Emission%20data.PNG)

## Project Overview

This project analyses 2023 county-level greenhouse gas (GHG) data for the United States, collected by the EPA (Environmental Protection Agency). Each row is one county, with its population, employment, energy use, and total emissions.

I loaded the data into Databricks, explored it with **Genie** (Databricks' AI assistant, where you ask questions in plain English), wrote the final SQL by hand, and built a dashboard on top of it.

The dashboard helps anyone quickly answer questions like:

- Where in the US are emissions concentrated?
- Which states and counties emit the most?
- Do bigger populations mean more emissions per person?

## Key Insights

Based on **3,142 counties across 50 states + DC** (2023 EPA data):

| Metric | Result |
|---|---|
| Total emissions | **562.5 million mtons CO₂e** |
| Total population covered | **318.6 million people** |
| Average emissions per person | **about 1.77 mtons CO₂e** |
| Top state | **Texas**, 59.0M mtons (10.5% of national total) |
| Next highest states | **Florida** 47.1M (8.4%), **Ohio** 27.8M (4.9%) |
| Top 10 states combined | **about 51%** of all US emissions |
| Top county | **Maricopa County, AZ** (9.81M mtons), then Harris County, TX (9.68M) and Cook County, IL (8.11M) |
| Highest emissions per person | **Thayer County, NE** (about 5.9 mtons per person) |

**What the data says, in simple words**

- **Emissions are concentrated.** Just 10 of 51 states produce about half of the national total.
- **Big total does not mean big per-person.** Los Angeles County has the largest population (10.1M) but ranks only 6th in total emissions. The highest per-person counties are tiny rural counties (Thayer County, NE has about 5,200 people).
- **Population and per-person emissions move in opposite directions, but weakly.** The correlation is about -0.30, so "more people, less emissions per person" is a loose trend, not a rule.

> Note: On the pie chart, each slice shows its share of the **top 10 states only** (for example, Texas = 20.6% of the top 10), not of the national total. Texas is 10.5% of the whole country.

## From Data to Dashboard

The dataset is loaded as one table in Databricks Unity Catalog: `emissions.default.emissions_data`.

| Item | What it holds |
|---|---|
| Rows | 3,142 counties (one row per county) |
| Location | State, county name, latitude, longitude |
| People | Population, employment, climate zone |
| Energy | Electricity, natural gas, and fuel use, with spending |
| Transport | Vehicle miles traveled, total and per person |
| Target column | `GHG emissions mtons CO2e` (total emissions per county) |

**How the data was prepared**

- The CSV was uploaded to Databricks and saved as the `emissions_data` table.
- The emissions column came in as text with commas (for example `"315,398"`), so every query cleans it first:

  ```sql
  TRY_CAST(REPLACE(`GHG emissions mtons CO2e`, ',', '') AS DOUBLE)
  ```

- Emissions per person is calculated with `NULLIF(population, 0)` so a zero population can never cause a divide-by-zero error.
- The state share of the national total uses a window function: `SUM(...) OVER ()`.

### Data Exploration with Genie

Before building charts, I used **Genie** to understand the table. Databricks suggests starter questions on the table's *Sample Data* tab, and I used questions like these:

- Which counties have the highest GHG emissions per capita?
- Are there counties with missing population or employment data?
- How does energy consumption correlate with employment levels?

Genie gave me a fast first look at the columns and gaps. I then wrote and checked the final SQL myself (see the `queries` folder) so each dashboard number is reproducible.

## Dashboard Features

| Chart | Type | What it shows |
|---|---|---|
| **Emissions of United States** | Symbol map | Every county plotted by latitude and longitude, so you can see emission hotspots |
| **Emissions per Person vs Population** | Scatter plot | Each dot is a county; shows that higher-population counties tend to have lower emissions per person |
| **Top 10 States** | Donut chart | The 10 highest-emitting states, which together make up about 51% of the US total |
| **Total Emission by mTon CO₂e** | Horizontal bar chart | The 10 highest-emitting counties, with compact labels like `9.81M` |

The dashboard also has a **Data** tab with four datasets, one per chart, each backed by a SQL query.

## SQL Queries

| File | Feeds chart | Key idea |
|---|---|---|
| `01_global_emissions_by_location.sql` | Symbol map | Latitude, longitude, and emissions per county |
| `02_emissions_per_person.sql` | Scatter plot | Emissions divided by population, sorted high to low |
| `03_total_emission_per_state.sql` | Donut chart | CTEs plus window function for each state's share, `QUALIFY` for the top 10 |
| `04_county_emissions.sql` | Bar chart | Top 10 counties by total emissions |

## Files Included

| File | Description |
|---|---|
| `Emissions Dashboard.lvdash.json` | Exported Databricks dashboard (datasets, charts, layout) |
| `Emissions_Data_2023.csv` | Source data: 3,142 counties, 58 columns |
| `data/emissions_data.csv` | Smaller copy of the data with 29 columns |
| `queries/` | The four SQL files behind the dashboard |
| `Emission Dashboard.PNG` | Final dashboard preview |
| `Dashboard datasets.png` | Dashboard Data tab with SQL datasets |
| `Emission data.PNG` | Source table in the Databricks Catalog |
| `README.md` | Project information |

## How to Reproduce

1. Create a free [Databricks account](https://www.databricks.com/learn/free-edition) and start a SQL warehouse.
2. Upload `Emissions_Data_2023.csv` and create the table `emissions.default.emissions_data` (catalog `emissions`, schema `default`).
3. Go to **Dashboards**, then import `Emissions Dashboard.lvdash.json`.
4. Open the **Data** tab to see the four datasets, or run the SQL from the `queries` folder in the SQL Editor.
5. Check the **Untitled page** tab to see the finished charts.

## Tools and Skills

- Databricks (Free Edition, Serverless SQL Warehouse)
- Unity Catalog and Catalog Explorer
- Databricks SQL and AI/BI Dashboards
- Genie (AI-assisted data exploration)
- SQL: CTEs, window functions, `QUALIFY`, `TRY_CAST`, `NULLIF`
- Data cleaning and data storytelling

## Data Source

US Environmental Protection Agency (EPA), county-level greenhouse gas emissions data, 2023.

## Author

**Minhaj Khan**
Data Analyst | SQL · Power BI · Excel

[LinkedIn](https://www.linkedin.com/in/minhaj-khan/) · [Portfolio](https://github.com/minhajprince)
