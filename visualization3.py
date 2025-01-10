import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# Load data
df = pd.read_csv('data/final_data/model_data.csv')

# Calculate correlations between features and "Quantity Sold", excluding "Barcode"
numeric_columns = df.select_dtypes(include=['number']).drop(columns=["Barcode"])  # Exclude "Barcode"
numeric_corr = numeric_columns.corr()

# Focus on the correlations with "Quantity Sold"
quantity_sold_corr = numeric_corr["Quantity Sold"].drop("Quantity Sold")  # Exclude self-correlation

# Sort the correlations to get top 5 positive and top 5 negative correlations
top_positive_corr = quantity_sold_corr.sort_values(ascending=False).head(5)  # Top 5 positive correlations
top_negative_corr = quantity_sold_corr.sort_values(ascending=True).head(5)   # Top 5 negative correlations

# Combine them into a Series for easy plotting
correlation_to_plot = pd.concat([top_positive_corr, top_negative_corr])

# Save heatmap visualization of the selected correlations
plt.figure(figsize=(8, 6))
sns.heatmap(correlation_to_plot.values.reshape(1, -1), annot=True, cmap='coolwarm', center=0,
            xticklabels=correlation_to_plot.index, yticklabels=["Correlation with Quantity Sold"])
plt.xticks(rotation=45, ha='right')  # Rotate and align x-axis labels to the right
plt.title("Top Positive and Negative Correlations with Quantity Sold")
plt.tight_layout()
plt.savefig('visuals/top_positive_negative_correlations_with_quantity_sold_heatmap.png')  # Save the heatmap as an image
plt.close()  # Close the plot to avoid displaying it

# Extract the feature names for top positive and negative correlations
top_positive_features = top_positive_corr.index.tolist()
top_negative_features = top_negative_corr.index.tolist()

# Create and save individual scatter plots for top positive correlations with "Quantity Sold"
for feature in top_positive_features:
    plt.figure(figsize=(6, 4))
    sns.scatterplot(x=df[feature], y=df["Quantity Sold"], alpha=0.7, edgecolor='black')
    plt.title(f'Scatter Plot of Quantity Sold vs {feature}')
    plt.xlabel(feature)
    plt.ylabel("Quantity Sold")
    plt.savefig(f'visuals/possitive_correlation_scatter_quantity_sold_vs_{feature}.png')  # Save the scatter plot
    plt.close()  # Close the plot

# Create and save individual scatter plots for top negative correlations with "Quantity Sold"
for feature in top_negative_features:
    plt.figure(figsize=(6, 4))
    sns.scatterplot(x=df[feature], y=df["Quantity Sold"], alpha=0.7, edgecolor='black')
    plt.title(f'Scatter Plot of Quantity Sold vs {feature}')
    plt.xlabel(feature)
    plt.ylabel("Quantity Sold")
    plt.savefig(f'visuals/negative_correlation_scatter_quantity_sold_vs_{feature}.png')  # Save the scatter plot
    plt.close()  # Close the plot
