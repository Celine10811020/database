import pandas as pd
df = pd.read_parquet('yellow_tripdata_2022-01.parquet')
df.to_csv('output.csv')