import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score
import matplotlib.pyplot as plt

# load data
df = pd.read_csv('/Users/rachellee/Desktop/projects/covidDataAnalysis/CovidDeaths.csv')
df = df[df['continent'].notna() & (df['continent'] != '')]

# prep data / data cleaning
df['date'] = pd.to_datetime(df['date'], format='%m/%d/%y')
df['days'] = (df['date'] - df['date'].min()).dt.days
df = df[['days', 'total_cases', 'total_deaths', 'population', 'new_deaths', 'new_cases']].dropna() # now added new_deaths and new_cases

X = df[['days', 'total_deaths', 'population', 'new_deaths', 'new_cases']]
y = df['total_cases']

# train/test split (with mroe features)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42) # 20% for testing

# train model
model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# evaluate
y_pred = model.predict(X_test)
print(f'R² Score: {r2_score(y_test, y_pred):.4f}')
print(f'RMSE: {np.sqrt(mean_squared_error(y_test, y_pred)):,.0f}')

# plot 1 - actual vs predicted
# this fig is comparable to one generated with linear regression
plt.figure(figsize=(10, 6))
plt.scatter(y_test, y_pred, alpha=0.3)
plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'r--')
plt.xlabel('Actual Cases')
plt.ylabel('Predicted Cases')
plt.title('Actual vs Predicted COVID-19 Cases - Random Forest')
plt.tight_layout()
plt.savefig('/Users/rachellee/Desktop/projects/covidDataAnalysis/random_forest_actual_vs_predicted.png') 

# plot 2 - feature importance 
plt.figure(figsize=(8, 5))
importances = pd.Series(model.feature_importances_, index=X.columns)
importances.sort_values().plot(kind='barh')
plt.title('Feature Importance - Random Forest')
plt.tight_layout()
plt.savefig('/Users/rachellee/Desktop/projects/covidDataAnalysis/random_forest_feature_importance.png')