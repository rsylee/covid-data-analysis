# runs the SQL query, fills any NULL values with 0, and saves the result as an excel file.
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('mysql+pymysql://root:@localhost/covid_analysis_project')

# paste SQL query to fetch the data you want to export
df = pd.read_sql("""
SELECT location, population, date, 
       MAX(total_cases) AS HighestInfectionCount, 
       MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM coviddeaths
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC
""", engine)

df['date'] = pd.to_datetime(df['date'], format='%m/%d/%y').dt.date # filter date in ascending order
df = df.sort_values('date')
df.fillna(0, inplace=True)
df.to_excel('/Users/rachellee/Desktop/projects/covidDataAnalysis/tableau_table4.xlsx', index=False)
print('done! number of rows:', len(df))