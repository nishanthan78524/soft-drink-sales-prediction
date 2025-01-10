import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Load data
df = pd.read_csv('data/final_data/model_data.csv')

# Step 1: Ensure "Sale Date" is in datetime format
df['Sale Date'] = pd.to_datetime(df['Sale Date'], errors='coerce')

# Step 2: Filter data for the specific Barcode 5054267013100
barcode_to_filter = 5054267013100
df_barcode = df[df['Barcode'] == barcode_to_filter]

# Step 3: Aggregate the "Quantity Sold" by "Sale Date" for the filtered Barcode
quantity_sold_over_time = df_barcode.groupby('Sale Date')['Quantity Sold'].sum().reset_index()

# Step 4: Plot the line chart for "Quantity Sold" over time for the specific Barcode
plt.figure(figsize=(10, 6))
sns.lineplot(x='Sale Date', y='Quantity Sold', data=quantity_sold_over_time)
plt.title(f'Aggregate Quantity Sold Over Time for Barcode {barcode_to_filter}')
plt.xlabel('Sale Date')
plt.ylabel('Quantity Sold')
plt.xticks(rotation=45, ha='right')  # Rotate the x-axis labels for better readability
plt.tight_layout()

# Step 5: Save the line plot as an image
plt.savefig(f'visuals/quantity_sold_over_time_barcode_{barcode_to_filter}.png')
plt.close() 
