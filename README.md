# COVID-19 Data Analysis

End-to-end data analytics pipeline exploring global COVID-19 trends, mortality patterns, and the impact of vaccination rollout across 200+ countries using 85,000+ records.



## Key Findings

- **Vaccination rollout correlates with mortality decline** in the US (r = -0.90) and Germany (r = -0.87) — as vaccination rates increased, death rates declined significantly
- **India and Brazil show positive correlation** (r = +0.92, +0.74) — Delta variant surge coincided with vaccine rollout, illustrating that correlation does not imply causation
- **Europe leads in total deaths** by continent, followed by North America and South America



## Tableau Dashboard

<img width="1413" height="682" alt="Screenshot 2026-06-21 at 3 50 08 PM" src="https://github.com/user-attachments/assets/c32db078-cc2e-4873-bec9-1295d9f6565b" />

Interactive dashboard visualizing:
- Global total cases and death counts
- Total deaths per continent
- Percent population infected per country (map)
- Country-level infection forecasts (US, UK, India, China, Mexico)



## Project Structure

```
covid-data-analysis/
│
├── notebooks/
│   ├── 01_correlation_analysis.ipynb     # EDA, correlation analysis
│   └── 02_vaccination_analysis.ipynb     # Vaccination vs mortality analysis
│
├── sql/
│   └── covid_data_exploration.sql        # SQL queries for data exploration
│
├── data/
│   ├── raw/                              # Original datasets (CovidDeaths, CovidVaccinations)
│   └── processed/                        # Cleaned and joined datasets
│
├── results/
│   └── vaccination_vs_deaths.png         # Vaccination rate vs death rate by country
│
├── sql_to_tableau_table.py               # Automated SQL → Excel pipeline for Tableau
├── tableau workbook.twbx                 # Interactive Tableau dashboard
└── README.md
```



## Notebooks (Recommended Order)

| # | Notebook | Topics |
|---|---|---|
| 1 | Correlation Analysis | EDA, feature correlations, death rate trends |
| 2 | Vaccination Analysis | Vaccination vs mortality, Pearson correlation by country |



## Installation

```bash
git clone https://github.com/rsylee/covid-data-analysis.git
cd covid-data-analysis
pip install -r requirements.txt
```


## Requirements

```
pandas
matplotlib
seaborn
sqlalchemy
pymysql
openpyxl
```


## Dataset

- **Source:** Our World in Data — COVID-19 Dataset
- **Size:** 85,000+ records across 200+ countries
- **Period:** January 2020 – May 2021