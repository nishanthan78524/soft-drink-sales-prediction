import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# Load data
df = pd.read_csv('data/final_data/model_data.csv')

# Calculate correlations and get top/bottom correlations
numeric_columns = df.select_dtypes(include=['number'])
numeric_corr = numeric_columns.corr()

# Get the upper triangle of the correlation matrix to avoid duplication
upper_triangle = numeric_corr.where(np.triu(np.ones(numeric_corr.shape), k=1).astype(bool))

# Unstack the upper triangle matrix and sort the values
sorted_correlations = upper_triangle.stack().sort_values()

# Get the top 3 highest and bottom 3 lowest correlations
top_positive = sorted_correlations.tail(3)  # Top 3 highest positive correlations
top_negative = sorted_correlations.head(3)  # Top 3 lowest negative correlations

# Combine them into a DataFrame for easy plotting
correlation_to_plot = pd.concat([top_positive, top_negative])

# Save heatmap visualization of the selected correlations
plt.figure(figsize=(8, 6))
sns.heatmap(correlation_to_plot.values.reshape(1, -1), annot=True, cmap='coolwarm', center=0, 
            xticklabels=correlation_to_plot.index, yticklabels=["Correlation"])
plt.title("Top Positive and Negative Correlations")
plt.savefig('visuals/top_positive_negative_correlations_heatmap.png')  # Save the heatmap as an image
plt.close()  # Close the plot to avoid displaying it

# Extract individual features from tuples for positive and negative correlations
top_positive_pairs = top_positive.index.tolist()
top_negative_pairs = top_negative.index.tolist()

# Create and save individual scatter plots for top positive correlations
for feature_x, feature_y in top_positive_pairs:
    plt.figure(figsize=(6, 4))
    sns.scatterplot(x=df[feature_x], y=df[feature_y], alpha=0.7, edgecolor='black')
    plt.title(f'Scatter Plot of {feature_x} vs {feature_y}')
    plt.xlabel(feature_x)
    plt.ylabel(feature_y)
    plt.savefig(f'visuals/scatter_{feature_x}_vs_{feature_y}.png')  # Save the scatter plot
    plt.close()  # Close the plot

# Create and save individual scatter plots for top negative correlations
for feature_x, feature_y in top_negative_pairs:
    plt.figure(figsize=(6, 4))
    sns.scatterplot(x=df[feature_x], y=df[feature_y], alpha=0.7, edgecolor='black')
    plt.title(f'Scatter Plot of {feature_x} vs {feature_y}')
    plt.xlabel(feature_x)
    plt.ylabel(feature_y)
    plt.savefig(f'visuals/scatter_{feature_x}_vs_{feature_y}.png')  # Save the scatter plot
    plt.close()  # Close the plot
